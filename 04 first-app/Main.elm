module Main exposing (..)

import Html exposing (..)
import Html.App exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import String


type alias Model =
    { calories : Int, input : Int, error : Maybe String }


initModel : Model
initModel =
    { calories = 0, input = 0, error = Nothing }


type Msg
    = AddCalorie
    | CaloriesInputChanged String
    | Clear


parseInput : String -> Model -> Model
parseInput value model =
    case String.toInt value of
        Ok parsed ->
            { model | input = parsed, error = Nothing }

        Err msg ->
            { model | input = 0, error = Just (value ++ " is not a valid number.") }


update : Msg -> Model -> Model
update msg model =
    case msg of
        AddCalorie ->
            { model | calories = model.calories + model.input, input = 0 }

        CaloriesInputChanged value ->
            parseInput value model

        Clear ->
            initModel


view : Model -> Html Msg
view model =
    div []
        [ h3 [] [ text ("Total calories: " ++ (toString model.calories)) ]
        , input
            [ type' "text"
            , value
                (if model.input == 0 then
                    ""
                 else
                    toString model.input
                )
            , onInput CaloriesInputChanged
            ]
            []
        , br [] []
        , div [] [ text (Maybe.withDefault "" model.error) ]
        , br [] []
        , button [ onClick AddCalorie ] [ text "Add" ]
        , button [ onClick Clear ] [ text "Clear" ]
        ]


main : Program Never
main =
    Html.App.beginnerProgram
        { model = initModel
        , update = update
        , view = view
        }
