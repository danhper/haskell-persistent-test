{-# LANGUAGE OverloadedStrings #-}

module Api (
    api
) where

import Control.Applicative ((<$>))
import Database.Persist.MongoDB hiding (get)
import Models
import Web.Scotty
import Control.Monad.IO.Class (liftIO)

api :: ConnectionPool -> ScottyM ()
api pool = do
    let db action = liftIO $ runMongoDBPoolDef action pool

    get "/articles" $ do
        (db $ map entityVal <$> selectList ([]::[Filter Article]) []) >>= json

