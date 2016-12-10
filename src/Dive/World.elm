module Dive.World exposing 
  ( Object
  , world
  , rectangle, polygon, path, text, image
  , tiled, fitted, offset
  , position, size
  , border, lineStyle, fill, color
  , fontFamily
  , centered, leftAligned, rightAligned
  , transform, transformWorld
  )

{-|
  doc
-}

import Collage exposing (LineStyle)
import Color exposing (Color)
import Dive.Model exposing (..)
import Dive.Transform exposing (..)

type alias Object =
  Dive.Model.Object

world : List Object -> Model -> Model
world objects model =
  { model
    | world = objects
  }

defaultLine : LineStyle
defaultLine =
  let
    line =
      Collage.defaultLine
  in
    { line
      | width = 0.01
    }

rectangle : Object
rectangle =
  Rectangle 
    { border = defaultLine
    , fill = Color.white
    , position = Position 0 0
    , size = Size 1 1
    }

polygon : List (Float, Float) -> Object
polygon gons =
  Polygon
    { gons = gons
    , fill = Color.blue
    }

path : List (Float, Float) -> Object
path path_ =
  Path
    { path = path_
    , lineStyle = defaultLine
    }

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

image : String -> Object
image src =
  Image
    { src = src
    , position = Position 0 0
    , size = Size 1 1
    }

position : Position -> Object -> Object
position pos object =
  let
    set obj =
      { obj
        | position = pos
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

size : Size -> Object -> Object
size size object =
  let
    set obj =
      { obj
        | size = size
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

centered : Object -> Object
centered =
  align Center

leftAligned : Object -> Object
leftAligned =
  align Left

rightAligned : Object -> Object
rightAligned =
  align Right

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

tiled : Object -> Object
tiled object =
  case object of
    Image obj ->
      TiledImage obj
    _ ->
      object

fitted : Object -> Object
fitted object =
  case object of
    Image obj ->
      FittedImage obj
    _ ->
      object

transform : Float -> Float -> Float -> Float -> Object -> Object
transform x y w h object =
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

transformWorld : Float -> Float -> Float -> Float -> List Object -> List Object
transformWorld x y w h =
  List.map (transform x y w h)

