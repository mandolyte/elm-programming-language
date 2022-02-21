module Main exposing (..)

-- Press buttons to increment and decrement a counter.
--
-- Read how it works:
--   https://guide.elm-lang.org/architecture/buttons.html
--


import Browser
import Html exposing (Html, button, div, text, br)
import Html.Events exposing (onClick)



-- MAIN


main =
  Browser.sandbox { init = init, update = update, view = view }


-- MODEL


type alias Model = Int


init : Model
init =
  0



-- UPDATE


type Msg
  = Increment
  | IncBy10
  | Decrement
  | Reset


update : Msg -> Model -> Model
update msg model =
  case msg of
    Increment ->
      model + 1
      
    IncBy10 ->
      model + 10

    Decrement ->
      model - 1
      
    Reset ->
      init



-- VIEW


view : Model -> Html Msg
view model =
  div []
    [ button [ onClick Decrement ] [ text "decrement" ]
    , div [] [ text (String.fromInt model) ]
    , button [ onClick Increment ] [ text "increment" ]
    , div [] [ 
      button [ onClick Reset] [ text "RESET!"] 
      , br [] []
      , button [onClick IncBy10 ] [text "Increment by 10"]
    ]
    

    ]
