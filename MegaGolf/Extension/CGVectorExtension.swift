//
//  CGVectorExtension.swift
//  MegaGolf
//
//  Created by Haakon Svane on 29/03/2021.
//

import SpriteKit


extension CGVector {
    
    /**
     Given an angle in radians, creates a vector of length 1.0 and returns the result as a new CGVector. An angle of 0 is assumed to point to the right.
    */
    init(angle: CGFloat) {
        self.init(dx: cos(angle), dy: sin(angle))
    }
    
    /**
        Adds two `CGVector` instances elementwise.
     */
    static func + (left: CGVector, right: CGVector) -> CGVector {
        return CGVector(dx: left.dx + right.dx, dy: left.dy + right.dy)
    }
    
    /**
        Subtracts two `CGVector` instances elementwise.
     */
    static func - (left: CGVector, right: CGVector) -> CGVector {
        return CGVector(dx: left.dx - right.dx, dy: left.dy - right.dy)
    }
    
    /**
        Multiplies two `CGVector` instances elementwise.
     */
    static func * (left: CGVector, right: CGVector) -> CGVector {
        return CGVector(dx: left.dx * right.dx, dy: left.dy * right.dy)
    }
    
    /**
        Scalar multiplication between a `CGVector` and a `CGFloat`.
     */
    static func * (vec: CGVector, scalar: CGFloat) -> CGVector {
        return CGVector(dx: vec.dx * scalar, dy: vec.dy * scalar)
    }
    
    /**
        Divides two `CGVector` instances elementwise.
     */
    static func / (left: CGVector, right: CGVector) -> CGVector {
        return CGVector(dx: left.dx / right.dx, dy: left.dy / right.dy)
    }
    
    /**
        Scalar division between a `CGVector` and a `CGFloat`.
     */
    static func / (vec: CGVector, scalar: CGFloat) -> CGVector {
        return CGVector(dx: vec.dx / scalar, dy: vec.dy / scalar)
    }
    
    /**
        Increments a `CGVector` by another elementwise.
     */
    static func += (left: inout CGVector, right: CGVector) {
        left = left + right
    }
    
    /**
        Decrements a `CGVector` by another elementwise.
     */
    static func -= (left: inout CGVector, right: CGVector) {
        left = left - right
    }
    
    /**
        Calculates the length of the `CGVector`.
        - Returns: Length of the vector (L2-Norm).
     */
    func length() -> CGFloat {
        return sqrt(dx*dx + dy*dy)
    }
    
    /**
        Normalizes the vector such that its length is equal to 1 and returns a new vector.
        - Returns: Normalized `CGVector`.
     */
    func normalized() -> CGVector {
        let len = length()
        return len > 0 ? self / len : CGVector.zero
    }
    
    /**
        Normalizes the vector such that its length is equal to 1.
        - Returns: Normalized `CGVector`.
     */
    mutating func normalize() -> CGVector {
        self = normalized()
        return self
    }
    
    /**
        Calculates the distance between this `CGVector` and another.
        - Parameters:
            - vec: Other `CGVector`.
        - Returns: Distance between the two vectors,
     */
    func distanceTo(_ vec: CGVector) -> CGFloat {
        return (self - vec).length()
    }
    
    /**
        The angle of the `CGvector` in radians. Ranges from -π to π with 0 on the positive x-axis.
     */
    var angle: CGFloat {
        return atan2(dy, dx)
    }
    /**
        Calculates this `CGVector` projected onto another.
        - Parameters:
            - onto: The vector to project onto
        - Returns: The projection of this vector onto another.
     */
    func vectorProjected(onto: CGVector) -> CGVector{
        let angleBetween = (self-onto).angle
        return onto.normalized()*self.length()*cos(angleBetween)
    }
    
    func rotated(by angle: CGFloat) -> CGVector {
        return CGVector(dx: cos(angle)*self.dx - sin(angle)*self.dy, dy: sin(angle)*self.dx + cos(angle)*self.dy)
    }
    
    /**
        Calculates the z component of a cross product between two vectors by setting the z-components of each to zero.
        - Parameters:
            - other: The left side vector of the cross product.
        - Returns: A scalar value of the z-component of the cross product between the two vectors.
     */
    
    func zCrossProduct(with other: CGVector) -> CGFloat {
        return self.dx*other.dy - self.dy*other.dx
    }
}
