module Dive.Transform exposing (..)

import Dive.Model exposing (..)

transformWorld : Position -> Size -> List Object -> List Object
transformWorld position size =
  List.map (transformObject position size )

transformObject : Position -> Size -> Object -> Object
transformObject position size object =
  case object of
    Text object ->
      Text <| transformText position size object
    Polygon object ->
      Polygon <| transformPolygon position size object
    Rectangle object ->
      Rectangle <| transformRectangle position size object
    Path object ->
      Path <| transformPath position size object
    Image object ->
      Image <| transformImage position size object
    FittedImage object ->
      FittedImage <| transformImage position size object
    TiledImage object ->
      TiledImage <| transformImage position size object
    CroppedImage object ->
      CroppedImage <| transformCroppedImage position size object

transformText : Position -> Size -> TextObject -> TextObject
transformText position size object =
  { object
    | size = object.size * size.height
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
    | width = transformX object.width size.width
    , height = transformX object.height size.height
    , position = transformPosition object.position position size
  }

transformX : Float -> Float -> Float
transformX x scale =
  x * scale

transformCroppedImage : Position -> Size -> CroppedImageObject -> CroppedImageObject
transformCroppedImage position size object =
  { object
    | offsetX = transformX object.offsetX size.width
    , offsetY = transformX object.offsetY size.height
    , width = transformX object.width size.width
    , height = transformX object.height size.height
    , position = transformPosition object.position position size
  } 

transformFrame : Position -> Size -> Frame -> Frame 
transformFrame position size frame =
  { frame 
    | position = transformPosition frame.position position size
    , size = transformSize frame.size size
  }
