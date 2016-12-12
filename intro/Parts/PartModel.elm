module Parts.PartModel exposing (world, frames)

import Dive exposing (..)
import Color exposing (black, white, red, blue)
import Params

border_ =
  { defaultLine
    | width = 0.01
    , color = black
  }

pathArm = 
  [ (0.15, 0.35)
  , (0.5, 0.35)
  , (0.5, 0.1)
  ]

boxWidth =
  0.3

lineHeight_ =
  1.3

box x y =
  rectangle (boxWidth,0.2) (x,y)
  |> border border_ 
  |> fill white 
  
  

modelBox =
  [ box 0 0.35
  , text (0,0.4) "Model"
    |> color black 
    |> fontFamily Params.font 
    |> height 0.05 
    |> centered 
    |> lineHeight lineHeight_
    
  , transformObject (helloWorldWidth,helloWorldHeight) (helloWorldPosX,helloWorldPosY)
    <| group 
    <| helloWorld ++ frameFrameHelloWorld
  , transformObject (0.0001,0.0001) (-0.008,0.28) <| group <| helloWordText
  ] 
 
helloWorldPosX = 0 
helloWorldPosY = 0.32
helloWorldWidth = (1/750) 
helloWorldHeight = (1/750)

helloWorld =
  [ text (0,0) "Hello\nW rld"
    |> color blue 
    |> fontFamily ["serif"] 
    |> height 20 
    |> centered 
    |> lineHeight 1.5
  , image (10,10) (-5,-30) "https://myrho.github.io/dive/world.png"
  ]

transparent =
  Color.rgba 0 0 0 0

frameFrameBorder =
  { defaultLine 
    | color = red
    , width = 0.003
  }

frameFrameHelloWorld =
  [ rectangle (90,60) (0,-10)
    |> border frameFrameBorder 
    |> fill transparent 
  , text (-43,17) "1"
    |> color red 
    |> fontFamily ["monospace"] 
    |> height 3 
    |> centered 
    |> lineHeight 1
  , rectangle (70,30) (0,3)
    |> border frameFrameBorder 
    |> fill transparent
  , text (-33,15) "2" 
    |> color red 
    |> fontFamily ["monospace"]
    |> height 3 
    |> centered
    |> lineHeight 1
  , rectangle (15,15) (-5,-30)
    |> border frameFrameBorder 
    |> fill transparent
  , text (-11,-25) "3" 
    |> color red 
    |> fontFamily ["monospace"]
    |> height 3 
    |> centered
    |> lineHeight 1
  ]

helloWorldFrames =
  [ frame (90,60) (0,-10)  
    |> duration 1000
  , frame (70,30) (0,3)  
    |> duration 500
  , frame (15,15) (-5,-30)  
    |> duration 800
  ]

helloWorldCode = """
world =
  [ text (0,0) "Hello\\nW rld"
    |> color blue
    |> fontFamily ["serif"]
    |> height  20
    |> centered
    |> lineHeight 1.5
  , image (10,10) (-5,-30) "world.png" 
  ]
"""

helloWorldframesCode = """frames =
  [ frame (90,60) (0,-10) 
    |> duration 1000
  , frame (70,30) (0,3)
    |> duration 500
  , frame (15,15) (-8,-30) 
    |> duration 800
  ]
"""

helloWordText =
  [ text (-18,12) helloWorldCode 
    |> color blue 
    |> fontFamily Params.fontCode 
    |> height 1 
    |> leftAligned 
    |> lineHeight lineHeight_
    
  , text (-3,-12) helloWorldframesCode 
    |> color blue 
    |> fontFamily Params.fontCode 
    |> height 1 
    |> leftAligned 
    |> lineHeight lineHeight_
    
  ]

viewport =
  text (0,0.34) "viewport: Size" 
  |> color black 
  |> fontFamily Params.fontCode 
  |> height 0.02 
  |> centered 
  |> lineHeight lineHeight_
  

objectBox x y =
  [ box x y
  , text (x,y) "Object" 
    |> color black 
    |> fontFamily Params.font 
    |> height 0.05 
    |> centered 
    |> lineHeight lineHeight_
    
  ]

animationBox x y =
  [ box x y
  , text (x,(y+0.05)) "Animation" 
    |> color black 
    |> fontFamily Params.font 
    |> height 0.05 
    |> centered 
    |> lineHeight lineHeight_
    
  , text ((x-0.12),(y-0.01)) "passed: Float" 
    |> color black 
    |> fontFamily Params.fontCode 
    |> height 0.02 
    |> leftAligned 
    |> lineHeight lineHeight_
    
  ]

framesBox =
  [ box 0 0
  , text (0,0) "Frames"
    |> color black 
    |> fontFamily Params.font 
    |> height 0.05 
    |> centered 
    |> lineHeight lineHeight_
    
  ]

frameBox x y =
  [ box x y
  , text ((x),(y +0.05)) "Frame"
    |> color black 
    |> fontFamily Params.font 
    |> height 0.05 
    |> centered 
    |> lineHeight lineHeight_
    
  , text ((x-0.12),(y-0.01)) "position: Position"
    |> color black 
    |> fontFamily Params.fontCode 
    |> height 0.02 
    |> leftAligned
    |> lineHeight lineHeight_
    
  , text ((x-0.12),(y-0.04)) "size: Size"
    |> color black 
    |> fontFamily Params.fontCode 
    |> height 0.02 
    |> leftAligned
    |> lineHeight lineHeight_
    
  , text ((x-0.12),(y-0.07)) "duration: Int"
    |> color black 
    |> fontFamily Params.fontCode 
    |> height 0.02 
    |> leftAligned
    |> lineHeight lineHeight_
    
  ]

rightArm x =
  [ path pathArm
    |> border border_
  , text ((x+0.01),0.12) "0/1"
    |> color black 
    |> fontFamily Params.fontCode 
    |> height 0.02 
    |> leftAligned
    |> lineHeight lineHeight_
    
  , text (0.16,0.37) "animation"
    |> color black 
    |> fontFamily Params.fontCode 
    |> height 0.02 
    |> leftAligned 
    |> lineHeight lineHeight_
    
  ]

leftArm =
  [ path
      [ (-0.15, 0.35)
      , (-0.35, 0.35)
      ]
    |> border border_
  , text ((-0.29),0.37) "0..n"
    |> color black 
    |> fontFamily Params.fontCode 
    |> height 0.02 
    |> rightAligned 
    |> lineHeight lineHeight_
    
  , text (-0.16,0.37) "world"
    |> color black 
    |> fontFamily Params.fontCode 
    |> height 0.02 
    |> rightAligned 
    |> lineHeight lineHeight_
    
  ]

middleArm =
  [ path
      [ (0, 0.25)
      , (0, 0.1)
      ]
    |> border border_
  , text (0.01,0.12) "1"
    |> color black 
    |> fontFamily Params.fontCode 
    |> height 0.02 
    |> centered 
    |> lineHeight lineHeight_
    
  , text (0.01,0.22) "frames"
    |> color black 
    |> fontFamily Params.fontCode 
    |> height 0.02 
    |> leftAligned
    |> lineHeight lineHeight_
    
  ]

leftArm2 x y1 y2 =
  [ path
      [ (negate <| boxWidth/2, y1)
      , (negate x, y1)
      , (negate x, y2)
      , (negate <| boxWidth/2, y2)
      ]
    |> border border_
  , text ((negate <| boxWidth/2 + 0.01),(y1+0.02)) "previous"
    |> color black 
    |> fontFamily Params.fontCode 
    |> height 0.02 
    |> rightAligned
    |> lineHeight lineHeight_
    
  , text ((negate <| boxWidth/2 + 0.01),(y2+0.02)) "0..n"
    |> color black 
    |> fontFamily Params.fontCode 
    |> height 0.02 
    |> rightAligned
    |> lineHeight lineHeight_
    
  ]

rightArm2 x y1 y2 =
  [ path
      [ (boxWidth/2, y1)
      , (x, y1)
      , (x, y2)
      , (boxWidth/2, y2)
      ]
    |> border border_
  , text ((boxWidth/2 + 0.01),(y1+0.02)) "following"
    |> color black 
    |> fontFamily Params.fontCode 
    |> height 0.02 
    |> leftAligned
    |> lineHeight lineHeight_
    
  , text ((boxWidth/2 + 0.01),(y2+0.02)) "0..n"
    |> color black 
    |> fontFamily Params.fontCode 
    |> height 0.02 
    |> leftAligned
    |> lineHeight lineHeight_
    
  ]

middleArm2 =
  [ path
      [ (0, -0.25)
      , (0, -0.1)
      ]
    |> border border_
  , text (0.01,-0.22) "1"
    |> color black 
    |> fontFamily Params.fontCode 
    |> height 0.02 
    |> leftAligned
    |> lineHeight lineHeight_
    
  , text (0.01,-0.12) "current"
    |> color black 
    |> fontFamily Params.fontCode 
    |> height 0.02 
    |> leftAligned
    |> lineHeight lineHeight_
    
  ]

animationArm =
  [ path
      [ (0.15, -0.4)
      , (0.5, -0.4)
      , (0.5, -0.1)
      ]
    |> border border_
  , text ((0.51),-0.12) "target"
    |> color black 
    |> fontFamily Params.fontCode 
    |> height 0.02 
    |> leftAligned
    |> lineHeight lineHeight_
    
  , text (0.16,-0.42) "1"
    |> color black 
    |> fontFamily Params.fontCode 
    |> height 0.02 
    |> centered 
    |> lineHeight lineHeight_
    
  ]

modelCode = """
type alias Model =
  { world : List Object
  , frames : Frames
  , animation :
      Maybe Animation
  , viewport : Size 
  }
"""

modelText =
  text (0,0) modelCode
    |> color white 
    |> fontFamily Params.fontCode 
    |> height 0.07 
    |> leftAligned
    |> lineHeight lineHeight_
    

world =
  modelBox
  ++
  (objectBox -0.5 0.35)
  ++
  (animationBox 0.5 0)
  ++
  framesBox
  ++
  (frameBox 0 -0.35)
  ++
  (rightArm 0.5)
  ++
  leftArm
  ++
  middleArm
  ++
  (leftArm2 0.3 0 -0.35)
  ++
  (rightArm2 0.3 0 -0.35)
  ++
  middleArm2
  ++
  animationArm
  ++
  [ transformObject (0.005,0.005) (-0.05,0.3925) modelText ]
  |> group

helloWorldExplained = 
  [ frame (0.002,0.0014) (-0.0089,0.2805)  |> duration 1000
  , frame (0.002,0.0014) (-0.0075,0.2784)  |> duration 1000
  ]

modelCodeFrame =
  [ frame (0.005,0.005) (-0.0469,0.391)  |> duration 1000
  ]

objectsFrame =
  [ frame (0.95,0.3) (-0.2,0.35)  |> duration 1000
  ]

framesFrame =
  [ frame (0.5,0.65) (0,-0.15)  |> duration 1000
  ]

modelFrame =
  [ frame (0.3,0.4) (0,0.325)  |> duration 1000
  ]

animationFrame =
  [ frame (0.7,0.7) (0.2,-0.15)  |> duration 1000
  ]

wholeModelFrame =
  [ frame (1,1) (0,0)  |> duration 1000
  ]

frames =
  modelFrame
  ++
  ( List.map 
      (transformFrame (helloWorldWidth,helloWorldHeight) (helloWorldPosX,helloWorldPosY)) 
      helloWorldFrames
  )
  ++
  helloWorldExplained
  ++
  objectsFrame
  ++
  wholeModelFrame
  ++
  framesFrame
  ++
  animationFrame
  ++
  wholeModelFrame
  ++
  modelCodeFrame
