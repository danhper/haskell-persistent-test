{-# LANGUAGE OverloadedStrings #-}

module Config (
    getDBConfig
) where

import Database.Persist.Store (loadConfig)
import Database.Persist.MongoDB (MongoConf)
import Data.Yaml
import Data.Text
import Data.HashMap.Strict ((!))
import qualified Data.Aeson as A
import Data.Aeson.Types (parse)

getDBConfig :: FilePath -> Text -> IO MongoConf
getDBConfig filepath env = do
    file <- decodeFile filepath
    configs <- maybe (fail "Invalid YAML file") return file

    configVal <- case configs of
        Object o -> return $ o ! env
        _ -> fail "Invalid Yaml"

    let config = loadConfig configVal :: Parser MongoConf

    case parse id config of
        A.Success c -> return c
        _ -> fail "Invalid Yaml"
