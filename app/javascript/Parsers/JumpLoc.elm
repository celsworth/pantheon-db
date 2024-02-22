module Parsers.JumpLoc exposing ( parse)

import Parser exposing ((|.), (|=), Parser, float, keyword, spaces, succeed)
import Types exposing (Loc)




parse : String -> Maybe Loc
parse str =
    case Parser.run jumploc str of
        Ok loc ->
            Just loc

        Err _ ->
            Nothing


jumploc : Parser Loc
jumploc =
    succeed Loc
        |. keyword "/jumploc"
        |. spaces
        |= float
        |. spaces
        |= float
        |. spaces
        |= float
