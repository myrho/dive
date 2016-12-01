module Dive.Update exposing (..)

import Time exposing (Time)
import Keyboard exposing (KeyCode)
import Window 
import List.Extra
import Dive.Model exposing (..)
import Dive.Init exposing (initAnimation)

type Msg = 
  Forth
  | Back
  | Animate Time
  | Resize Window.Size
  | KeyPressed KeyCode

update : Msg -> Model -> Model
update msg model =
  case Debug.log "msg" msg of
    Resize size ->
      { model
        | viewport = 
          { width = toFloat size.width
          , height = toFloat size.height
          }
      }
    Forth ->
      forthMsg model
    Back ->
      backMsg model
    KeyPressed code ->
      case code of
        37 ->
          backMsg model
        39 ->
          forthMsg model
        _ ->
          model
    Animate diff ->
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

backMsg : Model -> Model
backMsg model =
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

forthMsg : Model -> Model
forthMsg model =
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
