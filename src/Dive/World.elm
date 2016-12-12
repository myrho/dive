module Dive.World exposing 
  ( Object, LineStyle
  , world
  , rectangle, polygon, path, text, image, group
  , tiled, fitted, offset
  , position, size
  , border, lineStyle, fill, color
  , fontFamily
  , centered, leftAligned, rightAligned
  , height, lineHeight
  , transform
  , defaultLine
  )

{-|
The "world" is the list of `Object`s the presentation consists of. 

@docs Object, world

# Constructors
@docs rectangle, polygon, text, path, image, group

# General Decorators
@docs position, size, border, lineStyle, fill, color

# Text Decorators
@docs fontFamily, centered, leftAligned, rightAligned, height, lineHeight

# Image Decorators
@docs fitted, tiled, offset

# Transformation
@docs transform

# LineStyle
@docs LineStyle, defaultLine
-}

import Collage 
import Color exposing (Color)
import Dive.Model exposing (..)
import Dive.Transform exposing (..)

{-|
-}
type alias Object =
  Dive.Model.Object

{-|
Reusing Collage.LineStyle here.
-}
type alias LineStyle =
  Collage.LineStyle

{-|
Sets a list of `Object`s
-}
world : List Object -> Model -> Model
world objects model =
  { model
    | world = objects
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
A black, 1x1 sized rectangle.
-}
rectangle : Object
rectangle =
  Rectangle 
    { border = defaultLine
    , fill = Color.white
    , position = Position 0 0
    , size = Size 1 1
    }

{-|
A blue polygon with the given coordinates.
-}
polygon : List (Float, Float) -> Object
polygon gons =
  Polygon
    { gons = gons
    , fill = Color.blue
    }

{-|
A path with the given coordinates and traced with `defaultLine`.
-}
path : List (Float, Float) -> Object
path path_ =
  Path
    { path = path_
    , lineStyle = defaultLine
    }

{-|
A black, centered text with font type 'sans', height 1 and lineHeight 1.
-}
text : String -> Object
text text_ =
  Text
    { text = text_
    , color = Color.black
    , fontFamily = ["sans"]
    , height = 1
    , align = Center
    , lineHeight = 1
    , position = Position 0 0
    }

{-|
A 1x1 sized image rendering the given source url.
-}
image : String -> Object
image src =
  Image
    { src = src
    , position = Position 0 0
    , size = Size 1 1
    }

{-|
Groups a list of `Object`s. Handy if you want to `transform` a bunch of objects altogether.
-}
group : List Object -> Object
group objects =
  Group objects

{-|
Position an `Object` at the given coordinates.
-}
position : Float -> Float -> Object -> Object
position x y object =
  let
    set obj =
      { obj
        | position = Position x y
      }
  in
    case object of
      Rectangle obj ->
        Rectangle <| set obj
      Text obj ->
        Text <| set obj
      Image obj ->
        Image <| set obj
      FittedImage obj ->
        FittedImage <| set obj
      CroppedImage obj ->
        CroppedImage <| set obj
      TiledImage obj ->
        TiledImage <| set obj
      _ ->
        object

{-|
Resize an `Object` to the given size.
-}
size : Float -> Float -> Object -> Object
size w h object =
  let
    set obj =
      { obj
        | size = Size w h
      }
  in
    case object of
      Rectangle obj ->
        Rectangle <| set obj
      Image obj ->
        Image <| set obj
      FittedImage obj ->
        FittedImage <| set obj
      CroppedImage obj ->
        CroppedImage <| set obj
      TiledImage obj ->
        TiledImage <| set obj
      _ ->
        object

{-|
Fill an `Object` with the given color. Only affects `rectangle`s and `polygon`s.
-}
fill : Color -> Object -> Object
fill color object =
  case object of
    Rectangle obj -> 
      Rectangle { obj
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
Draw a border around an `Object`. Only affects `rectangle`s.
-}
border : LineStyle -> Object -> Object
border lineStyle object =
  case object of
    Rectangle obj -> 
      Rectangle
        { obj
          | border = lineStyle
        }
    _ ->
      object

{-|
Set the `LineStyle` of an `Object`. Only affects `path`s.
-}
lineStyle : LineStyle -> Object -> Object
lineStyle lineStyle object =
  case object of
    Path obj ->
      Path
        { obj
          | lineStyle = lineStyle
        }
    _ ->
      object

{-|
Set the `Color` of an `Object`. Only affects `text`s, `rectangle`s and `polygon`s.
-}
color : Color -> Object -> Object
color color object =
  case object of
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
fontFamily family object =
  case object of
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
height height object =
  case object of
    Text obj ->
      Text
        { obj
          | height = height
        }
    _ ->
      object

align : Align -> Object -> Object
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
centered =
  align Center

{-|
Align text to the left.
-}
leftAligned : Object -> Object
leftAligned =
  align Left

{-|
Align text to the right.
-}
rightAligned : Object -> Object
rightAligned =
  align Right

{-|
The line height of some text.
-}
lineHeight : Float -> Object -> Object
lineHeight height object =
  case object of
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
offset offsetX offsetY object =
  let
    position =
      Position offsetX offsetY
  in
    case object of
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
Repeat an image up to the `Object`'s width and height.

    image "myImage.jpg" 
    |> size 100 100
    |> tiled
-}
tiled : Object -> Object
tiled object =
  case object of
    Image obj ->
      TiledImage obj
    _ ->
      object

{-|
Scale an image up to the `Object`'s width and height.

    image "myImage.jpg" 
    |> size 100 1 
    |> fitted
-}
fitted : Object -> Object
fitted object =
  case object of
    Image obj ->
      FittedImage obj
    _ ->
      object

{-|
Transform an `Object`. First the `Object` is resized by the first input tuple of scaling factors (width, height), then it is moved by the vector given in the second input tuple (x,y).

    rectangle -- construct a 1x1 sized rectangle at position (0,0)
    |> transform (3,5) (10,20) -- scales it to 10x20 and moves it by (3,5)
-}
transform : (Float, Float) -> (Float, Float) -> Object -> Object
transform (w,h) (x,y) object =
  let
    position =
      Position x y
    size =
      Size w h
  in
    case object of
      Text object ->
        Text <| transformText position size object
      Polygon object ->
        Polygon <| transformPolygon position size object
      Rectangle object ->
        Rectangle <| transformRectangle position size object
      Path object ->
        Path <| transformPath position size object
      Image object ->
        Image <| transformImage position size object
      FittedImage object ->
        FittedImage <| transformImage position size object
      TiledImage object ->
        TiledImage <| transformImage position size object
      CroppedImage object ->
        CroppedImage <| transformCroppedImage position size object
      Group objects ->
        Group <| List.map (transform (w,h) (x,y)) objects

