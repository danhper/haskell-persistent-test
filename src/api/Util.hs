{-# LANGUAGE OverloadedStrings #-}

module Util (
    paramOpt
  , withKey
  , toKey
  , json404
) where

import Data.Aeson
import Web.Scotty as W

import qualified Data.Text as T
import qualified Data.Text.Lazy as LT
import Web.PathPieces (fromPathPiece)
import qualified Database.Persist.MongoDB as D
import qualified Database.Persist.Store as S
import qualified Database.MongoDB as DB
import qualified Data.Serialize as Serialize
import Control.Exception (throw)
import Data.HashMap.Strict (insert)
import Data.Maybe
import Network.HTTP.Types (status404)


paramOpt :: (Parsable a) => LT.Text -> a -> ActionM a
paramOpt k d = param k `rescue` (\_ -> return d)

toKey :: String -> D.KeyBackend D.MongoBackend entity
toKey = fromJust . fromPathPiece . T.pack

getOid :: S.PersistValue -> DB.ObjectId
getOid (S.PersistObjectId k) = case Serialize.decode k of
                  Left msg -> throw $ S.PersistError $ T.pack $ "error decoding " ++ show k ++ ": " ++ msg
                  Right o -> o
getOid _ = throw $ S.PersistInvalidField "expected PersistObjectId"

getOidAsString :: D.Entity a -> String
getOidAsString e = show . getOid . D.unKey $ D.entityKey e

withKey :: (ToJSON a) => D.Entity a -> Value
withKey e = case toJSON $ D.entityVal e of
    Object o -> toJSON $ insert "id" (toJSON $ getOidAsString e) o
    _ -> error "error"

json404 :: String -> ActionM ()
json404 oid = do
    status status404
    W.json $ object ["error" .= (oid ++ " not found")]
