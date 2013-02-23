{-# LANGUAGE OverloadedStrings #-}

module Api (
    api
) where

import Control.Applicative ((<$>))
import qualified Database.Persist.MongoDB as D
import Web.Scotty
import Control.Monad.IO.Class (liftIO)

import Models
import Util

api :: D.ConnectionPool -> ScottyM ()
api pool = do
    let db action = liftIO $ D.runMongoDBPoolDef action pool

    get "/articles" $ do
        offset <- paramOpt "offset" 0 :: ActionM Int
        limit <- paramOpt "limit" 20 :: ActionM Int
        let opts = [D.Desc ArticleCreated, D.OffsetBy offset, D.LimitTo limit]
        entities <- db $ map withKey <$> D.selectList [] opts
        json entities

    get "/articles/:pk" $ do
        keyStr <- param "pk" :: ActionM String
        maybeArticle <- db $ D.get (toKey keyStr :: ArticleId)
        maybe (json404 keyStr) json maybeArticle
