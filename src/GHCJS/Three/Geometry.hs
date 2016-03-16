{-# LANGUAGE JavaScriptFFI, GeneralizedNewtypeDeriving #-}
module GHCJS.Three.Geometry (
    Geometry(..), mkGeometry,
    IsGeometry(..),
    BoxGeometry(..), mkBoxGeometry,
    CircleGeometry(..), mkCircleGeometry
    ) where

import GHCJS.Types
import qualified GHCJS.Marshal as Marshal

import Data.Maybe (fromMaybe)

import GHCJS.Three.Monad
import GHCJS.Three.Vector hiding (getObject)
import GHCJS.Three.Disposable

newtype Geometry = Geometry {
    geometryObject :: BaseObject
} deriving (ThreeJSVal)

foreign import javascript unsafe "new window.THREE.Geometry()"
    thr_mkGeometry :: Three JSVal

mkGeometry :: Three Geometry
mkGeometry = fromJSVal <$> thr_mkGeometry

-- | get vertices
foreign import javascript safe "($1).vertices"
    thr_vertices :: JSVal -> JSVal

-- | set vertices
foreign import javascript unsafe "($2).vertices = $1"
    thr_setVectices :: JSVal -> JSVal -> Three ()

foreign import javascript unsafe "($2).verticesNeedUpdate = $1 === 1"
    thr_setVerticesNeedUpdate :: Int -> JSVal -> Three ()

-- use Marshal.fromJSVal to convert JSVal -> IO (Maybe [JSVal])
-- and Marshal.toJSVal to convert [JSVal] -> IO JSVal
class ThreeJSVal g => IsGeometry g where
    vertices :: g -> Three [TVector]
    vertices g = (map (toTVector . fromJSVal) . fromMaybe []) <$> (Marshal.fromJSVal $ thr_vertices $ toJSVal g)

    setVertices :: [TVector] -> g -> Three ()
    setVertices vs g = mapM mkVector vs >>= Marshal.toJSVal . map toJSVal >>= flip thr_setVectices (toJSVal g) >> thr_setVerticesNeedUpdate 1 (toJSVal g)

instance IsGeometry Geometry
instance Disposable Geometry

-- | BoxGeometry
newtype BoxGeometry = BoxGeometry {
    getGeometry :: Geometry
} deriving (ThreeJSVal, IsGeometry, Disposable)

foreign import javascript unsafe "new window.THREE.BoxGeometry($1, $2, $3)"
    thr_mkBoxGeometry :: Double -> Double -> Double -> Three JSVal

-- | create a new BoxGeometry
mkBoxGeometry :: Double -> Double -> Double -> Three BoxGeometry
mkBoxGeometry w h d = fromJSVal <$> thr_mkBoxGeometry w h d

-- | CircleGeometry
newtype CircleGeometry = CircleGeometry {
    getCircleGeometry :: Geometry
} deriving (ThreeJSVal, IsGeometry, Disposable)

foreign import javascript unsafe "new window.THREE.CircleGeometry($1, $2)"
    thr_mkCircleGeometry :: Double -> Int -> Three JSVal

-- | create a new CircleGeometry
mkCircleGeometry :: Double -> Int -> Three CircleGeometry
mkCircleGeometry radius segments = fromJSVal <$> thr_mkCircleGeometry radius segments
