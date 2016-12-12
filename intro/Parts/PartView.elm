module Parts.PartView exposing (world, frames)

import String
import Dive exposing (..)
import Color exposing (black, white, red, blue)
import Params

numberColor = 
  Color.darkBlue

codeColor =
  white

linenumbers text =
  String.split "\n" text
    |> List.length
    |> List.range 1
    |> List.map toString
    |> List.intersperse "\n"
    |> String.concat

viewCode ="""view : Model -> Html Msg
view model =
  model.world 
  |> List.map object2Form
  |> groupTransform 
      (transform model)
  |> \\x -> [x]
  |> collage 
      model.viewport.width 
      model.viewport.height
  |> toHtml
"""

object2FormCode ="""object2Form : Object -> Form
object2Form object =
  case object of
    Image {src, width, height, position} ->
      image width height src
        |> toForm
        |> move (position.x, position.y)
    ...
"""

transformCode = """transform : Model -> Transform
transform model =
  let
    frame =
      case model.animation of
        Nothing ->
          model.frames.current
        Just animation ->
          animate 
            animation.passed 
            model.frames.current 
            animation.target
  in
    matrix model.viewport frame
"""

viewText x y = 
  [ text ((x-0.2),(y-1)) viewCode
    |> color codeColor 
    |> fontFamily Params.fontCode 
    |> height 1 
    |> leftAligned 
    |> lineHeight 1.3 
    
  , text ((x-0.5),(y-1)) (linenumbers viewCode)
    |> color numberColor 
    |> fontFamily Params.fontCode 
    |> height 1 
    |> rightAligned
    |> lineHeight 1.3 
    
  ]

object2FormText x y =
  [ text ((x-0.2),(y-1)) object2FormCode
    |> color codeColor 
    |> fontFamily Params.fontCode 
    |> height 1 
    |> leftAligned 
    |> lineHeight 1.3
    
  , text ((x-0.5),(y-1)) (linenumbers object2FormCode)
    |> color numberColor 
    |> fontFamily Params.fontCode 
    |> height 1 
    |> rightAligned
    |> lineHeight 1.3 
    
  ]

transformText x y =
  [ text ((x-0.2),(y-1)) transformCode
    |> color Color.darkBlue 
    |> fontFamily Params.fontCode 
    |> height 1 
    |> leftAligned 
    |> lineHeight 1.3 
    
  , text ((x-0.5),(y-1)) (linenumbers transformCode)
    |> color Color.lightBlue 
    |> fontFamily Params.fontCode 
    |> height 1 
    |> rightAligned
    |> lineHeight 1.3 
    
  ]

objectTextPosX = 8.54
objectTextPosY = -4.81

transformPosX = 6.005
transformPosY = -7.332

world =
  (viewText 0 0)
  ++
  [ transformObject (0.008,0.008) ((objectTextPosX - 0.07),(objectTextPosY + 0.03)) <| group <| object2FormText 0 0
  , transformObject (0.003,0.003) ((transformPosX - 0.035),(transformPosY + 0.04)) <| group <| transformText 0 0
  ] |> group


viewTextFrame =
  frame (15,17) (9.5,-7)  |> duration 1000

frames =
  [ frame (2.5,1.7) (0.96,-1.0)  |> duration 300
  , frame (2.5,1.7) (8.9,-1.0)  |> duration 6000
  , viewTextFrame
  , frame (0.3,0.2) (objectTextPosX,objectTextPosY)  |> duration 1000
  , viewTextFrame
  , frame (0.1,0.1) (transformPosX,transformPosY)  |> duration 1000
  , viewTextFrame
  ]
    
