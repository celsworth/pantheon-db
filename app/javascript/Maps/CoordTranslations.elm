module Maps.CoordTranslations exposing (..)


type alias Offset =
    { x : Float
    , y : Float
    }


type alias MapCalibration =
    { xLeft : Float
    , yBottom : Float
    , xScale : Float
    , yScale : Float
    }


-- maybe eventually move all the coordinate maths in here to hide it away
-- it's a mess in Maps/Show.elm right now.

-- unused


clickPositionToSvgCoordinates : ( Float, Float ) -> Float -> Float -> Offset -> Offset -> Float -> Offset
clickPositionToSvgCoordinates ( x, y ) mapXSize mapYSize mapPageSize mapOffset zoom =
    let
        -- this is 0 - model.mapPageSize.x (position in viewbox, not adjusted for offset or zoom)
        -- scale that to a proportion of mapPageSize
        ( x2, y2 ) =
            ( x / mapPageSize.x, y / mapPageSize.y )

        -- adjust that for zoom
        ( x3, y3 ) =
            ( x2 / zoom, y2 / zoom )

        -- multiply that out to actual mapSize (2800 x 2080)
        ( x4, y4 ) =
            ( x3 * mapXSize, y3 * mapYSize )

        -- add on mapOffset if any
        ( x5, y5 ) =
            ( x4 + mapOffset.x, y4 + mapOffset.y )
    in
    { x = x5, y = y5 }
