module Dive.View exposing (..)

import Html exposing (Html)
import Collage as C
import Element as E
import Text as T
import Dive.Model exposing (..)
import Dive.Update exposing (Msg(..))

view : Model -> Html Msg
view model =
  E.toHtml
  <| C.collage model.viewport.width model.viewport.height
  <| forms model

forms : Model -> List C.Form
forms model =
  []
