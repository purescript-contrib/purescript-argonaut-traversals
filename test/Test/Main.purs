module Test.Main where

import Prelude

import Data.Argonaut.Decode (decodeJson)
import Data.Argonaut.Encode (encodeJson)
import Data.Argonaut.JCursor.Gen (genJCursor)
import Data.Either (Either(..))
import Effect (Effect)
import Effect.Console (log)
import Test.QuickCheck (Result, quickCheck, (<?>))
import Test.QuickCheck.Gen (Gen)

prop_jcursor_serialization :: Gen Result
prop_jcursor_serialization = do
  c <- genJCursor
  pure $ (decodeJson (encodeJson c) == Right c) <?> "JCursor: " <> show c

main :: Effect Unit
main = do
  log "Testing JCursor serialization"
  quickCheck prop_jcursor_serialization
