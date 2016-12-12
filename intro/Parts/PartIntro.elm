module Parts.PartIntro exposing (world)

import Dive exposing (..)
import Params
import Color exposing (black)
import Dive.ElmLogo exposing (logo)

world =
  [ logo (0,0) (0.9,0.9) 
  , text (0,0.8) "Dive"
    |> color black 
    |> fontFamily Params.font 
    |> height 0.5 
    |> centered
    |> lineHeight 1
    
  , text (0,-0.7) "Prezi-like Presentations\nin Elm"
    |> color black 
    |> fontFamily Params.font 
    |> height 0.2 
    |> centered
    |> lineHeight 1.2
    
  , text (0,-1.2) "github.com/myrho/dive"
    |> color black 
    |> fontFamily Params.font 
    |> height 0.1 
    |> centered
    |> lineHeight 1.2
    
  , text (0,-1.4) "Click or press the left/right arrow keys to dive!"
    |> color Color.darkBlue
    |> fontFamily Params.font 
    |> height 0.08 
    |> centered
    |> lineHeight 1.2
    
  ] |> group

