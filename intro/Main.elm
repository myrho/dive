import Html 

import Window
import Dive 
import Dive.ElmLogo exposing (logo)

import Intro

init size =
  ( Dive.init size
    |> Dive.world Intro.world
    |> Dive.frames Intro.frames
  , Cmd.none
  )

main : Program Window.Size Dive.Model Dive.Msg
main =
  Html.programWithFlags
    { init = init
    , update = Dive.update
    , view = Dive.view
    , subscriptions = 
        Dive.subscriptions
    }
