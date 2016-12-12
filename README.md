# Dive

Dive is a framework written in [Elm](http://elmlang.org) for programming visual presentations like [Prezi](https://prezi.com)'s. 

## Demo

This [presentation](https://myrho.github.io/dive/) dives you through the fundamentals of Dive written with Dive itself!

The source code can be found [here](https://github.com/myrho/dive/tree/master/intro).

## Installation

You need to [install Elm](https://guide.elm-lang.org/install.html) before.

Then run:

    elm package install myrho/dive

## Example

Create a file named `Main.elm` and copy/paste the following piece of code into it:

    import Html 
    import Dive exposing (..)
    import Dive.ElmLogo exposing (logo)

    world =
      [ logo (0,0) (1,1)
      , text (0,0) "Hello Dive!"
        |> transformObject (0.001,0.001) (0,0) 
      ]

    frames =
      [ frame (1,1) (0,0)
      , frame (0.01, 0.01) (0,0) 
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

Create a file named `index.html` and copy/paste the following piece of code into it:

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

## License

BSD-3
