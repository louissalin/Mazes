import Binary.Generate
import Binary.View

main :: IO ()
main = do
  maze <- generateMaze
  renderMaze maze
