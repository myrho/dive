module Dive.Model exposing (..)

import Color exposing (Color)
import Window exposing (Size)
import Mouse exposing (Position)

type alias Model =
  { viewport : Size
  , window : Size
  , world : List Object
  , keys : Maybe Keys
  }

type Object =
  Polygon PolygonObject
    | Text TextObject

type alias PolygonObject =
  { gons : List Position
  , color : Color
  }

type alias TextObject = 
  { text : String
  , color : Color
  , font : String
  , size : Float
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
