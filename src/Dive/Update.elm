module Dive.Update exposing (..)

import Time exposing (Time)
import Window exposing (Size)
import List.Extra
import Dive.Model exposing (..)
import Dive.Init exposing (initAnimation)

type Msg = 
  Forth
  | Back
  | Animate Time
  | Resize Size

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    Resize size ->
      ( { model
          | viewport = size
        }
      , Cmd.none
      )
    Forth ->
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
    Back ->
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
