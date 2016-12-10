module Dive.Model exposing (..)

import Window
import Color exposing (Color)
import Time exposing (Time)
import Collage exposing (LineStyle)
import List.Extra

type alias Model =
  { viewport : Size
  , world : List Object
  , frames : Frames
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
    | Group (List Object)

type alias PolygonObject =
  { fill : Color
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
  , fontFamily : List String
  , height : Float
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
  , size : Size
  , position : Position
  }

type alias CroppedImageObject =
  { src : String
  , size : Size
  , offset : Position
  , position : Position
  }

type alias Frames =
  { previous : List Frame
  , following : List Frame
  , current : Frame
  }

type alias Frame =
  { position : Position
  , size : Size
  , duration : Int
  }

type alias Animation =
  { passed : Float -- fraction of animation passed, 0 to 1
  , forth : Bool -- whether presentation goes back or forth
  , target : Frame
  }

type alias Size = 
  { width : Float
  , height : Float
  }

type alias Position =
  { x : Float
  , y : Float
  }

init : Size -> Model
init viewport = 
  { viewport = viewport
  , world = []
  , frames = Frames [] [] <| Frame (Position 0 0) viewport 0 
  , animation = Nothing
  }

initAnimation : Bool -> Frame -> Animation
initAnimation =
  Animation 0 

updateFrames : Animation -> Frames -> Frames
updateFrames animation frames =
  if animation.forth 
    then
      { frames
        | previous = frames.previous ++ [ frames.current ]
        , current = animation.target
        , following = List.tail frames.following |> Maybe.withDefault []
      }
    else
      { frames
        | previous = List.Extra.init frames.previous |> Maybe.withDefault []
        , current = animation.target
        , following = frames.current :: frames.following
      }

forthAnimation : Frames -> Maybe Animation
forthAnimation frames =
  List.head frames.following
    |> Maybe.map (initAnimation True)

backAnimation : Frames -> Maybe Animation
backAnimation frames =
  List.Extra.last frames.previous
    |> Maybe.map (initAnimation False)

animate : Time -> Model -> Model
animate diff model =
  case model.animation of
    Nothing ->
      model
    Just animation ->
      let
        duration =
          toFloat 
          <| if animation.forth
              then 
                animation.target.duration
              else
                model.frames.current.duration
        passed = 
          animation.passed + (diff / duration)
      in
        if passed < 1
          then
            { model
              | animation =
                Just 
                <|{ animation 
                    | passed = passed
                  }
            }
          else
            { model
              | animation = Nothing
              , frames = updateFrames animation model.frames 
            }

back : Model -> Model
back model =
  case model.animation of
    Just animation ->
      let
        updatedFrames =
          updateFrames animation model.frames
      in
        { model
          | animation = backAnimation updatedFrames
          , frames = updatedFrames
        }
    Nothing ->
      { model
        | animation = 
          backAnimation model.frames
      }

forth : Model -> Model
forth model =
  case model.animation of
    Just animation ->
      let
        updatedFrames =
          updateFrames animation model.frames
      in
        { model
          | animation = forthAnimation updatedFrames
          , frames = updatedFrames
        }
    Nothing ->
      { model
        | animation = 
          forthAnimation model.frames
      }

resize : Window.Size -> Model -> Model
resize size model =
  { model
    | viewport = 
      { width = toFloat size.width
      , height = toFloat size.height
      }
  }
