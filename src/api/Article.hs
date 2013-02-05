{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE DeriveDataTypeable #-}

module Article (
    Article
  )
where

import qualified Data.Aeson as A
import Data.Aeson ((.=), (.:))
import Data.Aeson.TH (deriveJSON, deriveFromJSON)
import qualified Data.Bson as B
import Data.Bson (Field((:=)), (!?))
import qualified Data.Text as T
import Data.Typeable (Typeable)
import Data.Word
import Data.Time.Clock.POSIX (posixSecondsToUTCTime)
import Data.Time.Format
import System.Locale (defaultTimeLocale)

data Article = Article {
  ident :: Maybe B.ObjectId,
  title :: String,
  content :: String
} deriving(Show, Eq, Typeable)

instance A.ToJSON B.ObjectId where
  toJSON (B.Oid ts value) = A.object ["time" .= time,
                                      "id"   .= value]
    where time = formatTime defaultTimeLocale "%s" (posixSecondsToUTCTime $ (fromIntegral ts))

instance A.FromJSON B.ObjectId where
  parseJSON (A.Object v) = do
    time <- v .: "time"
    ident <- v .: "id"
    return $ B.Oid (read time :: Word32) (read ident :: Word64)


$(deriveJSON id ''Article)

instance B.Val Article where
  val article = case ident article of
    Just i -> 
        B.Doc ["_id" := (B.ObjId i), "title" := t, "content" := c]
    Nothing -> B.Doc ["title" := t, "content" := c]
    where
      t = (B.String . T.pack . title) article
      c = (B.String . T.pack . content) article
  cast' article = case article of
    B.Doc d -> do
      let _ident = case B.look "_id" d of 
                     Just (B.ObjId i) -> Just i
                     Nothing -> Nothing
          _title = B.look "title" d
          _content = B.look "content" d
      case (_title, _content) of
        (Just (B.String t), Just (B.String c)) -> 
                Just $ Article _ident (T.unpack t) (T.unpack c)
        _ -> Nothing
    _ -> Nothing

