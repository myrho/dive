import Html 
import Dive.Model exposing (..)
import Dive.View exposing (view)
import Dive.Update exposing (Msg, update)
import Dive.Sub exposing (subscriptions)

import DummyTalk

init =
  ( { viewport = Size 1024 768
    , world = DummyTalk.world
    , frames = DummyTalk.frames
    , animation = Nothing
    }
  , Cmd.none
  )

main : Program Never Model Msg
main =
  Html.program
    { init = init
    , update = update
    , view = view
    , subscriptions = subscriptions
    }
