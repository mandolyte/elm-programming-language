module PhotoGroove exposing (main)

import Browser
import Html exposing (Html, div, h1, h3, img, text, button, input, label)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Random

type alias Photo = 
  { url : String }

type ThumbnailSize 
  = Small
  | Medium 
  | Large
  
type Msg 
  = ClickedPhoto String -- messages can take parameters!
  | ClickedSize ThumbnailSize -- messages can take parameters!
  | ClickedSurpriseMe
  | GotRandomPhoto Photo

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

viewLoaded : List Photo -> String -> ThumbnailSize -> List (Html Msg)
viewLoaded photos selectedUrl chosenSize =
  [ h1 [] [ text "Photo Groove" ]
  , button 
    [ onClick ClickedSurpriseMe ]
    [ text "Surprise Me!" ]
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

main : Program () Model Msg
main = 
  Browser.element
    { init = \flags -> (initialModel, Cmd.none)
    , view = view
    , update = update
    , subscriptions = \model -> Sub.none
    }

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

selectUrl : String -> Status -> Status
selectUrl url status =
  case status of 
    Loaded photos _ -> 
      Loaded photos url

    Loading -> 
      status

    Errored errorMessage -> 
      status