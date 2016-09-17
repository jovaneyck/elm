module Main exposing (..)

import Html exposing (..)
import String exposing (..)


(~=) : String -> String -> Bool
(~=) one other =
    left 1 one == left 1 other


main : Html a
main =
    (~=) "Hello" "Hello"
        |> toString
        |> text
