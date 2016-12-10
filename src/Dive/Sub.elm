module Dive.Sub exposing (subscriptions)

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
    , case model.animation of
        Nothing ->
          Sub.none
        Just animation -> 
          AnimationFrame.diffs Animate
    , Mouse.clicks (always Forth)
    , Keyboard.downs KeyPressed
    ]
