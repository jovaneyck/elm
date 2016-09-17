module Main exposing (..)

import Html exposing (..)
import String exposing (..)


uppercaseLong name =
    if length name > 10 then
        toUpper name
    else
        name


printName name =
    let
        l =
            length name
    in
        (uppercaseLong name) ++ " - of length " ++ (toString l)


main =
    div
        []
        [ div [] [ text (printName "Jo") ]
        , div [] [ text (printName "Ragoth, bringer of doom.") ]
        ]
