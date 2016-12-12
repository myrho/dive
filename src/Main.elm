import Html 

import Dive exposing (..)
import Dive.ElmLogo exposing (logo)
import Dive.Update exposing (..)

world =
  [ logo
  , text "Hello Dive!"
    |> transformObject (0.001,0.001) (0,0) 
  ]

frames =
  [ frame 
    |> frameSize 1 1
  , frame 
    |> frameSize 0.01 0.01
    |> duration 2000
  ]

init size =
  ( Dive.init size
    |> Dive.world world
    |> Dive.frames frames
  , Cmd.none
  )

type Msg =
  DiveMsg Dive.Msg

update msg model =
  case msg of
    DiveMsg (Animate diff) ->
      (model, Cmd.none)
    _ ->
      (model, Cmd.none)

main =
  Html.programWithFlags
    { init = init
    , update = update
    , view = (\m -> Html.map DiveMsg <| Dive.view m)
    , subscriptions = 
        (\m -> Sub.map DiveMsg <| Dive.subscriptions m)
    }
