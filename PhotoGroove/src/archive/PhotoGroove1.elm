module PhotoGroove exposing (main)

import Html exposing (div, h1, img, text)
import Html.Attributes exposing (..)

urlPrefix = "http://elm-in-action/"

initialModel = 
  { photos = 
    [ { url = "1.jpeg" }
    , { url = "2.jpeg" }
    , { url = "3.jpeg" }
    ]
    , selectedUrl = "1.jpeg"
  }

view model = 
  div [ class "content" ]
    [ h1 [] [ text "Photo Groove" ]
    , div [ id "thumbnails" ] (List.map viewThumbnail model)
    ]

viewThumbnail selectedUrl thumb =
  if selectedUrl == thumb.url then
    img 
      [ src (urlPrefix ++ thumb.url) 
      , class "selected"
      ] []
  else 
    img
      [ src (urlPrefix ++ thumb.url) ]
      []
      
main = 
  view initialModel  

{-
      [ img  [ src "http://elm-in-action.com/1.jpeg" ] []
      , img  [ src "http://elm-in-action.com/2.jpeg" ] []
      , img  [ src "http://elm-in-action.com/3.jpeg" ] []
      ]

-}