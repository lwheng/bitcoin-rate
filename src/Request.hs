{-# LANGUAGE OverloadedStrings #-}

module Request (
  fetchJSON
) where

import           Network.HTTP.Simple (httpBS, getResponseBody)
import qualified Data.ByteString.Char8 as BS

fetchJSON :: IO BS.ByteString
fetchJSON = getResponseBody <$> httpBS "https://api.coindesk.com/v1/bpi/currentprice.json"
