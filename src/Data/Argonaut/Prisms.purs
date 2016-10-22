module Data.Argonaut.Prisms where

import Data.Argonaut.Core
import Data.Lens (Prism', prism')

_Null :: Prism' Json JNull
_Null = prism' fromNull toNull

_Boolean :: Prism' Json JBoolean
_Boolean = prism' fromBoolean toBoolean

_Number :: Prism' Json JNumber
_Number = prism' fromNumber toNumber

_String :: Prism' Json JString
_String = prism' fromString toString

_Array :: Prism' Json JArray
_Array = prism' fromArray toArray

_Object :: Prism' Json JObject
_Object = prism' fromObject toObject
