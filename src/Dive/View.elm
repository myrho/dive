module Dive.View exposing (..)

import Html exposing (Html)
import Collage as C
import Element as E
import Text as T
import Transform exposing (Transform)
import Dive.Model exposing (..)
import Dive.Update exposing (Msg(..))

view : Model -> Html Msg
view model =
  E.toHtml
  <| C.collage model.viewport.width model.viewport.height
  <| forms model

forms : Model -> List C.Form
forms model =
  let
    transform =
      windowViewportTransform model
  in
    visibleForms model
    |> C.groupTransform transform
    |> (\x -> [x])

windowViewportTransform : Model -> Transform
windowViewportTransform model =
  let
    scale side viewport window =
      (toFloat <| side viewport) / (toFloat <| side window)
    scaleX =
      scale .width model.viewport model.keys.current.size
    scaleY =
      scale .height model.viewport model.keys.current.size
    translateX =
      negate <| toFloat <| model.keys.current.position.x
    translateY =
      negate <| toFloat <| model.keys.current.position.y
  in
    Transform.matrix scaleX 0 0 scaleY translateX translateY

visibleForms : Model -> List C.Form
visibleForms model =
  List.map object2Form
  <| model.world 

object2Form : Object -> C.Form
object2Form object =
  case object of
    Text {text, color, font, size, position} ->
      T.fromString text
        |> T.color color
        |> T.typeface [font]
        |> T.height size
        |> C.text
        |> C.move (toFloat position.x, toFloat position.y)
    Polygon {gons, color} ->
      C.polygon gons
        |> C.filled color
