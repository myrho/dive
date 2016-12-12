module Dive.Frame exposing 
  ( Frame
  , frame
  , duration
  , current, frames
  , position, size
  , transform
  )

{-|
Frames define into which part of the canvas you want to dive to. 

@docs Frame

# Constructor
@docs frame

# Decorators
@docs position, size, duration

# Transformation
@docs transform

# Setup
@docs frames, current
-}

import List.Extra
import Dive.Model exposing (Model, Frame, Position, Size)
import Dive.Transform

{-|
A `Frame` consists of a `position`, a `size` and a `duration`.
-}
type Frame =
  Frame Dive.Model.Frame

{-|
Create the default `Frame` with a size of 1x1 and a duration of 0.
-}
frame : Frame
frame =
  Frame
    { position = Position 0 0
    , size = Size 1 1
    , duration = 0
    }

{-|
Position a `Frame` at the given coordinate.
-}
position : Float -> Float -> Frame -> Frame
position x y (Frame frame) =
  Frame
    { frame
      | position = Position x y
    }

{-|
Resize a `Frame` to the given size.
-}
size : Float -> Float -> Frame -> Frame
size w h (Frame frame) =
  Frame 
    { frame
      | size = Size w h
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
current index model =
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
    case List.Extra.getAt index list of
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
Sets the frames of the presentation. A `Frame` defines into which part of the canvas you want to dive to.
-}
frames : List Frame -> Model -> Model
frames frames_ model =
  case List.head frames_ of
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
Transform a `Frame`. First the `Frame` is resized by the first input tuple of scaling factors (width, height), then it is moved by the vector given in the second input tuple (x,y).

    frame -- construct a 1x1 sized frame at position (0,0)
    |> transform (3,5) (10,20) -- scales it to 10x20 and moves it by (3,5)
-}
transform : (Float, Float) -> (Float, Float) -> Frame -> Frame
transform (w,h) (x,y) (Frame frame) =
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
