module PhotoGroove exposing (main)

import Browser
import Html exposing (Html, div, h1, h3, img, text, button, input, label)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Array exposing (Array)
import Random

type alias Photo = 
  { url : String }

type ThumbnailSize 
  = Small
  | Medium 
  | Large
  
type Msg 
  = ClickedPhoto String -- messages can take parameters!
  | GotSelectedIndex Int
  | ClickedSize ThumbnailSize -- messages can take parameters!
  | ClickedSurpriseMe

urlPrefix : String
urlPrefix = "http://elm-in-action.com/"

type alias Model = 
  { photos : List Photo
  , selectedUrl : String
  , chosenSize : ThumbnailSize
  }

initialModel : Model
initialModel = 
  { photos = 
    [ { url = "1.jpeg" }
    , { url = "2.jpeg" }
    , { url = "3.jpeg" }
    ]
    , selectedUrl = "1.jpeg"
    , chosenSize = Small
  }

photoArray : Array Photo
photoArray = 
  Array.fromList initialModel.photos

randomPhotoPicker : Random.Generator Int 
randomPhotoPicker =
  Random.int 0 (Array.length photoArray - 1)

getPhotoUrl : Int -> String
getPhotoUrl index = 
  case Array.get index photoArray of 
    Just photo ->
      photo.url 
    
    Nothing -> 
      ""


--view : { a | selectedUrl : String, photos : List { b | url : String } } -> Html.Html { description : String, data : String }
view : Model -> Html Msg
view model = 
  div [ class "content" ]
    [ h1 [] [ text "Photo Groove" ]
    , button [ onClick ClickedSurpriseMe ]
      [ text "Surprise Me!" ]
    , h3 [] [ text "Thumbnail Size:" ]
    , div [ id "choose-size" ]
      -- [ viewSizeChooser Small, viewSizeChooser Medium, viewSizeChooser Large]
      (List.map viewSizeChooser [ Small, Medium, Large ])
    , div [ id "thumbnails", class (sizeToString model.chosenSize) ] 
      ( List.map 
        (viewThumbnail model.selectedUrl)
        model.photos
      )
      , img 
        [ class "large"
        , src (urlPrefix ++ "large/" ++ model.selectedUrl)
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
    GotSelectedIndex index -> 
      ( {model | selectedUrl = getPhotoUrl index }, Cmd.none)
    ClickedPhoto url -> 
      ( { model | selectedUrl = url }, Cmd.none  )

    ClickedSize size -> 
      ( { model | chosenSize = size }, Cmd.none )
    
    ClickedSurpriseMe ->
      ( model , Random.generate GotSelectedIndex randomPhotoPicker )
      -- model isn't changed; returned as-is
      -- the "command" is the ra`ndom number generater
      -- which will generate the GotSelectedIndex message
      -- and return this update function at the top to 
      -- set the index
