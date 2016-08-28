module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.App exposing (..)


type alias Model =
    { players : List Player
    , name : String
    , selectedPlayerId : Maybe Int
    , plays : List Play
    }


type alias PlayerId =
    Int


type alias Player =
    { id : PlayerId
    , name : String
    , points : Int
    }


type alias PlayId =
    Int


type alias Play =
    { id : PlayId
    , playerId : Int
    , name : String
    , points : Int
    }


initModel : Model
initModel =
    { name = ""
    , players = []
    , plays = []
    , selectedPlayerId = Nothing
    }


type Msg
    = Edit Player
    | Score Player Int
    | Input String
    | Save
    | Cancel
    | DeletePlay Play


update : Msg -> Model -> Model
update msg model =
    case msg of
        Input name ->
            { model | name = name }

        _ ->
            model


view : Model -> Html Msg
view model =
    div [ class "scoreboard" ]
        [ h1 [] [ text "Score Keeper" ]
        , playerForm model
        , p [] [ text (toString model) ]
        ]


playerForm : Model -> Html Msg
playerForm model =
    Html.form [ onSubmit Save ]
        [ input
            [ type' "text"
            , placeholder "Add/Edit Player name..."
            , onInput Input
            , value model.name
            ]
            []
        , button [ type' "submit" ] [ text "Save" ]
        , button [ type' "button", onClick Cancel ] [ text "Cancel" ]
        ]


main : Program Never
main =
    Html.App.beginnerProgram
        { model = initModel
        , update = update
        , view = view
        }
