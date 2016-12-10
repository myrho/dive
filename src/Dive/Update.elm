module Dive.Update exposing (update, Msg(..))

import Time exposing (Time)
import Keyboard exposing (KeyCode)
import Window 
import List.Extra
import Dive.Model exposing (..)

type Msg = 
  Forth
  | Back
  | Animate Time
  | Resize Window.Size
  | KeyPressed KeyCode

update : Msg -> Model -> Model
update msg model =
  case Debug.log "msg" msg of
    Resize size ->
      resize size model
    Forth ->
      forth model
    Back ->
      back model
    KeyPressed code ->
      case code of
        37 ->
          back model
        39 ->
          forth model
        _ ->
          model
    Animate diff ->
      animate diff model

