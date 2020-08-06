{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ScopedTypeVariables #-}
 
import           Blaze.ByteString.Builder (copyByteString)
import           Data.Text (Text)
import           Network.HTTP.Types (status200)
import           Network.Wai
import           Network.Wai.Handler.Warp
import qualified Data.ByteString.UTF8 as BU
import qualified Data.Text.Encoding as Encoding
import qualified Rate as R

main :: IO ()
main = do
    let 
      port :: Int = 3000
    putStrLn $ "Listening on port " ++ show port
    run port app

app
  :: Request
  -> (Response -> IO ResponseReceived)
  -> IO ResponseReceived
app req respond = do
  response <-
    case pathInfo req of
      ["bitcoin-rate"] -> do
        textRate <- R.rate
        return $ bitcoinRate textRate
      x -> return $ unsupportedPath x
  respond response

-- | bitcoinRate returns the result of R.rate as a HTTP response
bitcoinRate
  :: Text
  -> Response
bitcoinRate txt =
  responseBuilder
    status200
    [ ("Content-Type", "text/plain") ]
    $ mconcat $ map copyByteString [ Encoding.encodeUtf8 txt ]

unsupportedPath
  :: [Text]
  -> Response
unsupportedPath x =
  responseBuilder
    status200
    [ ("Content-Type", "text/plain") ]
    $ mconcat $ map copyByteString [ "Don't know how to respond to "
                                   , BU.fromString $ show x
                                   ]
