{-# LANGUAGE OverloadedStrings #-}

import qualified Database.Persist.MongoDB as P
import qualified Database.Persist.Store as S
import qualified Config
import Models

main :: IO ()
main = do
    conf <- Config.getDBConfig settingsFile "development"
    pool <- S.createPoolConfig conf
    P.runMongoDBPoolDef (S.insert $ Article "test" "lorem ipsum") pool
    return ()
    where
        settingsFile = "../../config/db.yml"

      --middleware logStdoutDev
      --middleware $ staticPolicy $ addBase "static"

