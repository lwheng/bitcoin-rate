{-# LANGUAGE OverloadedStrings #-}
 
import           Blaze.ByteString.Builder (copyByteString)
import           Data.Monoid
import           Network.HTTP.Types (status200)
import           Network.Wai
import           Network.Wai.Handler.Warp
import qualified Data.ByteString.UTF8 as BU
 
main = do
    let port = 3000
    putStrLn $ "Listening on port " ++ show port
    run port app
 
app req respond = respond $
    case pathInfo req of
        ["yay"] -> yay
        x -> index x
 
yay = responseBuilder status200 [ ("Content-Type", "text/plain") ] $ mconcat $ map copyByteString
    [ "yay" ]
 
index x = responseBuilder status200 [("Content-Type", "text/html")] $ mconcat $ map copyByteString
    [ "<p>Hello from ", BU.fromString $ show x, "!</p>"
    , "<p><a href='/yay'>yay</a></p>\n" ]
