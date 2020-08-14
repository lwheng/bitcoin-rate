{-# LANGUAGE OverloadedStrings #-}

-- | Parse contains functions to access the JSON object
module Parse (
    getRate
  , getUpdated
) where

import           Data.Text (Text)
import qualified Control.Lens as Lens
import qualified Data.Aeson.Lens as Aeson
import qualified Data.ByteString.Char8 as BS

-- | getRate attempts to get the USD rate
getRate
  :: BS.ByteString
  -> Maybe Text
getRate = Lens.preview (Aeson.key "bpi" . Aeson.key "USD" . Aeson.key "rate" . Aeson._String)

-- | getUpdated attempts to get the updated time
getUpdated
  :: BS.ByteString
  -> Maybe Text
getUpdated = Lens.preview (Aeson.key "time" . Aeson.key "updated" . Aeson._String)
