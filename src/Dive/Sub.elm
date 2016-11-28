module Dive.Sub exposing (..)

import Window
import AnimationFrame
import Mouse
import Keyboard 
import Dive.Model exposing (..)
import Dive.Update exposing (Msg(..))

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch
    [ Window.resizes Resize
    , AnimationFrame.diffs Animate
    , Mouse.clicks (always Forth)
    , Keyboard.downs KeyPressed
    ]
