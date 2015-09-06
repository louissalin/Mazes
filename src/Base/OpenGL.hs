module Base.OpenGL 
  ( module Graphics.Gloss.Rendering
  , module Graphics.Gloss.Data.Picture
  , run
  , renderFrame
  , SquareCell(..)
  ) where

import Graphics.UI.GLFW as GLFW
import Graphics.Gloss.Rendering
import Graphics.Gloss.Data.Color
import Graphics.Gloss.Data.Picture
import System.Exit ( exitSuccess )
import Control.Concurrent (threadDelay)
import Control.Monad (when, unless)

windowWidth, windowHeight :: Int
windowWidth  = 640
windowHeight = 480

type HasTop = Bool
type HasBottom = Bool
type HasLeft = Bool
type HasRight = Bool

data SquareCell = SquareCell Point HasTop HasRight HasBottom HasLeft

run :: (Window -> IO ()) -> IO ()
run renderFunc = do
    glossState <- initState
    withWindow windowWidth windowHeight "Maze" $ \win -> do
          renderFunc win 
          loop win
          exitSuccess
    where loop window =  do
            pollEvents
            k <- keyIsPressed window Key'Escape
            unless k $ loop window

renderFrame glossState pics window = do
     displayPicture (windowWidth, windowHeight) white glossState 1.0 pics
     swapBuffers window

withWindow :: Int -> Int -> String -> (GLFW.Window -> IO ()) -> IO ()
withWindow width height title f = do
    GLFW.setErrorCallback $ Just simpleErrorCallback
    r <- GLFW.init
    when r $ do
        m <- GLFW.createWindow width height title Nothing Nothing
        case m of
          (Just win) -> do
              GLFW.makeContextCurrent m
              f win
              GLFW.setErrorCallback $ Just simpleErrorCallback
              GLFW.destroyWindow win
          Nothing -> return ()
        GLFW.terminate
  where
    simpleErrorCallback e s =
        putStrLn $ unwords [show e, show s]

keyIsPressed :: Window -> Key -> IO Bool
keyIsPressed win key = isPress `fmap` GLFW.getKey win key

isPress :: KeyState -> Bool
isPress KeyState'Pressed   = True
isPress KeyState'Repeating = True
isPress _                  = False