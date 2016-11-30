module DummyTalk exposing (..)

import Color exposing (Color, black)
import Dive.Model exposing (..)
import Dive.Transform as Transform
import ElmLogo

world =
  (Transform.transformWorld (Position -500 -500) (Size 1000 1000) ElmLogo.logo)
  ++
  [ Text
    <| TextObject "How to build this presentation in Elm" Color.white "Helvetica" 0.1 Center 1
    <| Position 500 250
  , Text
    <| TextObject "type alias Model =" Color.white "Courier New" 1 Center 1
    <| Position 500 249
  , Text
    <| TextObject "  { bla : String" Color.white "Courier New" 1 Center 1
    <| Position 500 248
  , Text
    <| TextObject "  , x : Int" Color.white "Courier New" 1 Center 1
    <| Position 500 247
  , Text
    <| TextObject "  }" Color.white "Courier New" 1 Center 1
    <| Position 500 246
  , Image
    <| ImageObject 
        "/talks/smiley.png"
        200
        200
    <| Position 300 1200
  ]

frames = 
  Frames
    []
    [ Frame (Position 490 250) (Size 10.2 7.6) 1000
    , Frame (Position 499 250) (Size 1.02 0.76) 500
    , Frame (Position 503 248) (Size 10.2 7.6) 20
    , Frame (Position 500 500) (Size 2048 1500) 0
    , Frame (Position 300 1200) (Size 200 200) 2000
    ]
    (Frame (Position 500 500) (Size 4196 3072) 0)

moveTo (cx, cy) list =
  List.map 
    (\(x,y) ->
      (x + cx, y + cy)
    )
    list
