module App exposing (..)

import Html 
import Dive.Model exposing (..)
import Dive.Init exposing (init)
import Dive.View exposing (view)
import Dive.Update exposing (Msg, update)
import Dive.Sub exposing (subscriptions)


main : Program Never Model Msg
main =
  Html.program
    { init = (init <| Size 1024 768, Cmd.none)
    , update = update
    , view = view
    , subscriptions = subscriptions
    }
