module Dive.Init exposing (..)

import Window exposing (Size)
import Dive.Model exposing (..)
import Dive.Update exposing (Msg(..))

import ReactTalk

init : Size -> (Model, Cmd Msg)
init viewport = 
  ( { viewport = viewport
    , window = viewport
    , world = ReactTalk.world
    , keys = ReactTalk.keys
    }
  , Cmd.none
  )
