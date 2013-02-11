{-# LANGUAGE OverloadedStrings #-}

module Util (
    paramOpt
  , withKey
  , toKey
) where

import Data.Aeson
import Web.Scotty
import qualified Data.Text.Lazy as T
import qualified Database.Persist.Store as D
import Web.PathPieces (toPathPiece)
import Data.HashMap.Strict (insert)


paramOpt :: (Parsable a) => T.Text -> a -> ActionM a
paramOpt k d = param k `rescue` (\_ -> return d)

toKey :: String -> D.Key entity
toKey x = D.Key $ D.toPersistValue $ toPathPiece x

withKey :: (ToJSON a) => D.Entity a -> Value
withKey e = case toJSON $ D.entityVal e of
    Object o -> toJSON $ insert "id" (toJSON $ D.entityKey e) o
    _ -> error "error"
