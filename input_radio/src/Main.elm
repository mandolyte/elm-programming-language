module Main exposing (..)

import Browser
import Element exposing (..)
import Element.Background as Background
import Element.Font as Font
import Element.Input as Input
import Element.Region as Region
import Html exposing (..)

grey : Color
grey =
    Element.rgb 0.9 0.9 0.9


blue : Color
blue =
    Element.rgb255 6 176 242

white : Color
white =
    Element.rgb 1 1 1


main : Program () Model Msg
main =
    Browser.sandbox
        { init = init
        , view = view
        , update = update
        }

type alias Answer =
    { id: String
    , description : String
    }


type alias Question =
    { id: Int
    , description : String
    , selectedAnswer : String -- id of answer
    , answers : List Answer
    }


type alias Model =
    { title : String
    , questions : List Question
    }


init : Model
init =
    Model "Title of Quiz" 
        [ Question 0
            "¿This is question 1?"
            ""
            [ Answer "a1" "This is answer 1.1"
            , Answer "a2" "This is answer 1.2"
            , Answer "a3" "All of above 1.3."
            , Answer "a4" "None of above 1.4."
            ]
        , Question 1
            "¿This is question 2?"
            ""
            [ Answer "a5" "This is q2, answer 1."
            , Answer "a6" "This is q2, answer 2."
            , Answer "a7" "All of above 2.3"
            , Answer "a8" "None of above 2.4."
            ]
        , Question 2
            "¿This is question 3?"
            ""
            [ Answer "a9" "This is q3, answer 1."
            , Answer "a10" "This is q3, answer 2."
            , Answer "a11" "All of above 3.3"
            , Answer "a12" "None of above 3.4."
            ]
        ]

type Msg = 
    Update Int String


update : Msg -> Model -> Model
update msg model =
    case Debug.log "msg" msg of
        Update newq newa ->
            { model | questions = newa }


makeInput : Answer -> Input.Option String Msg
makeInput answer =
    Input.option answer.id (Element.text answer.description)

view : Model -> Html Msg
view model =
    Element.layout
        [ Font.size 20
        ]
    <|
        Element.column
            [ width (px 800)
            , height shrink
            , centerY
            , centerX
            , spacing 36
            , padding 100
            ]
            [ el
                [ Region.heading 1
                , alignLeft
                , Font.size 36
                ]
                (Element.text model.title)
            , viewQuestions model
            ]


viewQuestions : Model -> List Element msg
viewQuestions model =
    List.map (\q -> viewQuestion q) model.questions

viewQuestion : Question -> Element
viewQuestion question =
    Input.radio
        [ spacing 12
        , padding 10
        , Background.color grey
        ]
        { selected = Just question.selectedAnswer
        , onChange = \new -> Debug.log new
        , label = Input.labelAbove [ Font.size 20, paddingXY 0 12 ] (Element.text question.description)
        , options = List.map makeInput question.answers
        }
