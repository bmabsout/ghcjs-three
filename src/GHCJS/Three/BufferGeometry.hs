{-# LANGUAGE JavaScriptFFI, GeneralizedNewtypeDeriving #-}
module GHCJS.Three.BufferGeometry where

import GHCJS.Types
import JavaScript.Array
import JavaScript.Array.Internal

import GHCJS.Three.Monad
import GHCJS.Three.Geometry
import GHCJS.Three.Disposable

newtype BufferAttribute = BufferAttribute {
    bufferAttributeObject :: BaseObject
    } deriving ThreeJSVal

foreign import javascript unsafe "($1)['array']"
    thr_array :: JSVal -> Three JSVal

array :: BufferAttribute -> Three JSArray
array = fmap SomeJSArray . thr_array . toJSVal

foreign import javascript unsafe "($1)['count']"
    thr_count :: JSVal -> Three Int

count :: BufferAttribute -> Three Int
count = thr_count . toJSVal


newtype BufferGeometry = BufferGeometry {
    bufferGeometryObject :: BaseObject
    } deriving ThreeJSVal

instance HasBounding BufferGeometry
instance Disposable BufferGeometry

foreign import javascript unsafe "new window['THREE']['BufferGeometry']()"
    thr_mkBufferGeometry :: Three JSVal

mkBufferGeometry :: Three BufferGeometry
mkBufferGeometry = fromJSVal <$> thr_mkBufferGeometry

maybeAttribute :: JSVal -> Maybe BufferAttribute
maybeAttribute v = if isNull v
                   then Nothing
                   else Just (fromJSVal v)

foreign import javascript unsafe "($2)['getAttribute']($1)"
    thr_getAttribute :: JSString -> JSVal -> Three JSVal

getAttribute :: JSString -> BufferGeometry -> Three (Maybe BufferAttribute)
getAttribute n g = maybeAttribute <$> thr_getAttribute n (toJSVal g)

foreign import javascript unsafe "($1)['getIndex']()"
    thr_getIndex :: JSVal -> Three JSVal

getIndex :: BufferGeometry -> Three (Maybe BufferAttribute)
getIndex = fmap maybeAttribute . thr_getIndex . toJSVal


foreign import javascript unsafe "($2)['fromBufferGeometry']($1)"
    thr_fromBufferGeometry :: JSVal -> JSVal -> Three ()

fromBufferGeometry :: BufferGeometry -> Geometry -> Three ()
fromBufferGeometry bg g = thr_fromBufferGeometry (toJSVal bg) (toJSVal g)
