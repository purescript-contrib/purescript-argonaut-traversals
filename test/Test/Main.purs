module Test.Main where

import Prelude

import Control.Monad.Eff.Console (log)

import Data.Argonaut.Decode (decodeJson)
import Data.Argonaut.Encode (encodeJson)
import Data.Argonaut.JCursor (JCursor(..))
import Data.Either (Either(..))

import Test.StrongCheck (SC, Result, quickCheck', (<?>))
import Test.StrongCheck.Arbitrary (class Arbitrary, arbitrary)
import Test.StrongCheck.Gen (chooseInt)

newtype TestJCursor = TestJCursor JCursor

runTestJCursor :: TestJCursor -> JCursor
runTestJCursor (TestJCursor cursor) = cursor

instance arbJCursor :: Arbitrary TestJCursor where
  arbitrary = do
    i <- chooseInt 0 2
    TestJCursor <$> case i of
      1 -> JField <$> arbitrary <*> (runTestJCursor <$> arbitrary)
      2 -> JIndex <$> arbitrary <*> (runTestJCursor <$> arbitrary)
      _ -> pure JCursorTop

prop_jcursor_serialization :: TestJCursor -> Result
prop_jcursor_serialization (TestJCursor c) =
  (decodeJson (encodeJson c) == Right c) <?> "JCursor: " <> show c

main :: SC () Unit
main = do
  log "Testing JCursor serialization"
  quickCheck' 20 prop_jcursor_serialization
