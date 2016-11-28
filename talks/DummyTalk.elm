module DummyTalk exposing (..)

import Color exposing (Color, black)
import Dive.Model exposing (..)
import ElmLogo

world =
  ElmLogo.logo
  ++
  [ Text
    <| TextObject "How to build this presentation in Elm" Color.white "Helvetica" 1
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
  ]

keys = 
  Keys
    []
    (Key (Position 500 500) (Size 4196 3072))
    [ Key (Position 490 250) (Size 10.2 7.6)
    , Key (Position 503 249) (Size 10.2 7.6)
    , Key (Position 503 248) (Size 10.2 7.6)
    ]

moveTo (cx, cy) list =
  List.map 
    (\(x,y) ->
      (x + cx, y + cy)
    )
    list
