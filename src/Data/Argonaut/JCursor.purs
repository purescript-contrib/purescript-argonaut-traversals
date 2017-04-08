module Data.Argonaut.JCursor where

import Prelude

import Data.Argonaut.Core as J
import Data.Argonaut.Decode (class DecodeJson, decodeJson)
import Data.Argonaut.Encode (class EncodeJson, encodeJson)
import Data.Array as A
import Data.Either (Either(..))
import Data.Unfoldable (replicate)
import Data.Foldable (foldl)
import Data.Int as I
import Data.List (List(), zipWith, range, head, singleton, fromFoldable)
import Data.Maybe (Maybe(..), fromMaybe, maybe)
import Data.Monoid (class Monoid)
import Data.StrMap as M
import Data.Tuple (Tuple(..), fst, snd)

data JCursor
  = JCursorTop
  | JField String JCursor
  | JIndex Int JCursor

derive instance eqJCursor :: Eq JCursor
derive instance ordJCursor :: Ord JCursor

instance showJCursor :: Show JCursor where
  show JCursorTop = "JCursorTop"
  show (JField i c) = "(JField " <> show i <> " " <> show c <> ")"
  show (JIndex i c) = "(JIndex " <> show i <> " " <> show c <> ")"

print :: JCursor -> String
print JCursorTop = ""
print (JField i c) = "." <> i <> show c
print (JIndex i c) = "[" <> show i <> "]" <> show c

instance semigroupJCursor :: Semigroup JCursor where
  append a JCursorTop = a
  append JCursorTop b = b
  append (JField i a) b = JField i (a <> b)
  append (JIndex i a) b = JIndex i (a <> b)

instance monoidJCursor :: Monoid JCursor where
  mempty = JCursorTop

instance encodeJsonJCursor :: EncodeJson JCursor where
  encodeJson = encodeJson <<< loop where
    loop JCursorTop = []
    loop (JField i c) = [encodeJson i] <> loop c
    loop (JIndex i c) = [encodeJson i] <> loop c

newtype JsonPrim = JsonPrim (forall a. (J.JNull -> a) -> (J.JBoolean -> a) -> (J.JNumber -> a) -> (J.JString -> a) -> a)

runJsonPrim :: JsonPrim -> (forall a. (J.JNull -> a) -> (J.JBoolean -> a) -> (J.JNumber -> a) -> (J.JString -> a) -> a)
runJsonPrim (JsonPrim p) = p

instance showJsonPrim :: Show JsonPrim where
  show p = runJsonPrim p show show show show

primNull :: JsonPrim
primNull = JsonPrim (\f _ _ _ -> f J.jNull)

primBool :: J.JBoolean -> JsonPrim
primBool v = JsonPrim (\_ f _ _ -> f v)

primNum :: J.JNumber -> JsonPrim
primNum v = JsonPrim (\_ _ f _ -> f v)

primStr :: J.JString -> JsonPrim
primStr v = JsonPrim (\_ _ _ f -> f v)

primToJson :: JsonPrim -> J.Json
primToJson p = runJsonPrim p J.fromNull J.fromBoolean J.fromNumber J.fromString

insideOut :: JCursor -> JCursor
insideOut JCursorTop = JCursorTop
insideOut (JField i c) = downField i (insideOut c)
insideOut (JIndex i c) = downIndex i (insideOut c)

downField :: String -> JCursor -> JCursor
downField i = downField' where
  downField' JCursorTop = JField i JCursorTop
  downField' (JField i' c) = JField i' (downField' c)
  downField' (JIndex i' c) = JIndex i' (downField' c)

downIndex :: Int -> JCursor -> JCursor
downIndex i = downIndex' where
  downIndex' JCursorTop = JIndex i JCursorTop
  downIndex' (JField i' c) = JField i' (downIndex' c)
  downIndex' (JIndex i' c) = JIndex i' (downIndex' c)

cursorGet :: JCursor -> J.Json -> Maybe J.Json
cursorGet JCursorTop = Just
cursorGet (JField i c) = J.foldJsonObject Nothing (cursorGet c <=< M.lookup i)
cursorGet (JIndex i c) = J.foldJsonArray Nothing (cursorGet c <=< (_ A.!! i))

inferEmpty :: JCursor -> J.Json
inferEmpty JCursorTop   = J.jsonNull
inferEmpty (JField _ _) = J.jsonEmptyObject
inferEmpty (JIndex _ _) = J.jsonEmptyArray

cursorSet :: JCursor -> J.Json -> J.Json -> Maybe J.Json
cursorSet JCursorTop v = pure <<< const v
cursorSet (JField i c) v = J.foldJsonObject defaultObj mergeObjs
  where
  defaultObj :: Maybe J.Json
  defaultObj = J.fromObject <<< M.singleton i <$> cursorSet c v (inferEmpty c)
  mergeObjs :: J.JObject -> Maybe J.Json
  mergeObjs m
    = J.fromObject
    <<< flip (M.insert i) m
    <$> cursorSet c v (fromMaybe (inferEmpty c) (M.lookup i m))
cursorSet (JIndex i c) v = J.foldJsonArray defaultArr mergeArrs
  where
  defaultArr :: Maybe J.Json
  defaultArr
    = J.fromArray
    <$> (flip (A.updateAt i) (replicate (i + 1) J.jsonNull) =<< cursorSet c v (inferEmpty c))
  mergeArrs :: J.JArray -> Maybe J.Json
  mergeArrs a =
    setArr a i =<< cursorSet c v (fromMaybe (inferEmpty c) (a A.!! i))
  setArr :: J.JArray -> Int -> J.Json -> Maybe J.Json
  setArr xs i' v' =
    let len = A.length xs
    in if i' < 0
       then Nothing
       else if i' >= len
            then setArr (xs <> (replicate (i' - len + 1) J.jsonNull)) i' v'
            else J.fromArray <$> A.updateAt i' v' xs

toPrims :: J.Json -> List (Tuple JCursor JsonPrim)
toPrims = J.foldJson nullFn boolFn numFn strFn arrFn objFn
  where
  mkTop :: JsonPrim -> List (Tuple JCursor JsonPrim)
  mkTop p = singleton $ Tuple JCursorTop p
  nullFn :: J.JNull -> List (Tuple JCursor JsonPrim)
  nullFn _ = mkTop primNull
  boolFn :: J.JBoolean -> List (Tuple JCursor JsonPrim)
  boolFn b = mkTop $ primBool b
  numFn :: J.JNumber -> List (Tuple JCursor JsonPrim)
  numFn n = mkTop $ primNum n
  strFn :: J.JString -> List (Tuple JCursor JsonPrim)
  strFn s = mkTop $ primStr s
  arrFn :: J.JArray -> List (Tuple JCursor JsonPrim)
  arrFn arr =
    let zipped :: List (Tuple Int J.Json)
        zipped = zipWith Tuple (range 0 (A.length arr - 1)) (fromFoldable arr)
    in zipped >>= arrFn'
  arrFn' :: Tuple Int J.Json -> List (Tuple JCursor JsonPrim)
  arrFn' (Tuple i j) =
    fromFoldable ((\t -> Tuple (JIndex i (fst t)) (snd t)) <$> toPrims j)
  objFn :: J.JObject -> List (Tuple JCursor JsonPrim)
  objFn obj =
    let f :: Tuple String J.Json -> List (Tuple JCursor JsonPrim)
        f (Tuple i j) = (\t -> Tuple (JField i (fst t)) (snd t)) <$> toPrims j
    in M.toUnfoldable obj >>= f

fromPrims :: List (Tuple JCursor JsonPrim) -> Maybe J.Json
fromPrims lst = foldl f (inferEmpty <<< fst <$> head lst) lst
  where
  f :: Maybe J.Json -> Tuple JCursor JsonPrim -> Maybe J.Json
  f j (Tuple c p) = j >>= cursorSet c (primToJson p)

fail :: forall a b. Show a => a -> Either String b
fail x = Left $ "Expected String or Number but found: " <> show x

instance decodeJsonJCursor :: DecodeJson JCursor where
  decodeJson j = decodeJson j >>= loop
    where
    loop :: Array J.Json -> Either String JCursor
    loop arr =
      maybe (Right JCursorTop) goLoop $ Tuple <$> A.head arr <*> A.tail arr
    goLoop :: Tuple J.Json (Array J.Json) -> Either String JCursor
    goLoop (Tuple x xs) = do
      c <- loop xs
      J.foldJson fail fail (goNum c) (Right <<< flip JField c) fail fail x
    goNum :: JCursor -> J.JNumber -> Either String JCursor
    goNum c =
      maybe (Left "Not an Int") (Right <<< flip JIndex c) <<< I.fromNumber
