module Helpers exposing (..)

import Task
import Process

delayMsg : Float -> msg -> Cmd msg
delayMsg delay msg =
    Task.perform (always msg) (Process.sleep delay)
