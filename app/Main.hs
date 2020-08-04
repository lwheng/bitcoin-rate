module Main where

import qualified Lib as L

main :: IO ()
main = do
  res <- L.fetchJSON
  print res
