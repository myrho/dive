module Dive exposing 
  ( Model, Msg, Frame, Object, LineStyle, Position, Size
  , init
  , update
  , view
  , subscriptions
  , world
  , rectangle, polygon, path, text, image, group
  , tiled, fitted, offset
  , border, lineStyle, fill, color
  , fontFamily
  , centered, leftAligned, rightAligned
  , height, lineHeight
  , transformObject
  , defaultLine
  , frame, frames, current
  , duration
  , transformFrame
  )

{-|
Dive is a framework for programming visual presentations like 
[Prezi](https://prezi.com)'s. 

# Demo

This [presentation](https://myrho.github.io/dive/) dives you through the 
fundamentals of Dive written with Dive itself!

The source code can be found 
[here](https://github.com/myrho/dive/tree/master/intro).

# Installation

Install Dive like any other Elm package:

    elm package install myrho/dive

# Example

Create a file named `Main.elm` and copy/paste the following piece of code into 
it:

    import Html 
    import Dive exposing (..)
    import Dive.ElmLogo exposing (logo)

    world =
      [ logo (0,0) (1,1)
      , text (0,0) "Hello Dive!"
        |> transformObject (0.001,0.001) (0,0) 
      ]

    frames =
      [ frame (1,1) (0,0)
      , frame (0.01, 0.01) (0,0) 
        |> duration 2000
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

Build it:

    elm make --output elm.js

Create a file named `index.html` and copy/paste the following piece of code 
into it:

    <!DOCTYPE HTML>
    <html>
      <head>
        <script type="text/javascript" src="elm.js"></script>
      </head>
      <body style="margin:0; padding:0; overflow:hidden;">
        <script type="text/javascript">
          var size =
            { width : window.innerWidth
            , height : window.innerHeight
            };
          Elm.Main.fullscreen(size);
        </script>
      </body>
    </html>

Navigate your browser (Firefox or Chrome) to the location of the `index.html` 
and dive!

# Documentation

Dive follows [The Elm Architecture](https://guide.elm-lang.org/architecture/) 
(TEA).
@docs Model, Msg, init, update, view, subscriptions

## World 
The "world" is the list of `Object`s the presentation consists of. 

@docs Position, Size, Object, world

### Constructors
@docs rectangle, polygon, text, path, image, group

### General Decorators
@docs border, lineStyle, fill, color

### Text Decorators
@docs fontFamily, centered, leftAligned, rightAligned, height, lineHeight

### Image Decorators
@docs fitted, tiled, offset

### Transformation
@docs transformObject

### LineStyle
@docs LineStyle, defaultLine

## Frames

Frames define into which part of the canvas you want to dive to. 

@docs Frame, frames, current

### Constructor
@docs frame

### Decorators
@docs duration

### Transformation
@docs transformFrame

-}

import Html exposing (Html)
import Window

import Collage 
import Color exposing (Color)
import List.Extra
import Dive.Model exposing (..)
import Dive.Update
import Dive.View 
import Dive.Sub
import Dive.Transform 

{-|
-}
type Model =
  Model Dive.Model.Model

{-|
-}
type alias Msg =
  Dive.Update.Msg

{-|
Initialize the Dive `Model` with the viewport size.
-}
init : Window.Size -> Model
init size =
  Model 
  <| Dive.Model.init 
  <| Dive.Model.Size (toFloat size.width) (toFloat size.height)

{-|
-}
update : Msg -> Model -> (Model, Cmd Msg)
update msg (Model model) =
  let
    (model_, cmd) =
      Dive.Update.update msg model
  in
    (Model model_, cmd)

{-|
-}
view : Model -> Html Msg
view (Model model) =
  Dive.View.view model

{-|
Dive subscribes to `Mouse.clicks`, `Keyboard.presses`, `Window.resize` and 
`AnimationFrame.diff`.
-}
subscriptions : Model -> Sub Msg
subscriptions (Model model) =
  Dive.Sub.subscriptions model

{-|
-}
type Object =
  Object Dive.Model.Object

{-|
X- and Y-coordinates.
-}
type alias Position =
  (Float, Float)

{-|
Width and height.
-}
type alias Size =
  (Float, Float)

{-|
Reusing `Collage.LineStyle` here.
-}
type alias LineStyle =
  Collage.LineStyle

{-|
Sets a list of `Object`s
-}
world : List Object -> Model -> Model
world objects (Model model) =
  Model
  <|{ model
      | world = List.map (\(Object obj) -> obj) objects
    }

{-|
The default `LineStyle`.
-}
defaultLine : LineStyle
defaultLine =
  let
    line =
      Collage.defaultLine
  in
    { line
      | width = 0.01
    }

{-|
A black rectangle.

    rectangle (100,100) (0,0)
-}
rectangle : Size -> Position -> Object
rectangle (w,h) (x,y) =
  Object
  <| Rectangle 
      { border = defaultLine
      , fill = Color.white
      , position = Position x y
      , size = Size w h
      }

{-|
A blue polygon with the given coordinates.

    polygon [(0,0), (1,1), (0,1)]
-}
polygon : List Position -> Object
polygon gons =
  Object
  <| Polygon
      { gons = gons
      , fill = Color.blue
      }

{-|
A path with the given coordinates and traced with `defaultLine`.

    path [(0,0), (1,1), (0,1), (1,2)]
-}
path : List Position -> Object
path path_ =
  Object
  <| Path
      { path = path_
      , lineStyle = defaultLine
      }

{-|
A black, centered text with font type 'sans', height 1 and lineHeight 1.

    text (0,0) "hello world"
-}
text : Position -> String -> Object
text (x,y) text_ =
  Object
  <| Text
      { text = text_
      , color = Color.black
      , fontFamily = ["sans"]
      , height = 1
      , align = Center
      , lineHeight = 1
      , position = Position x y
      }

{-|
An image rendering the given source url.

    image (100,100) (0,0) "myImage.jpg"
-}
image : Size -> Position -> String -> Object
image (w,h) (x,y) src =
  Object
  <| Image
      { src = src
      , position = Position x y
      , size = Size w h
      }

{-|
Groups a list of `Object`s. Handy if you want to `transform` a bunch of objects 
altogether.
-}
group : List Object -> Object
group objects =
  Object <| Group <| List.map (\(Object obj) -> obj) objects

{-|
Fill an `Object` with the given color. Only affects texts, rectangles and 
polygons.
-}
fill : Color -> Object -> Object
fill color (Object object) =
  Object
  <| case object of
      Text obj -> 
        Text 
          { obj
            | color = color
          }
      Rectangle obj -> 
        Rectangle 
          { obj
            | fill = color
          }
      Polygon obj -> 
        Polygon
          { obj
            | fill = color
          }
      _ ->
        object

{-|
Draw a border around an `Object`. Only affects rectangles.
-}
border : LineStyle -> Object -> Object
border lineStyle (Object object) =
  Object
  <| case object of
      Rectangle obj -> 
        Rectangle
          { obj
            | border = lineStyle
          }
      _ ->
        object

{-|
Set the `LineStyle` of an `Object`. Only affects paths.
-}
lineStyle : LineStyle -> Object -> Object
lineStyle lineStyle (Object object) =
  Object
  <| case object of
      Path obj ->
        Path
          { obj
            | lineStyle = lineStyle
          }
      _ ->
        object

{-|
Set the `Color` of an `Object`. Only affects texts, rectangles and polygons.
-}
color : Color -> Object -> Object
color color (Object object) =
  Object
  <| case object of
      Text obj ->
        Text
          { obj 
            | color = color
          }
      Rectangle obj -> 
        Rectangle
          { obj
            | fill = color
          }
      Polygon obj -> 
        Polygon
          { obj
            | fill = color
          }
      _ ->
        object

{-|
A list of preferred fonts.

    ["Inconsolata","Courier New","monospace"]

The first font in the list that is found on the user's computer is used.
-}
fontFamily : List String -> Object -> Object
fontFamily family (Object object) =
  Object
  <| case object of
      Text obj ->
        Text
          { obj 
            | fontFamily = family
          }
      _ ->
        object

{-|
Set the height of some text.
-}
height : Float -> Object -> Object
height height (Object object) =
  Object
  <| case object of
      Text obj ->
        Text
          { obj
            | height = height
          }
      _ ->
        object

align : Align -> Dive.Model.Object -> Dive.Model.Object
align align_ object = 
  case object of
    Text obj ->
      Text
        { obj
          | align = align_
        }
    _ ->
      object

{-|
Center text.
-}
centered : Object -> Object
centered (Object object) =
  Object <| align Center object

{-|
Align text to the left.
-}
leftAligned : Object -> Object
leftAligned (Object object) =
  Object <| align Left object

{-|
Align text to the right.
-}
rightAligned : Object -> Object
rightAligned (Object object) =
  Object <| align Right object

{-|
Sets the line height of some text.
-}
lineHeight : Float -> Object -> Object
lineHeight height (Object object) =
  Object
  <| case object of
      Text obj ->
        Text
          { obj
            | lineHeight = height
          }
      _ ->
        object

{-|
Crop an image by starting at the given offset coordinates.
-}
offset : Float -> Float -> Object -> Object
offset offsetX offsetY (Object object) =
  let
    position =
      Position offsetX offsetY
  in
    Object
    <| case object of
        CroppedImage obj ->
          CroppedImage
            { obj
              | offset = position
            }
        Image obj ->
          CroppedImage
            { src = obj.src
            , size = obj.size
            , position = obj.position
            , offset = position
            }
        _ ->
          object

{-|
Repeat an image up to the width and height of the `Object`.

    image "myImage.jpg" 
    |> size 100 100
    |> tiled
-}
tiled : Object -> Object
tiled (Object object) =
  Object
  <| case object of
      Image obj ->
        TiledImage obj
      _ ->
        object

{-|
Scale an image up to the width and height of the `Object`.

    image "myImage.jpg" 
    |> size 100 1 
    |> fitted
-}
fitted : Object -> Object
fitted (Object object) =
  Object
  <| case object of
      Image obj ->
        FittedImage obj
      _ ->
        object

{-|
Transform an `Object`. First the `Object` is resized by the first input tuple 
of scaling factors (width, height), then it is moved by the vector given in the 
second input tuple (x,y).

    rectangle -- construct a 1x1 sized rectangle at position (0,0)
    |> transform (3,5) (10,20) -- scales it to 10x20 and moves it by (3,5)
-}
transformObject : Size -> Position -> Object -> Object
transformObject size pos (Object object) =
  Object <| Dive.Transform.transformObject size pos object

{-|
A `Frame` consists of a `position`, a `size` and a `duration`.
-}
type Frame =
  Frame Dive.Model.Frame

{-|
Create a `Frame`. Duration is 1000 ms by default.
-}
frame : Size -> Position -> Frame
frame (w,h) (x,y) =
  Frame
    { position = Position x y
    , size = Size w h
    , duration = 1000
    }

{-|
Set the duration in milliseconds it takes to dive to the `Frame`.
-}
duration : Int -> Frame -> Frame
duration dur (Frame frame) =
  Frame
    { frame
      | duration = dur
    }

{-|
Sets the current frame of the presentation.
-}
current : Int -> Model -> Model
current index (Model model) =
  let
    frames =
      model.frames
    list =
      model.frames.previous
      ++ 
      [ model.frames.current ]
      ++
      model.frames.following
  in
    Model
    <| case List.Extra.getAt index list of
        Nothing ->
          model
        Just frame ->
          { model
            | frames =
              { frames
                | current = frame
                , previous =
                  List.take index list
                , following =
                  List.drop (index+1) list
              }
          }

{-|
Sets the frames of the presentation. A `Frame` defines into which part of the 
canvas you want to dive to.
-}
frames : List Frame -> Model -> Model
frames frames_ (Model model) =
  Model
  <| case List.head frames_ of
      Nothing -> 
        model
      Just (Frame frame) ->
        { model 
          | frames = 
            { current = frame
            , previous = []
            , following = 
              List.map (\(Frame frame) -> frame) 
              <| List.drop 1 frames_
            }
        }

{-|
Transform a `Frame`. First the `Frame` is resized by the first input tuple of 
scaling factors (width, height), then it is moved by the vector given in the 
second input tuple (x,y).

    frame (1,1) (0,0) -- create a 1x1 sized frame at position (0,0)
    |> transform (3,5) (10,20) -- scale it to 10x20 and move it by (3,5)
-}
transformFrame : Size -> Position -> Frame -> Frame
transformFrame (w,h) (x,y) (Frame frame) =
  let
    position =
      Position x y 
    size =
      Size w h
  in
    Frame
      { frame 
        | position = 
          Dive.Transform.transformPosition frame.position position size
        , size = 
          Dive.Transform.transformSize frame.size size
      }
