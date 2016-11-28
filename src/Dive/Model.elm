module Dive.Model exposing (..)

import Color exposing (Color)

type alias Model =
  { viewport : Size
  , world : List Object
  , keys : Keys
  , animation : Maybe Animation
  }

type Object =
  Polygon PolygonObject
    | Text TextObject
    | Image ImageObject
    | FittedImage ImageObject
    | CroppedImage CroppedImageObject
    | TiledImage ImageObject

type alias PolygonObject =
  { color : Color
  , gons : List (Float, Float)
  }

type alias TextObject = 
  { text : String
  , color : Color
  , font : String
  , size : Float
  , align : Align
  , position : Position
  }

type Align = 
  Center 
  | Left 
  | Right

type alias ImageObject =
  { src : String
  , width : Int
  , height : Int
  , position : Position
  }

type alias CroppedImageObject =
  { src : String
  , width : Int
  , height : Int
  , offsetX : Int
  , offsetY : Int
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
  , next : Key
  }

type alias Size = 
  { width : Float
  , height : Float
  }

type alias Position =
  { x : Float
  , y : Float
  }
