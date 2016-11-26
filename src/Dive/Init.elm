module Dive.Init exposing (..)

import Window exposing (Size)
import Dive.Model exposing (..)
import Dive.Update exposing (Msg(..))

init : Size -> (Model, Cmd Msg)
init viewport = 
  ( { viewport = viewport
    , window = viewport
    , world = []
    , keys = Nothing
    }
  , Cmd.none
  )
