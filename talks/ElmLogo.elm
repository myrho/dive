module ElmLogo exposing (..)

import Dive.Model exposing (..)
import Color exposing (Color, black)

logo =
  [ Polygon
    <| PolygonObject Color.lightBlue
    <|[ (10, 0)
      , (990, 0)
      , (500, 490)
      ]
  , Polygon
    <| PolygonObject Color.darkBlue
    <|[ (0, 10)
      , (0, 990)
      , (490, 500)
      ]
  , Polygon
    <| PolygonObject Color.orange
    <|[ (1000, 10)
      , (1000, 490)
      , (760, 250)
      ]
  , Polygon
    <| PolygonObject Color.green
    <|[ (510, 500)
      , (750, 740)
      , (990, 500)
      , (750, 260)
      ]
  , Polygon
    <| PolygonObject Color.orange
    <|[ (500, 510)
      , (740, 750)
      , (260, 750)
      ]
  , Polygon
    <| PolygonObject Color.green
    <|[ (10, 1000)
      , (490, 1000)
      , (730, 760)
      , (250, 760)
      ]
  , Polygon
    <| PolygonObject Color.lightBlue
    <|[ (510, 1000)
      , (1000, 1000)
      , (1000, 510)
      ]
  ]
