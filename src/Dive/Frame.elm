module Dive.Frame exposing 
  ( Frame
  , frame
  , duration
  , current, frames
  , position, size
  , transform
  )

import List.Extra
import Dive.Model exposing (Model, Frame, Position, Size)
import Dive.Transform

type Frame =
  Frame Dive.Model.Frame

frame : Frame
frame =
  Frame
    { position = Position 0 0
    , size = Size 1 1
    , duration = 0
    }

position : Float -> Float -> Frame -> Frame
position x y (Frame frame) =
  Frame
    { frame
      | position = Position x y
    }

size : Float -> Float -> Frame -> Frame
size w h (Frame frame) =
  Frame 
    { frame
      | size = Size w h
    }

duration : Int -> Frame -> Frame
duration dur (Frame frame) =
  Frame
    { frame
      | duration = dur
    }

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

transform : Float -> Float -> Float -> Float -> Frame -> Frame 
transform x y w h (Frame frame) =
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
