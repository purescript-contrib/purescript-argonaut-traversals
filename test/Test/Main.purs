module Test.Main where

import Prelude

import Control.Monad.Eff.Console (log)

import Data.Argonaut.Decode (decodeJson)
import Data.Argonaut.Encode (encodeJson)
import Data.Argonaut.JCursor (JCursor(..))
import Data.Either (Either(..))
import Data.Monoid (class Monoid)

import Test.StrongCheck (SC, Result, quickCheck', (<?>))
import Test.StrongCheck.Arbitrary (class Arbitrary, arbitrary)
import Test.StrongCheck.Gen (chooseInt)
import Test.StrongCheck.Laws.Data as Data
import Type.Proxy (Proxy(..))

newtype TestJCursor = TestJCursor JCursor

runTestJCursor :: TestJCursor -> JCursor
runTestJCursor (TestJCursor cursor) = cursor

derive newtype instance eqTestJCursor :: Eq TestJCursor
derive newtype instance ordTestJCursor :: Ord TestJCursor
derive newtype instance semigroupTestJCursor :: Semigroup TestJCursor
derive newtype instance monoidTestJCursor :: Monoid TestJCursor

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

  log "Testing laws for JCursor"
  Data.checkEq prxJCursor
  Data.checkOrd prxJCursor
  Data.checkSemigroup prxJCursor
  Data.checkMonoid prxJCursor

  where
  prxJCursor = Proxy :: Proxy TestJCursor
