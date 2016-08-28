module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Html.App as App
import String


type alias Model =
    { players : List Player
    , selectedPlayerId : Maybe Int
    , name : String
    , plays : List Play
    }


type alias Player =
    { id : Int
    , name : String
    }


type alias Play =
    { id : Int
    , playerId : Int
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
    = Input String
    | Save
    | Cancel
    | StartEditing Player
    | Score Player Int
    | DeletePlay Play


update : Msg -> Model -> Model
update msg model =
    case msg of
        Input name ->
            { model | name = name }

        Cancel ->
            model |> clearInput

        Save ->
            if (model.name |> String.isEmpty) then
                model
            else
                model
                    |> save
                    |> clearInput

        Score player points ->
            score model player points

        StartEditing player ->
            { model
                | selectedPlayerId = Just player.id
                , name = player.name
            }

        DeletePlay play ->
            deletePlay model play


clearInput : Model -> Model
clearInput model =
    { model
        | name = ""
        , selectedPlayerId = Nothing
    }


save : Model -> Model
save model =
    case model.selectedPlayerId of
        Just id ->
            edit model id

        Nothing ->
            addPlayer model


addPlayer : Model -> Model
addPlayer model =
    { model
        | players = (newPlayer model) :: model.players
    }


newPlayer : Model -> Player
newPlayer model =
    let
        newId =
            model.players
                |> List.length
                |> (+) 1
    in
        { id = newId
        , name = model.name
        }


edit : Model -> Int -> Model
edit model playerId =
    let
        editPlayer p =
            if (p.id /= playerId) then
                p
            else
                { p | name = model.name }
    in
        { model
            | players =
                model.players
                    |> List.map editPlayer
        }


score : Model -> Player -> Int -> Model
score model player newPoints =
    let
        newPlayId =
            model.plays
                |> List.length
                |> (+) 1

        newPlay : Play
        newPlay =
            { id = newPlayId
            , playerId = player.id
            , points = newPoints
            }
    in
        { model
            | plays = newPlay :: model.plays
        }


deletePlay : Model -> Play -> Model
deletePlay model play =
    { model
        | plays =
            model.plays
                |> List.filter (\p -> p /= play)
    }


view : Model -> Html Msg
view model =
    div [ class "scoreboard" ]
        [ h1 [] [ text "Score Keeper" ]
        , playerSection model
        , playerForm model
        , playSection model
        ]


playerSection : Model -> Html Msg
playerSection model =
    div []
        [ playerListHeader
        , playerList model
        , pointTotal model
        ]


playerListHeader : Html Msg
playerListHeader =
    header []
        [ div [] [ text "Name" ]
        , div [] [ text "Points" ]
        ]


playerList : Model -> Html Msg
playerList model =
    model.players
        |> List.sortBy .name
        |> List.map (player model)
        |> ul []


pointsFor : Model -> Player -> Int
pointsFor model player =
    model.plays
        |> List.filter (\p -> p.playerId == player.id)
        |> List.map (\p -> p.points)
        |> List.sum


player : Model -> Player -> Html Msg
player model player =
    let
        points =
            pointsFor model player

        playerNameAttributes =
            if (model.selectedPlayerId == Just player.id) then
                [ class "edit" ]
            else
                []
    in
        li []
            [ i
                [ class "edit"
                , onClick (StartEditing player)
                ]
                []
            , div playerNameAttributes
                [ text player.name ]
            , button
                [ type' "button"
                , onClick (Score player 2)
                ]
                [ text "2pt" ]
            , button
                [ type' "button"
                , onClick (Score player 3)
                ]
                [ text "3pt" ]
            , div []
                [ text (toString points) ]
            ]


pointTotal : Model -> Html Msg
pointTotal model =
    let
        total =
            model.players
                |> List.map (pointsFor model)
                |> List.sum
    in
        footer []
            [ div [] [ text "Total:" ]
            , div [] [ text (toString total) ]
            ]


playerForm : Model -> Html Msg
playerForm model =
    let
        inputClass =
            if (model.selectedPlayerId /= Nothing) then
                "edit"
            else
                ""
    in
        Html.form [ onSubmit Save ]
            [ input
                [ type' "text"
                , placeholder "Add/Edit Player name..."
                , onInput Input
                , value model.name
                , class inputClass
                ]
                []
            , button [ type' "submit" ] [ text "Save" ]
            , button [ type' "button", onClick Cancel ] [ text "Cancel" ]
            ]


playSection : Model -> Html Msg
playSection model =
    div []
        [ playListHeader
        , playList model
        ]


playListHeader : Html Msg
playListHeader =
    header []
        [ div [] [ text "Plays" ]
        , div [] [ text "Points" ]
        ]


playList : Model -> Html Msg
playList model =
    model.plays
        |> List.map (play model.players)
        |> ul []


findPlayer : List Player -> Int -> Player
findPlayer players playerId =
    players
        |> List.filter (\p -> p.id == playerId)
        |> List.head
        |> Maybe.withDefault
            { id = -1
            , name = "unknown player"
            }


play : List Player -> Play -> Html Msg
play players play =
    let
        player =
            findPlayer players play.playerId
    in
        li []
            [ i
                [ class "remove"
                , onClick (DeletePlay play)
                ]
                []
            , div [] [ text (player.name) ]
            , div [] [ text (toString play.points) ]
            ]


main : Program Never
main =
    App.beginnerProgram
        { model = initModel
        , update = update
        , view = view
        }
