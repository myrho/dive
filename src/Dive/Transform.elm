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

transformTuple : Position -> Size -> (Float, Float) -> (Float, Float)
transformTuple {x,y} {width, height} (xt, yt) =
  (xt*width + x, yt*height + y)

transformPolygon : Position -> Size -> PolygonObject -> PolygonObject
transformPolygon position size object =
  { object
    | gons =
      List.map (transformTuple position size) object.gons
  }

transformImage : Position -> Size -> ImageObject -> ImageObject
transformImage position size object =
  { object
    | width = transformInt object.width size.width
    , height = transformInt object.height size.height
    , position = transformPosition object.position position size
  }

transformInt : Int -> Float -> Int
transformInt int scale =
  toFloat int 
    |> (*) scale
    |> round

transformCroppedImage : Position -> Size -> CroppedImageObject -> CroppedImageObject
transformCroppedImage position size object =
  { object
    | offsetX = transformInt object.offsetX size.width
    , offsetY = transformInt object.offsetY size.height
    , width = transformInt object.width size.width
    , height = transformInt object.height size.height
    , position = transformPosition object.position position size
  } 
