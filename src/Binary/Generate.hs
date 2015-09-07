module Binary.Generate 
  ( Direction(..)
  , Opening(..)
  , Pos
  , BinMaze(..)
  , generateMaze
  , renderRight
  , renderBottom
  , renderTop
  , renderLeft
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

-- a maze is really just a list of openings and a grid size
data BinMaze = BinMaze Int [Opening]

chooseDirection :: IO Direction
chooseDirection = do
  n <- randomIO :: IO Float
  if n > 0.5
    then (return North)
    else (return East)

generateMaze :: Int -> IO BinMaze
generateMaze gridSize = 
  let allPos = [(x, y) | x <- [1..gridSize], y <- [1..gridSize]]
  in  BinMaze gridSize <$> mapM (generateOpening gridSize) allPos

generateOpening :: Int -> Pos -> IO Opening
generateOpening gridSize p@(x, y)
  | x == gridSize && y == gridSize = return $ NoOpening p
  | x == gridSize && y < gridSize  = return $ Opening p North
  | x < gridSize && y == gridSize  = return $ Opening p East
  | otherwise                      = Opening p <$> chooseDirection


-- utility functions to discover things about the maze
-- 

findOpening :: Pos -> BinMaze -> Maybe Opening 
findOpening p (BinMaze _ openings) = find isCell openings
  where 
    isCell (Opening p' _) = p == p'
    isCell (NoOpening p') = p == p'

renderRight :: Pos -> BinMaze -> Bool
renderRight p maze = case findOpening p maze of
  Just (Opening _ East) -> False
  _                     -> True

renderBottom :: Pos -> BinMaze -> Bool
renderBottom (x, y) maze = case findOpening (x, y - 1) maze of
  Just (Opening _ North) -> False
  _                      -> True

renderTop :: Pos -> BinMaze -> Bool
renderTop p maze = case findOpening p maze of
  Just (Opening _ North) -> False
  _                      -> True

renderLeft :: Pos -> BinMaze -> Bool
renderLeft (x, y) maze = case findOpening (x - 1, y) maze of
  Just (Opening _ East) -> False
  _                     -> True