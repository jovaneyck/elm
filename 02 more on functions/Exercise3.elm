module Main exposing (..)

import Html
import String


wordCount : String -> Int
wordCount =
    String.words >> List.length


main : Html.Html a
main =
    "This is a sentence with 7 words."
        |> wordCount
        |> toString
        |> Html.text
