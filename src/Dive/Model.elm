module Dive.Model exposing (..)

import Color exposing (Color)
import Collage exposing (LineStyle)

type alias Model =
  { viewport : Size
  , world : List Object
  , keys : Keys
  , animation : Maybe Animation
  }

type Object =
  Polygon PolygonObject
    | Rectangle RectangleObject
    | Path PathObject
    | Text TextObject
    | Image ImageObject
    | FittedImage ImageObject
    | CroppedImage CroppedImageObject
    | TiledImage ImageObject

type alias PolygonObject =
  { color : Color
  , gons : List (Float, Float)
  }

type alias RectangleObject =
  { border : LineStyle
  , fill : Color
  , size : Size
  , position : Position
  }

type alias PathObject =
  { lineStyle : LineStyle
  , path : List (Float, Float)
  }

type alias TextObject = 
  { text : String
  , color : Color
  , font : String
  , size : Float
  , align : Align
  , lineHeight : Float
  , position : Position
  }

type Align = 
  Center 
  | Left 
  | Right

type alias ImageObject =
  { src : String
  , width : Float
  , height : Float
  , position : Position
  }

type alias CroppedImageObject =
  { src : String
  , width : Float
  , height : Float
  , offsetX : Float
  , offsetY : Float
  , position : Position
  }

type alias Keys =
  { previous : List Key
  , following : List Key
  , current : Key
  }

type alias Key =
  { position : Position
  , size : Size
  , duration : Int
  }

type alias Animation =
  { passed : Float -- fraction of animation passed, 0 to 1
  , forth : Bool -- whether presentation goes back or forth
  , target : Key
  }

type alias Size = 
  { width : Float
  , height : Float
  }

type alias Position =
  { x : Float
  , y : Float
  }
