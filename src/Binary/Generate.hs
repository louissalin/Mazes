module Binary.Generate 
  ( Direction(..)
  , Opening(..)
  , Pos
  , BinMaze
  , generateMaze
  , gridSize
  ) where

import Control.Applicative
import Control.Monad
import Data.List
import System.Random

-- Generates a binary maze. For each cell in the maze, decide to either
-- open up the cell to the north or to the east, unless we're at the
-- rightmost or topmost cells, in which case we have no choice as to 
-- where to put the opening.

-- Grid coordinates
-- ...
-- 5
-- 4
-- 3
-- 2
-- 1
--   1 2 3 4 5 ...

-- a cell will be printed like this
--  --
-- |  |
--  --

data Direction = North | East deriving (Show)

data Opening = Opening Pos Direction 
             | NoOpening Pos -- the top right cell will have no opening at all
             deriving (Show)

type Pos = (Int, Int)

-- a maze is really just a list of openings
type BinMaze = [Opening]

gridSize = 5

chooseDirection :: IO Direction
chooseDirection = do
  n <- randomIO :: IO Float
  if n > 0.5
    then (return North)
    else (return East)

generateMaze :: IO BinMaze
generateMaze = 
  let allPos = [(x, y) | x <- [1..gridSize], y <- [1..gridSize]]
  in  mapM generateOpening allPos

generateOpening :: Pos -> IO Opening
generateOpening p@(x, y)
  | x == gridSize && y == gridSize = return $ NoOpening p
  | x == gridSize && y < gridSize  = return $ Opening p North
  | x < gridSize && y == gridSize  = return $ Opening p East
  | otherwise                      = Opening p <$> chooseDirection