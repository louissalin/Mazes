# Mazes

I recently bough [Mazes for Programmers](https://pragprog.com/book/jbmaze/mazes-for-programmers) and wanted to code the algorithms in Haskell.
The maze is generated and then rendered using OpenGL, using code I stole from [Elise Huard](https://github.com/elisehuard/game-in-haskell/) and her book, [Game in Haskell](https://leanpub.com/gameinhaskell)

## to build
using cabal:

```
$ cabal sandbox init
$ cabal install
$ cabal build
```

## to run
the executable takes a grid size as a parameter and renders the generated maze in a 640x480 window.

`$ cabal run 20`

or

`$ ./dist/build/maze/maze 15`
