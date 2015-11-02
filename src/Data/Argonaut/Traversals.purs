module Data.Argonaut.Traversals where

import Data.Argonaut.Core
import Data.Lens (TraversalP(), filtered)
import Prelude ((<<<), id)

_JsonNull :: TraversalP Json Json
_JsonNull = id <<< filtered isNull

_JsonBoolean :: TraversalP Json Json
_JsonBoolean = id <<< filtered isBoolean

_JsonNumber :: TraversalP Json Json
_JsonNumber = id <<< filtered isNumber

_JsonString :: TraversalP Json Json
_JsonString = id <<< filtered isString

_JsonArray :: TraversalP Json Json
_JsonArray = id <<< filtered isArray

_JsonObject :: TraversalP Json Json
_JsonObject = id <<< filtered isObject
