{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE EmptyDataDecls #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE FlexibleContexts #-}

module Models(
    Article(..)
  , Comments(..)
) where

import Database.Persist
import Data.Text
import Database.Persist.MongoDB
import Database.Persist.TH
import Language.Haskell.TH.Syntax


share [mkPersist (mkPersistSettings (ConT ''MongoBackend)) { mpsGeneric = False }, mkMigrate "migrateAll"][persistLowerCase|
Article
  title String
  content Text
  deriving Show Eq Read
Comments
  author String
  content Text
  deriving Show Eq Read
|]






