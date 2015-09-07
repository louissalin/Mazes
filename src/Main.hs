import Base.OpenGL
import Binary.Generate
import Binary.Render
import System.Environment

main :: IO ()
main = do
  size <- getArgs
  maze <- generateMaze $ read (head size)

  -- OpenGl rendering
  glossState <- initState
  run $ renderFrame glossState $ generatePicture maze
