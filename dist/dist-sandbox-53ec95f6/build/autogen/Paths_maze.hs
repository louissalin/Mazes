module Paths_maze (
    version,
    getBinDir, getLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
catchIO = Exception.catch


version :: Version
version = Version {versionBranch = [0,1,0,0], versionTags = []}
bindir, libdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/Users/louis/projects/mazes/.cabal-sandbox/bin"
libdir     = "/Users/louis/projects/mazes/.cabal-sandbox/lib/x86_64-osx-ghc-7.8.3/maze-0.1.0.0"
datadir    = "/Users/louis/projects/mazes/.cabal-sandbox/share/x86_64-osx-ghc-7.8.3/maze-0.1.0.0"
libexecdir = "/Users/louis/projects/mazes/.cabal-sandbox/libexec"
sysconfdir = "/Users/louis/projects/mazes/.cabal-sandbox/etc"

getBinDir, getLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "maze_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "maze_libdir") (\_ -> return libdir)
getDataDir = catchIO (getEnv "maze_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "maze_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "maze_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
