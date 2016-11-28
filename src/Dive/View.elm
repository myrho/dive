module Dive.View exposing (..)

import Html exposing (Html)
import Html.Lazy 
import Collage as C
import Element as E
import Text as T
import Transform exposing (Transform)
import Ease
import Dive.Model exposing (..)
import Dive.Update exposing (Msg(..))

view : Model -> Html Msg
view model =
  Html.Lazy.lazy 
  view_
  model

view_ : Model -> Html Msg
view_ model =
  E.toHtml
    <| C.collage (round model.viewport.width) (round model.viewport.height)
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
    currentToViewport =
      { current
        | size = adaptWindowSize model.viewport current.size
      }
    scale side viewport window =
      (side viewport) / (side window)
    scaleX =
      scale .width model.viewport currentToViewport.size
    scaleY =
      scale .height model.viewport currentToViewport.size
    translateX =
      negate <| currentToViewport.position.x * scaleX -- current.size.width / 2
    translateY =
      negate <| currentToViewport.position.y * scaleY -- current.size.height / 2
  in
    Transform.matrix scaleX 0 0 scaleY translateX translateY

adaptWindowSize : Size -> Size -> Size
adaptWindowSize viewportSize windowSize =
  let
    viewportRatio = 
      viewportSize.width / viewportSize.height
    windowRatio =
      windowSize.width / windowSize.height
  in
    if windowRatio < viewportRatio
      then
        { windowSize
          | width = windowSize.height * viewportRatio
        }
      else
        { windowSize
          | height = windowSize.width / viewportRatio
        }

animate : Float -> Key -> Key -> Key
animate passed oldkey key =
  { key
    | size = animateSize passed oldkey.size key.size
    , position = animatePosition passed oldkey.position key.position
  }

animateSize : Float -> Size -> Size -> Size
animateSize passed oldsize size =
  { size
    | width = animateX passed oldsize.width size.width
    , height = animateX passed oldsize.height size.height
  }

animatePosition : Float -> Position -> Position -> Position
animatePosition passed oldposition position =
  { position
    | x = animateX passed oldposition.x position.x
    , y = animateX passed oldposition.y position.y
  }

animateX : Float -> Float -> Float -> Float
animateX passed old int =
  (+) old
  <| (*) (Ease.inOutQuad passed)
  <| int - old

visibleForms : Model -> List C.Form
visibleForms model =
  List.map object2Form
  <| model.world 

object2Form : Object -> C.Form
object2Form object =
  case object of
    Text {text, color, font, size, position} ->
      let
        text_ = 
          T.fromString text
            |> T.color color
            |> T.typeface [font]
            |> T.height size
        width =
          text_
            |> E.leftAligned
            |> E.widthOf
      in
        text_
          |> C.text
          |> C.move (position.x - (toFloat width)/2, position.y)
    Polygon {gons, color} ->
      C.polygon gons
        |> C.filled color
