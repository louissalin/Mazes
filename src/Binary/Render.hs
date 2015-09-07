module Binary.Render where

import Base.OpenGL
import Binary.Generate
import Data.Monoid

-- for each grid position in the maze, generate a cell and position it on the screen
generatePicture :: BinMaze -> Picture
generatePicture m@(BinMaze gridSize _) = 
  Pictures $ fmap (\p -> translate (getX p) (getY p) $ generateCell m p) orderedCells
  where
    orderedCells = [(x, y) | y <- [1..gridSize], x <- [1..gridSize]]
    getX p = fst $ posToPoint gridSize p
    getY p = snd $ posToPoint gridSize p

-- given a maze and a position to render, generate the lines that form a cell, taking openings into account
-- the lines widths will vary depending on the window size and the maze's grid size
generateCell :: BinMaze -> Pos -> Picture
generateCell m@(BinMaze gridSize _) p = topLine p m <> bottomLine p m <> rightLine p m <> leftLine p m
  where 
    cs = cellSize gridSize / 2.0
    topLine p m    = Pictures $ if renderTop p m    then [line [(-cs,  cs), ( cs,  cs)]] else []
    bottomLine p m = Pictures $ if renderBottom p m then [line [(-cs, -cs), ( cs, -cs)]] else []
    rightLine p m  = Pictures $ if renderRight p m  then [line [( cs,  cs), ( cs, -cs)]] else []
    leftLine p m   = Pictures $ if renderLeft p m   then [line [(-cs,  cs), (-cs, -cs)]] else []

-- convert a grid position (in grid coordinates) into view coordinates so a cell can be positioned on the screen.
-- 
-- On the screen, the origin (0,0) is in the middle of the view window.
-- This conversion measures the distance between a position in grid coordinates (1,1) .. (n,n) and the middle 
-- of the maze's grid. Then 0.5 is substracted so we get the distance from the middle of a cell to the origin. 
-- The calculated distance is then multiplied by the cell size to get it's final position on the screen.
-- In other words, a cell can be 2.5 cell sizes away from the middle to the right, or 1 cell size away to the left, etc.
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
