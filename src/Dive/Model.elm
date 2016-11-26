module Dive.Model exposing (..)

import Color exposing (Color)
import Window exposing (Size)
import Mouse exposing (Position)

animationDuration =
  1000

type alias Model =
  { viewport : Size
  , world : List Object
  , keys : Keys
  , animation : Maybe Animation
  }

type Object =
  Polygon PolygonObject
    | Text TextObject

type alias PolygonObject =
  { gons : List (Float, Float)
  , color : Color
  }

type alias TextObject = 
  { text : String
  , color : Color
  , font : String
  , size : Float
  , position : Position
  }

type alias Keys =
  { previous : List Key
  , current : Key
  , following : List Key
  }

type alias Key =
  { position : Position
  , size : Size
  }

type alias Animation =
  { passed : Float -- fraction of animation passed, 0 to 1
  , forth : Bool -- whether presentation goes back or forth
  , next : Key
  }
