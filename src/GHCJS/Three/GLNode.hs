{-# LANGUAGE JavaScriptFFI, GeneralizedNewtypeDeriving #-}
module GHCJS.Three.GLNode (
    GLNode(..), IsGLNode(..), add, remove
) where

import GHCJS.Types

import GHCJS.Three.Monad

foreign import javascript unsafe "($2).add($1)"
    thr_add :: JSVal -> JSVal -> Three ()

foreign import javascript unsafe "($2).remove($1)"
    thr_remove :: JSVal -> JSVal -> Three ()

newtype GLNode = GLNode BaseObject
    deriving (ThreeJSVal)

class ThreeJSVal n => IsGLNode n where
    toNode :: n -> GLNode
    toNode = fromJSVal . toJSVal
    fromNode :: GLNode -> n
    fromNode = fromJSVal . toJSVal

-- | add child object c to parent p
add :: (IsGLNode c, IsGLNode p) => c -> p -> Three ()
add c p = thr_add (toJSVal c) (toJSVal p)

-- | remove child object c from parent p
remove :: (IsGLNode c, IsGLNode p) => c -> p -> Three ()
remove c p = thr_remove (toJSVal c) (toJSVal p)