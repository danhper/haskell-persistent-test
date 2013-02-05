{-# LANGUAGE OverloadedStrings #-}

import qualified Data.Text as T
import qualified Database.Persist.MongoDB as P
import qualified Database.Persist.Store as S
import Web.Scotty hiding (body)
import Network (PortID (PortNumber))
import Control.Monad.IO.Class
import qualified Config


main :: IO ()
main = do
    --scotty 3000 $ do
    let conf = P.MongoConf "blog" "localhost" (PortNumber 27017) Nothing P.UnconfirmedWrites 8 8 100
    --pool <- P.createMongoDBPool "blog" "localhost" (PortNumber 27017) Nothing 8 8 100
    pool <- S.createPoolConfig conf
    return ()

      --middleware logStdoutDev
      --middleware $ staticPolicy $ addBase "static"

