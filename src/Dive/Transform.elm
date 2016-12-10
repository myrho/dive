module Dive.Transform exposing (..)

import Dive.Model exposing (..)

transformText : Position -> Size -> TextObject -> TextObject
transformText position size object =
  { object
    | height = object.height * size.height
    , position = transformPosition object.position position size
  }

transformPosition : Position -> Position -> Size -> Position
transformPosition {x,y} position size =
  { x = x * size.width + position.x
  , y = y * size.height + position.y
  }

transformSize : Size -> Size -> Size
transformSize {width, height} size =
  { size
    | width = width * size.width
    , height = height * size.height
  }

transformTuple : Position -> Size -> (Float, Float) -> (Float, Float)
transformTuple {x,y} {width, height} (xt, yt) =
  (xt*width + x, yt*height + y)

transformPolygon : Position -> Size -> PolygonObject -> PolygonObject
transformPolygon position size object =
  { object
    | gons =
      List.map (transformTuple position size) object.gons
  }

transformRectangle : Position -> Size -> RectangleObject -> RectangleObject
transformRectangle position size object =
  { object
    | size = transformSize object.size size
    , position = transformPosition object.position position size
  }

transformPath : Position -> Size -> PathObject -> PathObject
transformPath position size object =
  { object
    | path = List.map (transformTuple position size) object.path
  }

transformImage : Position -> Size -> ImageObject -> ImageObject
transformImage position size object =
  { object
    | size = transformSize object.size size
    , position = transformPosition object.position position size
  }

transformX : Float -> Float -> Float
transformX x scale =
  x * scale

transformCroppedImage : Position -> Size -> CroppedImageObject -> CroppedImageObject
transformCroppedImage position size object =
  { object
    | offset = 
        Position
          (transformX object.offset.x size.width)
          (transformX object.offset.y size.height)
    , size = transformSize object.size size
    , position = transformPosition object.position position size
  } 

