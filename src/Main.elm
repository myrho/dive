import Html 

import Dive 
import Dive.World as W exposing (..)
import Dive.Frame as F exposing (..)
import Dive.ElmLogo exposing (logo)

world =
  [ logo
  , text "Hello Dive!"
    |> W.transform 0 0 0.001 0.001
  ]

frames =
  [ frame 
    |> F.size 1 1
  , frame 
    |> F.size 0.01 0.01
    |> duration 1000
  ]

init size =
  ( Dive.init size
    |> Dive.world world
    |> Dive.frames frames
  , Cmd.none
  )

main =
  Html.programWithFlags
    { init = init
    , update = Dive.update
    , view = Dive.view
    , subscriptions = 
        Dive.subscriptions
    }
