{-# LANGUAGE OverloadedStrings,TypeFamilies, TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses, QuasiQuotes, GeneralizedNewtypeDeriving #-}
{-# LANGUAGE EmptyDataDecls, GADTs, FlexibleContexts #-}

module Models(
    Article(..)
  , Comments(..)
) where

import Database.Persist
import Data.Text
import Database.Persist.MongoDB
import Database.Persist.TH
import Language.Haskell.TH.Syntax
import Data.Aeson.TH (deriveJSON)
import Data.Time (UTCTime)


share [mkPersist (mkPersistSettings (ConT ''MongoBackend)) { mpsGeneric = False }, mkMigrate "migrateAll"][persistLowerCase|
Article
  title String
  content Text
  created UTCTime default=CURRENT_TIME
  updated UTCTime default=CURRENT_TIME
  deriving Show Eq Read
Comments
  author String
  content Text
  deriving Show Eq Read
|]

$(deriveJSON id ''Article)
$(deriveJSON id ''Comments)
