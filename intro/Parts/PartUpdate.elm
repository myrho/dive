module Parts.PartUpdate exposing (world, frames)

import Dive exposing (..)
import Color exposing (black, white, red, blue)
import Params

color_ =
  Color.black

msgCode ="""
type Msg =
  Resize Window.Size
  | Forth
  | Animate Time
"""


subCode ="""subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch
    [ Window.resizes Resize
    , Mouse.clicks (always Forth)
    , animateSub model
    ]
"""

animateCode ="""animateSub : Model -> Sub Msg
animateSub model =
  case model.animation of
    Just animation -> 
      AnimationFrame.diffs Animate
    Nothing ->
      Sub.none
"""

updateCode = """update : Msg -> Model -> Model
update msg model =
  case msg of
    Resize size ->
      { model
        | viewport = 
          { width = toFloat size.width
          , height = toFloat size.height
          }
      }
    Forth ->
      case List.head model.frames.following of
        Nothing ->
          model
        Just frame ->
          { model
            | animation = 
                Just
                  { passed = 0
                  , target = frame 
                  }
          }
    Animate diff ->
      case model.animation of
        Nothing ->
          model
        Just animation ->
          let
            passed = 
              animation.passed 
              + (diff / animation.target.duration)
          in
            if passed < 1
              then
                { model
                  | animation =
                      Just 
                        { animation 
                          | passed = passed
                        }
                }
              else
                { model
                  | animation = Nothing
                  , frames = 
                      updateFrames animation model.frames 
                }
"""

msgText x y = 
  [ text ((x-0.2),(y-1)) msgCode 
    |> color color_
    |> fontFamily Params.fontCode 
    |> height 1 
    |> leftAligned 
    |> lineHeight 1.3
    
  ]

subText x y =
  text ((x-0.2),(y-1)) subCode
    |> color color_
    |> fontFamily Params.fontCode 
    |> height 1 
    |> leftAligned 
    |> lineHeight 1.3
    

updateText x y =
  text ((x-0.2),(y-1)) updateCode 
    |> color color_
    |> fontFamily Params.fontCode 
    |> height 1 
    |> leftAligned 
    |> lineHeight 1.3
    

animateText x y =
  text ((x-0.2),(y-1)) animateCode 
    |> color color_
    |> fontFamily Params.fontCode 
    |> height 1 
    |> leftAligned 
    |> lineHeight 1.3
    

world =
  (msgText 0 0)
  ++
  [ transformObject (1,1) (16,16) <| subText 0 0
  , transformObject (0.01,0.01) (22,8.44) <| animateText 0 0
  , transformObject (1,1) (40,40) <| updateText 0 0
  ] |> group

frames =
  [ frame (17,17) (4,-4.0)  |> duration 1000
  , frame (18,18) (26,12.0)  |> duration 1000
  , frame (0.3,0.3) (22.1,8.4)  |> duration 1000
  , frame (18,18) (26,12.0)  |> duration 1000
  , frame (19,19) (51,35.0)  |> duration 1000
  , frame (19,19) (54,19.0)  |> duration 1000
  , frame (29,18) (56,5.0)  |> duration 1000
  , frame (17,17) (54,-8.0)  |> duration 1000
  , frame (28,15) (60,-18.0)  |> duration 1000
  ]
    
