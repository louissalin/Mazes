import Base.OpenGL
import Binary.Generate
import Binary.View

main :: IO ()
main = do
  maze <- generateMaze

  -- OpenGl rendering
  glossState <- initState
  run $ renderFrame glossState
