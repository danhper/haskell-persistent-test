module BsonTool (
  ToBSON,
  FromBSON,
  toBSON,
  fromBSON
) where

import Data.Bson as B

class FromBSON a where
  fromBSON :: B.Value -> a

class ToBSON a where
  toBSON :: a -> B.Value

instance FromBSON [B.Value] where
  fromBSON (B.Array values) = map fromBSON values
