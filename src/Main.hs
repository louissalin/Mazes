import Base.OpenGL
import Binary.Generate
import Binary.Render

main :: IO ()
main = do
  maze <- generateMaze 1

  -- OpenGl rendering
  glossState <- initState
  run $ renderFrame glossState $ generatePicture maze
