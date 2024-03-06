module Helpers exposing (..)

import Html exposing (Html)
import Process
import Task


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
