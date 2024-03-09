module Helpers exposing (..)

import Html exposing (Html)
import Process
import Task


unwrapMaybeLocTuple : ( Maybe a, Maybe a ) -> Maybe ( a, a )
unwrapMaybeLocTuple ( x, y ) =
    case ( x, y ) of
        ( Just x2, Just y2 ) ->
            Just ( x2, y2 )

        _ ->
            Nothing


delayMsg : Float -> msg -> Cmd msg
delayMsg delay msg =
    Task.perform (always msg) (Process.sleep delay)


strIf : Bool -> String -> String
strIf cond r =
    if cond then
        r

    else
        ""


htmlIf : Bool -> Html msg -> Html msg
htmlIf cond html =
    if cond then
        html

    else
        Html.text ""


maybeIf : Bool -> r -> Maybe r
maybeIf cond r =
    if cond then
        Just r

    else
        Nothing
