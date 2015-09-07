module Binary.View
  ( renderMaze
  ) where

import Binary.Generate
import Control.Applicative
import Control.Monad
import Data.List

-- rendering a maze:
-- render top border, a bunch of "-- -- -- -- -- -- -- etc..."
-- then render the cells like this
    -- renderCenterLine (since the top is rendered already) \
    --                                                       (repeat (gridSize - 1) times)
    -- renderBottomLine                                     /
    -- then renderCenterLine one last time (last row here)
-- render bottom border, a bunch of "-- -- -- -- -- -- -- etc..."

renderMaze :: BinMaze -> IO ()
renderMaze maze = do
  _ <- renderHorizontalBorder
  _ <- renderInnerMaze maze orderedCells 1
  _ <- renderHorizontalBorder
  return ()
  where
    orderedCells = [(x, y) | y <- reverse [1..gridSize], x <- [1..gridSize]]

renderInnerMaze :: BinMaze -> [Pos] -> Int -> IO ()
renderInnerMaze maze cells n
  | n < gridSize = do
    _ <- renderCenterLine (take gridSize cells) maze
    _ <- renderBottomLine (take gridSize cells) maze
    renderInnerMaze maze (drop gridSize cells) (n + 1)
  | otherwise = renderCenterLine cells maze

renderHorizontalBorder :: IO ()
renderHorizontalBorder = do
  _ <- putStr " "
  _ <- replicateM_ gridSize (putStr "-- ")
  putStrLn ""

renderCenterLine :: [Pos] -> BinMaze -> IO ()
renderCenterLine cells maze = do
  _ <- putStr "|"
  _ <- mapM_ (renderCenterCell maze) cells
  putStrLn ""

renderCenterCell :: BinMaze -> Pos -> IO ()
renderCenterCell maze p = do
  _ <- putStr "  "
  if renderRight p maze
    then putStr "|"
    else putStr " "

renderBottomLine :: [Pos] -> BinMaze -> IO ()
renderBottomLine cells maze = do
  _ <- putStr " "
  _ <- mapM_ (renderBottomCell maze) cells
  putStrLn ""

renderBottomCell :: BinMaze -> Pos -> IO ()
renderBottomCell maze p = do
  if renderBottom p maze
    then putStr "--"
    else putStr "  "
  putStr " "

