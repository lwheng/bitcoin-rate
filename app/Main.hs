{-# LANGUAGE OverloadedStrings #-}

module Main where

import qualified Data.Text.IO as TIO
import qualified Parse as P
import qualified Request as R

main :: IO ()
main = do
  json <- R.fetchJSON

  let
    maybeRate    = P.getRate    json
    maybeUpdated = P.getUpdated json

    strUpdated = case maybeUpdated of
                   Just updated -> "As of " <> updated
                   Nothing      -> "Currently"

    strOutput = case maybeRate of
                  Just rate -> strUpdated <> ", the Bitcoin rate is USD " <> rate
                  Nothing   -> "Could not find the Bitcoin rate :("

  TIO.putStrLn strOutput
