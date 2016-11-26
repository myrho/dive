module Dive.Update exposing (..)

import Time exposing (Time)
import Dive.Model exposing (..)

type Msg = 
  Forth
  | Back
  | Animate Time

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  (model, Cmd.none)
