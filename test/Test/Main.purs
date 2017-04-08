module Test.Main where

import Prelude

import Control.Monad.Eff.Console (log)

import Data.Argonaut.Decode (decodeJson)
import Data.Argonaut.Encode (encodeJson)
import Data.Argonaut.JCursor.Gen (genJCursor)
import Data.Either (Either(..))

import Test.StrongCheck (SC, Result, quickCheck, (<?>))
import Test.StrongCheck.Gen (Gen)

prop_jcursor_serialization :: Gen Result
prop_jcursor_serialization = do
  c <- genJCursor
  pure $ (decodeJson (encodeJson c) == Right c) <?> "JCursor: " <> show c

main :: SC () Unit
main = do
  log "Testing JCursor serialization"
  quickCheck prop_jcursor_serialization
