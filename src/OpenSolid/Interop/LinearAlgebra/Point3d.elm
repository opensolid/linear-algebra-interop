module OpenSolid.Interop.LinearAlgebra.Point3d exposing (fromVec3, toVec3, toVec4, transformBy)

{-| Conversion and transformation functions for `Point3d`.

@docs toVec3, toVec4, fromVec3, transformBy

-}

import Math.Matrix4 exposing (Mat4)
import Math.Vector3 exposing (Vec3)
import Math.Vector4 exposing (Vec4)
import OpenSolid.Geometry.Types exposing (..)
import OpenSolid.Point3d as Point3d


{-| Convert a `Point3d` to a `Vec3`.

    Point3d.toVec3 (Point3d ( 2, 1, 3 ))
    --> Vector3.vec3 2 1 3

-}
toVec3 : Point3d -> Vec3
toVec3 (Point3d coordinates) =
    Math.Vector3.fromTuple coordinates


{-| Convert a `Point3d` to a `Vec4`. The resulting `Vec4` will have a W
component of 1 so that it [is affected by translation](http://www.opengl-tutorial.org/beginners-tutorials/tutorial-3-matrices/)
when performing matrix transformations.

    Point3d.toVec4 (Point3d ( 2, 1, 3 ))
    --> vec4 2 1 3 1

-}
toVec4 : Point3d -> Vec4
toVec4 (Point3d ( x, y, z )) =
    Math.Vector4.vec4 x y z 1


{-| Convert a `Vec3` to a `Point3d`.

    Point3d.fromVec3 (vec3 2 1 3)
    --> Point3d ( 2, 1, 3 )

-}
fromVec3 : Vec3 -> Point3d
fromVec3 vec =
    Point3d (Math.Vector3.toTuple vec)


{-| Transform a `Point3d` by a `Mat4`;

    Point3d.transformBy matrix point

is equivalent to

    Point3d.fromVec3 (Matrix4.transform matrix (Point3d.toVec3 point))

For example:

    point =
        Point3d ( 2, 1, 3 )

    matrix =
        Matrix4.makeTranslate3 3 4 5

    Point3d.transformBy matrix point
    --> Point3d ( 5, 5, 8 )

-}
transformBy : Mat4 -> Point3d -> Point3d
transformBy matrix point =
    let
        { m11, m12, m13, m14, m21, m22, m23, m24, m31, m32, m33, m34, m41, m42, m43, m44 } =
            Math.Matrix4.toRecord matrix

        ( x, y, z ) =
            Point3d.coordinates point
    in
    Point3d
        ( m11 * x + m12 * y + m13 * z + m14
        , m21 * x + m22 * y + m23 * z + m24
        , m31 * x + m32 * y + m33 * z + m34
        )