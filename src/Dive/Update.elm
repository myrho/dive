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

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case Debug.log "msg" msg of
    Resize size ->
      ( { model
          | viewport = 
            { width = toFloat size.width
            , height = toFloat size.height
            }
        }
      , Cmd.none
      )
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
          (model, Cmd.none)
    Animate diff ->
      case model.animation of
        Nothing ->
          (model, Cmd.none)
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
                ( { model
                    | animation =
                      Just 
                      <|{ animation 
                          | passed = passed
                        }
                  }
                , Cmd.none
                )
              else
                ( { model
                    | animation = Nothing
                    , frames = updateFrames animation model.frames 
                  }
                , Cmd.none
                )

backMsg : Model -> (Model, Cmd Msg)
backMsg model =
  case model.animation of
    Just _ ->
      (model, Cmd.none)
    Nothing ->
      ( { model
          | animation = 
            backAnimation model.frames
        }
      , Cmd.none
      )

forthMsg : Model -> (Model, Cmd Msg)
forthMsg model =
  case model.animation of
    Just _ ->
      (model, Cmd.none)
    Nothing ->
      ( { model
          | animation = 
            forthAnimation model.frames
        }
      , Cmd.none
      )

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
