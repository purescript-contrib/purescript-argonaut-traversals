module Test.Main where

import Prelude

import Data.Argonaut.JCursor
import Data.Argonaut.Encode
import Data.Argonaut.Decode
import Test.StrongCheck
import Test.StrongCheck.Gen

import Control.Monad.Eff.Console (log)
import Data.Either (Either(..))

instance arbJCursor :: Arbitrary JCursor where
  arbitrary = do
    i <- chooseInt 0.0 2.0
    case i of
      0 -> pure JCursorTop
      1 -> JField <$> arbitrary <*> arbitrary
      2 -> JIndex <$> arbitrary <*> arbitrary

prop_jcursor_serialization :: JCursor -> Result 
prop_jcursor_serialization c =
  (decodeJson (encodeJson c) == Right c) <?> "JCursor: " <> show c

main = do
  log "Testing JCursor serialization"
  quickCheck' 20 prop_jcursor_serialization
