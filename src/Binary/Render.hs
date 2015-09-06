module Binary.Render where

import Base.OpenGL
import Binary.Generate

generatePicture :: BinMaze -> Picture
generatePicture _ = 
       Pictures
                [ translate (-200) 100 $ line [(-30, -30), (-40, 30), (30, 40), (50, -20), (-30, -30)]
                ]

