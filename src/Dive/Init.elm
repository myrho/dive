module Dive.Init exposing (..)

import Dive.Model exposing (..)

import ReactTalk

init : Size -> Model
init viewport = 
  { viewport = viewport
  , world = ReactTalk.world
  , keys = ReactTalk.keys
  , animation = Nothing
  }

initAnimation : Bool -> Key -> Animation
initAnimation =
  Animation 0 
