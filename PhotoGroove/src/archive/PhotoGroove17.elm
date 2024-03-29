module PhotoGroove exposing (main)

import Browser
import Html exposing (Html, node, div, h1, h3, img, text, button, input, label)
import Html.Attributes as Attr exposing (class, classList, id, name, src, title, type_)
import Html.Events exposing (on, onClick)
import Json.Encode as Encode
import Random
import Http
import Json.Decode as J exposing (Decoder, at, int, list, string, succeed)
import Json.Decode.Pipeline as JP exposing (optional, required)
import Html exposing (Attribute)
import List exposing (range)
import Html exposing (details)

type alias Photo = 
  { url : String 
  , size : Int
  , title : String 
  }

photoDecoder : Decoder Photo 
photoDecoder = 
  succeed Photo
    |> JP.required "url" string 
    |> JP.required "size" int 
    |> JP.optional "title" string "(untitled)" -- default value



type ThumbnailSize 
  = Small
  | Medium 
  | Large
  
type Msg 
  = ClickedPhoto String -- messages can take parameters!
  | ClickedSize ThumbnailSize -- messages can take parameters!
  | ClickedSurpriseMe
  | GotRandomPhoto Photo
  | GotPhotos (Result Http.Error (List Photo))

urlPrefix : String
urlPrefix = "http://elm-in-action.com/"


type Status
  = Loading
  | Loaded (List Photo) String -- string is the selected photo url
  | Errored String 

type alias Model = 
  { status : Status
  , chosenSize : ThumbnailSize
  }

initialModel : Model
initialModel = 
  { status = Loading
    , chosenSize = Small
  }


view : Model -> Html Msg
view model = 
  div [ class "content" ] <|
    case model.status of
      Loaded photos selectedUrl -> 
        viewLoaded photos selectedUrl model.chosenSize

      Loading -> 
        []

      Errored errorMessage ->
        [text ("Error: " ++ errorMessage)]    

viewFilter : String -> Int -> Html Msg
viewFilter name magnitude = 
  div [ class "filter-slider" ]
      [ label [] [ text name ]
      , rangeSlider
        [ Attr.max "11" 
        , Attr.property "val" (Encode.int magnitude)
        ]
        []
      , label [] [ text (String.fromInt magnitude) ]
      ]

viewLoaded : List Photo -> String -> ThumbnailSize -> List (Html Msg)
viewLoaded photos selectedUrl chosenSize =
  [ h1 [] [ text "Photo Groove" ]
  , button 
    [ onClick ClickedSurpriseMe ]
    [ text "Surprise Me!" ]
  , div [ class "filters" ]
    [ viewFilter "Hue" 0
    , viewFilter "Ripple" 0
    , viewFilter "Noise" 0
    ]
  , h3 [] [ text "Thumbnail Size:" ]
  , div [ id "choose-size" ]
    (List.map viewSizeChooser [ Small, Medium, Large ])
  , div [ id "thumbnails", class (sizeToString chosenSize) ]
    (List.map (viewThumbnail selectedUrl) photos)
  , img
    [ class "large" 
    , src (urlPrefix ++ "large/" ++ selectedUrl)
    ]
    []
  ]
    
viewThumbnail : String -> Photo -> Html Msg
viewThumbnail selectedUrl thumb =
    img 
      [ src (urlPrefix ++ thumb.url) 
      , title (thumb.title ++ " [" ++ String.fromInt thumb.size ++ " KB]")
      , classList [ ("selected", selectedUrl == thumb.url) ] 
      , onClick (ClickedPhoto thumb.url) -- messages can take parameters!
      ] []

viewSizeChooser : ThumbnailSize -> Html Msg 
viewSizeChooser size = 
  label []
    [ input [ type_ "radio", name "size", onClick (ClickedSize size) ] []
    , text (sizeToString size)
    ]

sizeToString : ThumbnailSize -> String 
sizeToString size = 
  case size of 
    Small -> 
      "small" 

    Medium -> 
      "med" 

    Large -> 
      "large"


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model = 
  case msg of 
    GotRandomPhoto photo -> 
      ( {model | status = selectUrl photo.url model.status}
      , Cmd.none)

    ClickedPhoto url -> 
      ( { model | status = selectUrl url model.status}, Cmd.none  )

    ClickedSize size -> 
      ( { model | chosenSize = size }, Cmd.none )
    
    ClickedSurpriseMe ->
      case model.status of 
        Loaded (firstPhoto :: otherPhotos) _ -> 
          Random.uniform firstPhoto otherPhotos
          |> Random.generate GotRandomPhoto
          |> Tuple.pair model
          -- NOTE! The value piped to Tuple.pair
          -- becomes the last value (second value)
          -- required for the Tuple.pair function

        Loaded [] _ -> 
          ( model, Cmd.none )
        
        Loading -> 
          ( model, Cmd.none )

        Errored errorMessage -> 
          ( model, Cmd.none )
    -- could also avoid the nested case by using more explicit cases:
    -- GotPhotos (Ok responseStr) ->
    -- and
    -- GotPhotos (Err httpError) ->
    -- or, if we cover the error by having an empty list, then
    -- GotPhotos (Err _) -- ignore the error text
    GotPhotos (Ok photos) ->
      case photos of 
            (first :: _ ) as urls ->
              ( { model | status = Loaded photos first.url }, Cmd.none)

            [] ->
              ( { model | status = Errored "0 photos found" }, Cmd.none)

    GotPhotos (Err httpError) ->   
          ( {model | status = Errored "Server error"}, Cmd.none )

selectUrl : String -> Status -> Status
selectUrl url status =
  case status of 
    Loaded photos _ -> 
      Loaded photos url

    Loading -> 
      status

    Errored errorMessage -> 
      status

initialCmd : Cmd Msg
initialCmd =
  Http.get
    { url = "http://elm-in-action.com/photos/list.json"
    , expect = Http.expectJson GotPhotos (J.list photoDecoder)
    }
--     , expect = Http.expectString (\result -> GotPhotos result)

main : Program () Model Msg
main = 
  Browser.element
    { init = \_ -> (initialModel, initialCmd)
    , view = view
    , update = update
    , subscriptions = \_ -> Sub.none
    }

rangeSlider : List (Attribute msg) -> List (Html msg) -> Html msg
rangeSlider attributes children =
  node "range-slider" attributes children

onslide : (Int -> msg) -> Attribute msg 
onslide toMsg =
  let
    detailUserSlidTo : Decoder Int
    detailUserSlidTo = 
      at ["detail", "userSlidTo"] int 
    
    msgDecoder : Decoder msg
    msgDecoder = 
      Json.Decode.map toMsg detailUserSlidTo

  in 
    on "slide" msgDecoder