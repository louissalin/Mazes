module Binary.Render where

import Base.OpenGL
import Binary.Generate

type HasTop = Bool
type HasBottom = Bool
type HasLeft = Bool
type HasRight = Bool

data SquareCell = SquareCell Point HasTop HasRight HasBottom HasLeft

type MazeRenderData = [SquareCell]

generatePicture :: BinMaze -> Picture
generatePicture (BinMaze gridSize _) = 
       Pictures
                [ translate 0 0 $ generateLine gridSize
                ]

generateLine :: Int -> Picture
generateLine gridSize = line [ (-cs, -cs)
                             , (-cs,  cs)
                             , ( cs,  cs)
                             , ( cs, -cs)
                             , (-cs, -cs)
                             ]
  where cs = cellSize gridSize / 2.0

generateCell :: Picture
generateCell = undefined

-- generateRenderData :: BinMaze -> MazeRenderData
-- generateRenderData (BinMaze gridSize openings) = 
--   where
--     orderedCells = [(x, y) | y <- reverse [1..gridSize], x <- [1..gridSize]]

-- returns a function with a picture pre-translated
-- posToPoint :: Pos -> (Picture -> Picture)
-- posToPoint p = translate (-200) 100

-- decide if a maze position should be rendered in the negative or positive side of the screen
-- Gloss coords on the screen have (0,0) in the center
translateMult :: Int -> Int -> Int
translateMult gridSize pos 
  | fromIntegral pos < fromIntegral gridSize / 2.0 = -1
  | otherwise = 1

potToPoint :: Pos -> Point
potToPoint = undefined

cellSize :: Int -> Float
cellSize gridSize = fromIntegral mazeSize / fromIntegral gridSize

mazeSize :: Int
mazeSize = min windowWidth windowHeight - border

border :: Int
border = 40


-- dividing line (float) --> (gridSize - (x - 1)) / 2
-- if x < dividing line, go negative
-- else if x >= dividing line, go positive