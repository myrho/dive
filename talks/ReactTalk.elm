module ReactTalk exposing (..)

import Color exposing (Color, black)
import Window exposing (Size)
import Mouse exposing (Position)
import Dive.Model exposing (..)

world =
  [ Text 
    <| TextObject "Hello World!" black "Helvetica" 12 
    <| Position 0 0
  ]

keys = 
  Keys
    []
    (Key (Position 0 0) (Size 1254 964))
    []
