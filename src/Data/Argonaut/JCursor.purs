module Data.Argonaut.JCursor where

import Prelude (class Show, class Semigroup, class Ord, class Eq, Ordering(EQ, GT, LT), (>>=), flip, (<<<), ($), bind, pure, show, (++), (<>), compare, (==), (&&), (<$>), (-), (+), (>=), (<), const)

import Data.Argonaut.Core (JNumber, Json, JObject, JArray, JString, JBoolean, JNull, foldJson, foldJsonArray, fromArray, jsonNull, foldJsonObject, fromObject, jsonEmptyArray, jsonEmptyObject, fromString, fromNumber, fromBoolean, fromNull)
import Data.Argonaut.Decode (class DecodeJson, decodeJson)
import Data.Argonaut.Encode (class EncodeJson, encodeJson)
import Data.Either (Either(..))
import Data.Foldable (foldl)
import Data.List (List(), zipWith, range, head, singleton, toList)
import Data.Maybe (Maybe(..), fromMaybe, maybe)
import Data.Monoid (class Monoid)
import Data.Tuple (Tuple(..), fst, snd)

import Data.Array as A
import Data.Int as I
import Data.Maybe.Unsafe as MU
import Data.StrMap as M

data JCursor
  = JCursorTop
  | JField String JCursor
  | JIndex Int JCursor

newtype JsonPrim
  = JsonPrim (forall a.
              (JNull -> a) ->
              (JBoolean -> a) ->
              (JNumber -> a) ->
              (JString -> a) ->
              a)

runJsonPrim :: JsonPrim -> (forall a. (JNull -> a) -> (JBoolean -> a) -> (JNumber -> a) -> (JString -> a) -> a)
runJsonPrim (JsonPrim p) = p

foreign import exactNull :: JNull

primNull :: JsonPrim
primNull = JsonPrim (\f _ _ _ -> f exactNull)

primBool :: JBoolean -> JsonPrim
primBool v = JsonPrim (\_ f _ _ -> f v)

primNum :: JNumber -> JsonPrim
primNum v = JsonPrim (\_ _ f _ -> f v)

primStr :: JString -> JsonPrim
primStr v = JsonPrim (\_ _ _ f -> f v)

primToJson :: JsonPrim -> Json
primToJson p = runJsonPrim p fromNull fromBoolean fromNumber fromString

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

cursorGet :: JCursor -> Json -> Maybe Json
cursorGet JCursorTop = Just
cursorGet (JField i c) = foldJsonObject Nothing g where
  g m = M.lookup i m >>= cursorGet c
cursorGet (JIndex i c) = foldJsonArray Nothing g where
  g a = a A.!! i >>= cursorGet c

inferEmpty :: JCursor -> Json
inferEmpty JCursorTop   = jsonNull
inferEmpty (JField _ _) = jsonEmptyObject
inferEmpty (JIndex _ _) = jsonEmptyArray

cursorSet :: JCursor -> Json -> Json -> Maybe Json
cursorSet JCursorTop v = pure <<< const v
cursorSet (JField i c) v = foldJsonObject defaultObj mergeObjs
  where
  defaultObj :: Maybe Json
  defaultObj = fromObject <<< M.singleton i <$> cursorSet c v (inferEmpty c)

  mergeObjs :: JObject -> Maybe Json
  mergeObjs m =
    fromObject <<< flip (M.insert i) m <$>
    (cursorSet c v $ fromMaybe (inferEmpty c) (M.lookup i m))
cursorSet (JIndex i c) v = foldJsonArray defaultArr mergeArrs
  where
  defaultArr :: Maybe Json
  defaultArr = fromArray <<< MU.fromJust <<<
                 flip (A.updateAt i) (A.replicate (i + 1) jsonNull) <$>
                 cursorSet c v (inferEmpty c)

  mergeArrs :: JArray -> Maybe Json
  mergeArrs a = (cursorSet c v $ fromMaybe (inferEmpty c) (a A.!! i)) >>= setArr a i

  setArr :: JArray -> Int -> Json -> Maybe Json
  setArr xs i v =
    let len = A.length xs
    in if i < 0
       then Nothing
       else if i >= len
            then setArr (xs <> (A.replicate (i - len + 1) jsonNull)) i v
            else Just <<< fromArray <<< MU.fromJust $ A.updateAt i v xs


toPrims :: Json -> List (Tuple JCursor JsonPrim)
toPrims = foldJson nullFn boolFn numFn strFn arrFn objFn
  where
  mkTop :: JsonPrim -> List (Tuple JCursor JsonPrim)
  mkTop p = singleton $ Tuple JCursorTop p

  nullFn :: JNull -> List (Tuple JCursor JsonPrim)
  nullFn _ = mkTop primNull

  boolFn :: JBoolean -> List (Tuple JCursor JsonPrim)
  boolFn b = mkTop $ primBool b

  numFn :: JNumber -> List (Tuple JCursor JsonPrim)
  numFn n = mkTop $ primNum n

  strFn :: JString -> List (Tuple JCursor JsonPrim)
  strFn s = mkTop $ primStr s

  arrFn :: JArray -> List (Tuple JCursor JsonPrim)
  arrFn arr =
    let zipped :: List (Tuple Int Json)
        zipped = zipWith Tuple (range 0 (A.length arr - 1)) (toList arr)

    in zipped >>= arrFn'

  arrFn' :: Tuple Int Json -> List (Tuple JCursor JsonPrim)
  arrFn' (Tuple i j) = toList ((\t -> Tuple (JIndex i (fst t)) (snd t))
                               <$> toPrims j)


  objFn :: JObject -> List (Tuple JCursor JsonPrim)
  objFn obj =
    let f :: Tuple String Json -> List (Tuple JCursor JsonPrim)
        f (Tuple i j) = ((\t -> Tuple (JField i (fst t)) (snd t))
                         <$> toPrims j)
    in M.toList obj >>= f


fromPrims :: List (Tuple JCursor JsonPrim) -> Maybe Json
fromPrims lst = foldl f (inferEmpty <<< fst <$> head lst) lst
  where
  f :: Maybe Json -> Tuple JCursor JsonPrim -> Maybe Json
  f j (Tuple c p) = j >>= cursorSet c (primToJson p)

instance showJCursor :: Show JCursor where
  show JCursorTop = ""
  show (JField i c) = "." <> i <> show c
  show (JIndex i c) = "[" <> show i <> "]" <> show c

instance showJsonPrim :: Show JsonPrim where
  show p = runJsonPrim p show show show show

instance eqJCursor :: Eq JCursor where
  eq JCursorTop JCursorTop = true
  eq (JField i1 c1) (JField i2 c2) = i1 == i2 && c1 == c2
  eq (JIndex i1 c1) (JIndex i2 c2) = i1 == i2 && c1 == c2
  eq _ _ = false

instance ordJCursor :: Ord JCursor where
  compare JCursorTop JCursorTop = EQ
  compare JCursorTop _ = LT
  compare _ JCursorTop = GT
  compare (JField _ _) (JIndex _ _) = LT
  compare (JIndex _ _) (JField _ _) = GT
  compare (JField i1 c1) (JField i2 c2) = case compare i1 i2 of
    EQ -> compare c1 c2
    x  -> x
  compare (JIndex i1 c1) (JIndex i2 c2) = case compare i1 i2 of
    EQ -> compare c1 c2
    x  -> x

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

fail :: forall a b. (Show a) => a -> Either String b
fail x = Left $ "Expected String or Number but found: " ++ show x

instance decodeJsonJCursor :: DecodeJson JCursor where
  decodeJson j = decodeJson j >>= loop
    where
    loop :: Array Json -> Either String JCursor
    loop arr =
      maybe (Right JCursorTop) goLoop do
        x <- A.head arr
        xs <- A.tail arr
        pure $ Tuple x xs

    goLoop :: Tuple Json (Array Json) -> Either String JCursor
    goLoop (Tuple x xs) = do
      c <- loop xs
      foldJson fail fail (goNum c) (Right <<< (flip JField c)) fail fail x

    goNum :: JCursor -> JNumber -> Either String JCursor
    goNum c num =
      maybe (Left "Not an Int") (Right <<< (flip JIndex c)) $ I.fromNumber num
