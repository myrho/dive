module Dive.View exposing (..)

import Html exposing (Html)
import Collage as C
import Element as E
import Text as T
import Transform exposing (Transform)
import Window exposing (Size)
import Mouse exposing (Position)
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
    current =
      case model.animation of
        Nothing ->
          model.keys.current
        Just animation ->
          animate animation.passed model.keys.current animation.next
    scale side viewport window =
      (toFloat <| side viewport) / (toFloat <| side window)
    scaleX =
      scale .width model.viewport current.size
    scaleY =
      scale .height model.viewport current.size
    translateX =
      negate <| toFloat <| current.position.x
    translateY =
      negate <| toFloat <| current.position.y
  in
    Transform.matrix scaleX 0 0 scaleY translateX translateY

animate : Float -> Key -> Key -> Key
animate passed oldkey key =
  { key
    | size = animateSize passed oldkey.size key.size
    , position = animatePosition passed oldkey.position key.position
  }

animateSize : Float -> Size -> Size -> Size
animateSize passed oldsize size =
  { size
    | width = 
      (+) oldsize.width 
      <| round <| (*) passed <| toFloat 
      <| size.width - oldsize.width
    , height = 
      (+) oldsize.height
      <| round <| (*) passed <| toFloat 
      <| size.height - oldsize.height
  }

animatePosition : Float -> Position -> Position -> Position
animatePosition passed oldposition position =
  { position
    | x = 
      (+) position.x
      <| round <| (*) passed <| toFloat 
      <| position.x - oldposition.x
    , y = 
      (+) position.y
      <| round <| (*) passed <| toFloat 
      <| position.y - oldposition.y
  }

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
