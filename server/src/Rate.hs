{-# LANGUAGE OverloadedStrings #-}

module Rate where

import           Data.Text (Text)
import qualified Parse as P
import qualified Request as R

rate :: IO Text
rate = do
  json <- R.fetchJSON

  let
    maybeRate    = P.getRate    json
    maybeUpdated = P.getUpdated json

    strUpdated = case maybeUpdated of
                   Just updated -> "As of " <> updated
                   Nothing      -> "Currently"

    strOutput = case maybeRate of
                  Just r  -> strUpdated <> ", the Bitcoin rate is USD " <> r
                  Nothing -> "Could not find the Bitcoin rate :("

  return strOutput
