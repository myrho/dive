module Dive.Init exposing (..)

import Dive.Model exposing (..)

init : Size -> Model
init viewport = 
  { viewport = viewport
  , world = []
  , frames = Frames [] [] <| Frame (Position 0 0) viewport 0 
  , animation = Nothing
  }

initAnimation : Bool -> Frame -> Animation
initAnimation =
  Animation 0 
