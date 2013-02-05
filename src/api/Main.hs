{-# LANGUAGE OverloadedStrings #-}

import qualified Database.Persist.Store as S
import qualified Config
import qualified Api
import Web.Scotty

main :: IO ()
main = do
    -- TODO: set environment with command line argument
    conf <- Config.getDBConfig settingsFile "development"
    pool <- S.createPoolConfig conf

    -- TODO: set port with command line argument
    scotty 3000 $ do
        Api.api pool

    where
        settingsFile = "../../config/db.yml"

