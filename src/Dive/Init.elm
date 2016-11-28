module Dive.Init exposing (..)

import Dive.Model exposing (..)

init : Size -> Model
init viewport = 
  { viewport = viewport
  , world = []
  , keys = Keys [] [] <| Key (Position 0 0) viewport 0 
  , animation = Nothing
  }

initAnimation : Bool -> Key -> Animation
initAnimation =
  Animation 0 
