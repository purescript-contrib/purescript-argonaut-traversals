## Module Data.Argonaut.JCursor

#### `JCursor`

``` purescript
data JCursor
  = JCursorTop
  | JField String JCursor
  | JIndex Int JCursor
```

##### Instances
``` purescript
instance showJCursor :: Show JCursor
instance eqJCursor :: Eq JCursor
instance ordJCursor :: Ord JCursor
instance semigroupJCursor :: Semigroup JCursor
instance monoidJCursor :: Monoid JCursor
instance encodeJsonJCursor :: EncodeJson JCursor
instance decodeJsonJCursor :: DecodeJson JCursor
```

#### `JsonPrim`

``` purescript
newtype JsonPrim
  = JsonPrim (forall a. (JNull -> a) -> (JBoolean -> a) -> (JNumber -> a) -> (JString -> a) -> a)
```

##### Instances
``` purescript
instance showJsonPrim :: Show JsonPrim
```

#### `runJsonPrim`

``` purescript
runJsonPrim :: JsonPrim -> (forall a. (JNull -> a) -> (JBoolean -> a) -> (JNumber -> a) -> (JString -> a) -> a)
```

#### `exactNull`

``` purescript
exactNull :: JNull
```

#### `primNull`

``` purescript
primNull :: JsonPrim
```

#### `primBool`

``` purescript
primBool :: JBoolean -> JsonPrim
```

#### `primNum`

``` purescript
primNum :: JNumber -> JsonPrim
```

#### `primStr`

``` purescript
primStr :: JString -> JsonPrim
```

#### `primToJson`

``` purescript
primToJson :: JsonPrim -> Json
```

#### `insideOut`

``` purescript
insideOut :: JCursor -> JCursor
```

#### `downField`

``` purescript
downField :: String -> JCursor -> JCursor
```

#### `downIndex`

``` purescript
downIndex :: Int -> JCursor -> JCursor
```

#### `cursorGet`

``` purescript
cursorGet :: JCursor -> Json -> Maybe Json
```

#### `inferEmpty`

``` purescript
inferEmpty :: JCursor -> Json
```

#### `cursorSet`

``` purescript
cursorSet :: JCursor -> Json -> Json -> Maybe Json
```

#### `toPrims`

``` purescript
toPrims :: Json -> List (Tuple JCursor JsonPrim)
```

#### `fromPrims`

``` purescript
fromPrims :: List (Tuple JCursor JsonPrim) -> Maybe Json
```

#### `fail`

``` purescript
fail :: forall a b. (Show a) => a -> Either String b
```


