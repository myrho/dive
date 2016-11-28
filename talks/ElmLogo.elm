module ElmLogo exposing (..)

import Dive.Model exposing (..)
import Color exposing (Color, black)

transformTuple {x,y} {width, height} (xt, yt) =
  (xt*width + x, yt*height + y)

logo pos size =
  [ Polygon
    <| PolygonObject Color.lightBlue
    <| List.map (transformTuple pos size)
    <|[ (0.01, 0.00)
      , (0.99, 0.00)
      , (0.50, 0.49)
      ]
  , Polygon
    <| PolygonObject Color.darkBlue
    <| List.map (transformTuple pos size)
    <|[ (0.00, 0.01)
      , (0.00, 0.99)
      , (0.49, 0.50)
      ]
  , Polygon
    <| PolygonObject Color.orange
    <| List.map (transformTuple pos size)
    <|[ (1.00, 0.01)
      , (1.00, 0.49)
      , (0.76, 0.25)
      ]
  , Polygon
    <| PolygonObject Color.green
    <| List.map (transformTuple pos size)
    <|[ (0.51, 0.50)
      , (0.75, 0.74)
      , (0.99, 0.50)
      , (0.75, 0.26)
      ]
  , Polygon
    <| PolygonObject Color.orange
    <| List.map (transformTuple pos size)
    <|[ (0.50, 0.51)
      , (0.74, 0.75)
      , (0.26, 0.75)
      ]
  , Polygon
    <| PolygonObject Color.green
    <| List.map (transformTuple pos size)
    <|[ (0.01, 1.00)
      , (0.49, 1.00)
      , (0.73, 0.76)
      , (0.25, 0.76)
      ]
  , Polygon
    <| PolygonObject Color.lightBlue
    <| List.map (transformTuple pos size)
    <|[ (0.51, 1.00)
      , (1.00, 1.00)
      , (1.00, 0.51)
      ]
  ]
