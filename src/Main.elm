import Html 
import Dive.Model exposing (..)
import Dive.View exposing (view)
import Dive.Update exposing (Msg)
import Dive.Sub exposing (subscriptions)

import DummyTalk

init size =
  ( { viewport = size
    , world = DummyTalk.world
    , frames = DummyTalk.frames
    , animation = Nothing
    }
  , Cmd.none
  )

update msg model =
  ( Dive.Update.update msg model
  , Cmd.none
  )

main : Program Size Model Msg
main =
  Html.programWithFlags
    { init = init
    , update = update
    , view = view
    , subscriptions = subscriptions
    }
