module DummyTalk exposing (..)

import Color exposing (Color, black)
import Dive.Model exposing (..)
import ElmLogo

world =
  ElmLogo.logo
  ++
  [ Text
    <| TextObject "How to build this presentation in Elm" Color.white "Helvetica" 0.1
    <| Position 500 250
  , Text
    <| TextObject "type alias Model =" Color.white "Courier New" 1
    <| Position 500 249
  , Text
    <| TextObject "  { bla : String" Color.white "Courier New" 1
    <| Position 500 248
  , Text
    <| TextObject "  , x : Int" Color.white "Courier New" 1
    <| Position 500 247
  , Text
    <| TextObject "  }" Color.white "Courier New" 1
    <| Position 500 246
  , Image
    <| ImageObject 
        "/talks/smiley.png"
        200
        200
    <| Position 300 1200
  ]

keys = 
  Keys
    []
    (Key (Position 500 500) (Size 4196 3072) 0)
    [ Key (Position 490 250) (Size 10.2 7.6) 1000
    , Key (Position 499 250) (Size 1.02 0.76) 500
    , Key (Position 503 248) (Size 10.2 7.6) 20
    , Key (Position 500 500) (Size 2048 1500) 0
    , Key (Position 300 1200) (Size 200 200) 2000
    ]

moveTo (cx, cy) list =
  List.map 
    (\(x,y) ->
      (x + cx, y + cy)
    )
    list
