module Dive.View exposing (view)

import Html exposing (Html)
import Collage as C 
import Element as E
import Text as T
import Transform exposing (Transform)
import Ease
import Dive.Model exposing (..)
import Dive.Update exposing (Msg(..))

view : Model -> Html Msg
view model =
  model.world 
  |> List.map object2Form
  |> C.groupTransform 
      (transform model)
  |> \x -> [x]
  |> C.collage (round model.viewport.width) (round model.viewport.height)
  |> E.toHtml

transform : Model -> Transform
transform model =
  let
    current =
      case model.animation of
        Nothing ->
          model.frames.current
        Just animation ->
          animate animation.passed model.frames.current animation.target
    currentToViewport =
      { current
        | size = adaptWindowSize model.viewport current.size
      }
  in
    matrix model.viewport currentToViewport

matrix : Size -> Frame -> Transform 
matrix viewport frame =
  let
    scale side viewport window =
      (side viewport) / (side window)
    scaleX =
      scale .width viewport frame.size
    scaleY =
      scale .height viewport frame.size
    translateX =
      negate <| frame.position.x * scaleX -- current.size.width / 2
    translateY =
      negate <| frame.position.y * scaleY -- current.size.height / 2
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

animate : Float -> Frame -> Frame -> Frame
animate passed oldframe frame =
  { frame
    | size = animateSize passed oldframe.size frame.size
    , position = animatePosition passed oldframe.position frame.position
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

object2Form : Object -> C.Form
object2Form object =
  case object of
    Text object ->
      C.group
      <| List.indexedMap (line object)
      <| String.split "\n" object.text
    Polygon {gons, fill} ->
      C.polygon gons
        |> C.filled fill
    Rectangle {border, fill, size, position} ->
      [ C.rect size.width size.height
        |> C.filled fill
      , C.rect size.width size.height
        |> C.outlined border
      ] |> C.group
        |> C.move (position.x, position.y)
    Path {lineStyle, path} ->
      C.path path
        |> C.traced lineStyle
    Image {src, size, position} ->
      scalableImage E.image size src
        |> C.move (position.x, position.y)
    FittedImage {src, size, position} ->
      scalableImage E.fittedImage size src
        |> C.move (position.x, position.y)
    TiledImage {src, size, position} ->
      scalableImage E.tiledImage size src
        |> C.move (position.x, position.y)
    CroppedImage {src, size, offset, position} ->
      scalableCroppedImage offset size src
        |> C.move (position.x, position.y)

rescaleImage : Float -> Float -> (Int, Int, Float)
rescaleImage width height =
  let
    r = 
      width / height
    w = 
      1000
    h =
      w / r
      |> round
    scale =
      width / (toFloat w)
  in
    (w, h, scale)

scalableImage : (Int -> Int -> String -> E.Element) -> Size -> String -> C.Form
scalableImage image size src =
  let
    (w, h, scale) =
      rescaleImage size.width size.height
  in
    image w h src
      |> C.toForm
      |> C.scale scale

scalableCroppedImage : Position -> Size -> String -> C.Form
scalableCroppedImage offset size src =
  let
    (w, h, scale) =
      rescaleImage size.width size.height
    (oX, oY, _) =
      rescaleImage offset.x offset.y
  in
    E.croppedImage (oX,oY) w h src
      |> C.toForm
      |> C.scale scale

line : TextObject -> Int -> String -> C.Form
line {text, color, fontFamily, height, align, lineHeight, position} i line =
  let
    textFactor =
      100 
    text_ = 
      T.fromString line
        |> T.color color
        |> T.typeface fontFamily
        |> T.height textFactor
    shift =
      case align of
        Center ->
          0
        Right ->
          negate <| width/2
        Left ->
          width/2
    element =
      text_
        |> E.leftAligned -- just for transforming Text to Element
    width =
      element
        |> E.widthOf
        |> toFloat
        |> (*) (height/textFactor)
    height_ =
      height/2 -- for some odd reason height is half the size
  in
    text_
      |> C.text
      |> C.scale (height/textFactor)
      |> C.move 
        ( position.x + shift
        , position.y + height_/2 - (toFloat i * (height*lineHeight)) 
        )
