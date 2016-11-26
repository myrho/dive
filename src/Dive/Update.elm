module Dive.Update exposing (..)

import Time exposing (Time)
import Window exposing (Size)
import Dive.Model exposing (..)

type Msg = 
  Forth
  | Back
  | Animate Time
  | Resize Size

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Resize size ->
      ( { model
          | viewport = size
        }
      , Cmd.none
      )
    _ ->
      (model, Cmd.none)
