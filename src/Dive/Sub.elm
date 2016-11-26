module Dive.Sub exposing (..)

import Window
import Dive.Model exposing (..)
import Dive.Update exposing (Msg(..))

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch
    [ Window.resizes Resize
    ]
