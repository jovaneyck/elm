module Main exposing (..)

import Html


type alias Item =
    { name : String
    , qty : Int
    , freeQty : Int
    }


type alias Cart =
    List Item


free : Int -> Int -> Item -> Item
free treshold bonus item =
    if item.freeQty == 0 && item.qty >= treshold then
        { item | freeQty = item.qty // treshold * bonus }
    else
        item


cart : Cart
cart =
    [ { name = "Lemon", qty = 1, freeQty = 0 }
    , { name = "Apple", qty = 5, freeQty = 0 }
    , { name = "Pear", qty = 20, freeQty = 0 }
    ]


main : Html.Html msg
main =
    let
        updated =
            cart |> List.map ((free 10 3) >> (free 5 1))
    in
        Html.text (updated |> toString)
