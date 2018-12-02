module Data.Argonaut.Traversals where

import Data.Argonaut.Core

import Data.Argonaut.Prisms (_Array, _Object)
import Data.Lens (Traversal', IndexedTraversal', filtered, traversed)
import Data.Lens.Index (ix)
import Data.Lens.Indexed (itraversed)
import Prelude ((<<<), identity)

_JsonNull :: Traversal' Json Json
_JsonNull = identity <<< filtered isNull

_JsonBoolean :: Traversal' Json Json
_JsonBoolean = identity <<< filtered isBoolean

_JsonNumber :: Traversal' Json Json
_JsonNumber = identity <<< filtered isNumber

_JsonString :: Traversal' Json Json
_JsonString = identity <<< filtered isString

_JsonArray :: Traversal' Json Json
_JsonArray = identity <<< filtered isArray

_JsonObject :: Traversal' Json Json
_JsonObject = identity <<< filtered isObject

key :: String -> Traversal' Json Json
key i = _Object <<< ix i

nth :: Int -> Traversal' Json Json
nth i = _Array <<< ix i

values :: Traversal' Json Json
values = _Array <<< traversed

members :: IndexedTraversal' String Json Json
members = _Object <<< itraversed