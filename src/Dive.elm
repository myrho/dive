module Dive exposing 
  ( Model, Msg
  , init
  , update
  , view
  , subscriptions
  , world, frames, current
  )

import Html exposing (Html)
import Window

import Dive.Model
import Dive.Update
import Dive.View 
import Dive.Sub
import Dive.World 
import Dive.Frame exposing (Frame)

type Model =
  Model Dive.Model.Model

type alias Msg =
  Dive.Update.Msg

init : Window.Size -> Model
init size =
  Model 
  <| Dive.Model.init 
  <| Dive.Model.Size (toFloat size.width) (toFloat size.height)
    

update : Msg -> Model -> Model
update msg (Model model) =
  Model <| Dive.Update.update msg model

view : Model -> Html Msg
view (Model model) =
  Dive.View.view model

subscriptions : Model -> Sub Msg
subscriptions (Model model) =
  Dive.Sub.subscriptions model

world : List Dive.World.Object -> Model -> Model
world objects (Model model) =
  Model <| Dive.World.world objects model

current : Int -> Model -> Model
current index (Model model) =
  Model <| Dive.Frame.current index model

frames : List Frame -> Model -> Model
frames frames_ (Model model) =
  Model <| Dive.Frame.frames frames_ model

