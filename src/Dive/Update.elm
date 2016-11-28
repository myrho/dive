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
            passed = 
              animation.passed + (diff / animationDuration)
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
                    , keys = updateKeys animation model.keys 
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
            backAnimation model.keys
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
            forthAnimation model.keys
        }
      , Cmd.none
      )

updateKeys : Animation -> Keys -> Keys
updateKeys animation keys =
  if animation.forth 
    then
      { keys
        | previous = keys.previous ++ [ keys.current ]
        , current = animation.next
        , following = List.tail keys.following |> Maybe.withDefault []
      }
    else
      { keys
        | previous = List.Extra.init keys.previous |> Maybe.withDefault []
        , current = animation.next
        , following = keys.current :: keys.following
      }

forthAnimation : Keys -> Maybe Animation
forthAnimation keys =
  List.head keys.following
    |> Maybe.map (initAnimation True)

backAnimation : Keys -> Maybe Animation
backAnimation keys =
  List.Extra.last keys.previous
    |> Maybe.map (initAnimation False)
