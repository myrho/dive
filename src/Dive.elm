module Dive exposing 
  ( Model, Msg
  , init
  , update
  , view
  , subscriptions
  , world, frames, current
  )

{-|
Dive is a framework written in [Elm](http://elmlang.org) for programming visual presentations like [Prezi](https://prezi.com). 

# Demo

This [presentation](https://myrho.github.io/dive/) dives you through the fundamentals of Dive written with Dive itself!

The source code can be found [here](https://github.com/myrho/dive/master/tree/master/intro).

# Installation

You need to [install Elm](https://guide.elm-lang.org/install.html) before.

From the root of your Elm project run

   elm package install myrho/dive

# Example

Create a file named `Main.elm` and paste the following code into it:

    import Html 

    import Dive 
    import Dive.World as W exposing (..)
    import Dive.Frame as F exposing (..)
    import Dive.ElmLogo exposing (logo)

    world =
      [ logo
      , text "Hello Dive!"
        |> W.transform (0.001,0.001) (0,0) 
      ]

    frames =
      [ frame 
        |> F.size 1 1
      , frame 
        |> F.size 0.01 0.01
        |> duration 2000
      ]

    init size =
      ( Dive.init size
        |> Dive.world world
        |> Dive.frames frames
      , Cmd.none
      )

    main =
      Html.programWithFlags
        { init = init
        , update = Dive.update
        , view = Dive.view
        , subscriptions = 
            Dive.subscriptions
        }

Build it:

    elm make --output elm.js

Create a file named `index.html` and paste the following code into it:

    <!DOCTYPE HTML>
    <html>
      <head>
        <script type="text/javascript" src="elm.js"></script>
      </head>
      <body style="margin:0; padding:0; overflow:hidden;">
        <script type="text/javascript">
          var size =
            { width : window.innerWidth
            , height : window.innerHeight
            };
          Elm.Main.fullscreen(size);
        </script>
      </body>
    </html>

Navigate your browser (Firefox or Chrome) to the location of the `index.html` and dive!

# Documentation

Dive follows [The Elm Architecture](https://guide.elm-lang.org/architecture/) (TEA).

## TEA
@docs Model, Msg, init, update, view, subscriptions

## World and Frames
@docs world, frames, current
-}

import Html exposing (Html)
import Window

import Dive.Model
import Dive.Update
import Dive.View 
import Dive.Sub
import Dive.World 
import Dive.Frame exposing (Frame)

{-|
-}
type Model =
  Model Dive.Model.Model

{-|
-}
type alias Msg =
  Dive.Update.Msg

{-|
Initialize the Dive `Model` with the viewport size.
-}
init : Window.Size -> Model
init size =
  Model 
  <| Dive.Model.init 
  <| Dive.Model.Size (toFloat size.width) (toFloat size.height)

{-|
-}
update : Msg -> Model -> (Model, Cmd Msg)
update msg (Model model) =
  let
    (model_, cmd) =
      Dive.Update.update msg model
  in
    (Model model_, cmd)

{-|
-}
view : Model -> Html Msg
view (Model model) =
  Dive.View.view model

{-|
Dive subscribes to `Mouse.clicks`, `Keyboard.presses`, `Window.resize` and `AnimationFrame.diff`.
-}
subscriptions : Model -> Sub Msg
subscriptions (Model model) =
  Dive.Sub.subscriptions model

{-|
Sets a list of `Object`s which will appear on the canvas.
-}
world : List Dive.World.Object -> Model -> Model
world objects (Model model) =
  Model <| Dive.World.world objects model

{-|
Sets the current frame of the presentation.
-}
current : Int -> Model -> Model
current index (Model model) =
  Model <| Dive.Frame.current index model

{-|
Sets the frames of the presentation. A `Frame` defines into which part of the canvas you want to dive to.
-}
frames : List Frame -> Model -> Model
frames frames_ (Model model) =
  Model <| Dive.Frame.frames frames_ model

