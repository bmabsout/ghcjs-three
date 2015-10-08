module GHCJS.Three.Monad (
    Three,
    Object(..),
    ThreeJSRef(..)
) where

import GHCJS.Types

type Three = IO

newtype Object a = Object JSRef

class ThreeJSRef o where
    toJSRef :: o -> JSRef
    fromJSRef :: JSRef -> o

instance ThreeJSRef (Object a) where
    toJSRef (Object r) = r
    fromJSRef = Object
