{-# LANGUAGE OverloadedStrings #-}

module Api (
    api
) where

import Control.Applicative ((<$>))
import qualified Database.Persist.MongoDB as D
import Web.Scotty
import Control.Monad.IO.Class (liftIO)
import Data.Maybe
import Models
import Util

api :: D.ConnectionPool -> ScottyM ()
api pool = do
    let db action = liftIO $ D.runMongoDBPoolDef action pool

    get "/articles" $ do
        offset <- paramOpt "offset" 0 :: ActionM Int
        limit <- paramOpt "limit" 20 :: ActionM Int
        let options = [D.Desc ArticleCreated, D.OffsetBy offset, D.LimitTo limit]
        entities <- db $ (map withKey) <$> (D.selectList [] options)
        json entities

    get "/article/:pk" $ do
        pk <- toKey <$> param "pk"
        maybeArticle <- D.get pk
        article <- case maybeArticle of
            Just a -> a
            Nothing -> "error"
        json article
