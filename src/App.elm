module App exposing (..)

import Html 
import Window exposing (Size)
import Dive.Model exposing (..)
import Dive.Init exposing (init)
import Dive.View exposing (view)
import Dive.Update exposing (Msg, update)
import Dive.Sub exposing (subscriptions)


main : Program Size Model Msg
main =
  Html.programWithFlags
    { init = init
    , update = update
    , view = view
    , subscriptions = subscriptions
    }
