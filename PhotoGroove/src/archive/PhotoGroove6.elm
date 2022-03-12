module PhotoGroove exposing (main)

import Browser
import Html exposing (Html, div, h1, img, text)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Array exposing (Array)

type alias Photo = 
	{ url : String }

type alias Model = 
  { photos : List Photo
  , selectedUrl : String
  }

type alias Msg =
  { description : String, data : String }

urlPrefix : String
urlPrefix = "http://elm-in-action.com/"

initialModel : Model
initialModel = 
  { photos = 
    [ { url = "1.jpeg" }
    , { url = "2.jpeg" }
    , { url = "3.jpeg" }
    ]
    , selectedUrl = "1.jpeg"
  }

photoArray : Array Photo
photoArray = 
  Array.fromList initialModel.photos

--view : { a | selectedUrl : String, photos : List { b | url : String } } -> Html.Html { description : String, data : String }
view : Model -> Html Msg
view model = 
  div [ class "content" ]
    [ h1 [] [ text "Photo Groove" ]
    , button [ onClick {description = "ClickedSurpriseMe", data = ""} ]
      [ text "Surprise Me!" ]
    , div [ id "thumbnails" ] 
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
      , onClick { description = "ClickedPhoto", data = thumb.url }
      ] []

main = 
  Browser.sandbox
    { init = initialModel
    , view = view
    , update = update
    }

update : Msg -> Model -> Model
update msg model = 
  if msg.description == "ClickedPhoto" then 
    { model | selectedUrl = msg.data }
  else if msg.description == "ClickedSurpriseMe" then
    { model | selectedUrl = "2.jpeg" }
  else 
    model

{-
      [ img  [ src "http://elm-in-action.com/1.jpeg" ] []
      , img  [ src "http://elm-in-action.com/2.jpeg" ] []
      , img  [ src "http://elm-in-action.com/3.jpeg" ] []
      ]

-}