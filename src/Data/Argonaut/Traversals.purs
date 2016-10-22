module Data.Argonaut.Traversals where

import Prelude ((<<<), id)
import Data.Argonaut.Core
import Data.Lens (Traversal', filtered)

_JsonNull :: Traversal' Json Json
_JsonNull = id <<< filtered isNull

_JsonBoolean :: Traversal' Json Json
_JsonBoolean = id <<< filtered isBoolean

_JsonNumber :: Traversal' Json Json
_JsonNumber = id <<< filtered isNumber

_JsonString :: Traversal' Json Json
_JsonString = id <<< filtered isString

_JsonArray :: Traversal' Json Json
_JsonArray = id <<< filtered isArray

_JsonObject :: Traversal' Json Json
_JsonObject = id <<< filtered isObject
