module Binary.Render where

import Base.OpenGL
import Binary.Generate
import Data.Monoid

generatePicture :: BinMaze -> Picture
generatePicture m@(BinMaze gridSize _) = 
  Pictures $ fmap (\p -> translate (getX p) (getY p) $ generateCell m p) orderedCells
       -- Pictures $ 
       --          [ translate 0 0 $ generateLine gridSize
       --          ]
  where
    orderedCells = [(x, y) | y <- [1..gridSize], x <- [1..gridSize]]
    getX p = fst $ posToPoint gridSize p
    getY p = snd $ posToPoint gridSize p

generateLine :: Int -> Picture
generateLine gridSize = line [ (-cs, -cs)
                             , (-cs,  cs)
                             , ( cs,  cs)
                             , ( cs, -cs)
                             , (-cs, -cs)
                             ]
  where cs = cellSize gridSize / 2.0

generateCell :: BinMaze -> Pos -> Picture
generateCell m@(BinMaze gridSize _) p = topLine p m <> bottomLine p m
  where 
    cs = cellSize gridSize / 2.0
    topLine p m    = Pictures $ if renderTop p m    then [line [(-cs,  cs), ( cs,  cs)]] else []
    bottomLine p m = Pictures $ if renderBottom p m then [line [(-cs, -cs), ( cs, -cs)]] else []
    rightLine p m  = Pictures $ if renderRight p m  then [line [( cs,  cs), ( cs, -cs)]] else []
    leftLine p m   = Pictures $ if renderLeft p m   then [line [(-cs,  cs), (-cs, -cs)]] else []

posToPoint :: Int -> Pos -> Point
posToPoint gridSize (x, y) = ( distance x * cellSize gridSize
                             , distance y * cellSize gridSize
                             )
  where
    distance c = fromIntegral c - divLine - 0.5
    divLine    = fromIntegral gridSize / 2.0

cellSize :: Int -> Float
cellSize gridSize = fromIntegral mazeSize / fromIntegral gridSize

mazeSize :: Int
mazeSize = min windowWidth windowHeight - border

border :: Int
border = 40


-- dividing line (float) --> (gridSize - (x - 1)) / 2
-- if x < dividing line, go negative
-- else if x >= dividing line, go positive