//
//  CGPointExtension.swift
//  MegaGolf
//
//  Created by Haakon Svane on 27/03/2021.
//

import SpriteKit

extension CGPoint {
    
    /**
        Given an angle in radians, creates a point of length 1.0 from the origin and returns the result as a new `CGPoint`. An angle of 0 is assumed to point to the right.
    */
    init(angle: CGFloat) {
        self.init(x: cos(angle), y: sin(angle))
    }
    
    /**
        Initializes a `CGPoint` from a `CGVector`
     */
    
    init(vector: CGVector) {
        self.init(x: vector.dx, y: vector.dy)
    }
    
    /**
        Adds two `CGPoint` instances elementwise.
     */
    static func + (left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x + right.x, y: left.y + right.y)
    }
    
    /**
        Subtracts two `CGPoint` instances elementwise.
     */
    static func - (left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x - right.x, y: left.y - right.y)
    }
    
    /**
        Multiplies two `CGPoint` instances elementwise.
     */
    static func * (left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x * right.x, y: left.y * right.y)
    }
    
    /**
        Scalar multiplication between a `CGPoint` and a `CGFloat`.
     */
    static func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
        return CGPoint(x: point.x * scalar, y: point.y * scalar)
    }
    
    /**
        Divides two `CGPoint` instances elementwise.
     */
    static func / (left: CGPoint, right: CGPoint) -> CGPoint {
        return CGPoint(x: left.x / right.x, y: left.y / right.y)
    }
    
    /**
        Scalar division between a `CGPoint` and a `CGFloat`.
     */
    static func / (point: CGPoint, scalar: CGFloat) -> CGPoint {
        return CGPoint(x: point.x / scalar, y: point.y / scalar)
    }
    
    /**
        Increments a `CGPoint` by another elementwise.
     */
    static func += (left: inout CGPoint, right: CGPoint) {
        left = left + right
    }
    
    /**
        Decrements a `CGPoint` by another elementwise.
     */
    static func -= (left: inout CGPoint, right: CGPoint) {
        left = left - right
    }
    
    /**
        Calculates the length between the `CGPoint` and the origin.
        - Returns: Length of the point to the origin,
     */
    func length() -> CGFloat {
        return sqrt(x*x + y*y)
    }
    
    /**
        Normalizes the point such that its length is equal to 1.
        - Returns: Length of the point to the origin,
     */
    func normalized() -> CGPoint {
        let len = length()
        return len > 0 ? self / len : CGPoint.zero
    }
    
    /**
        Calculates the distance between this `CGPoint` and another.
        - Parameters:
            - point: Other `CGPoint`.
        - Returns: Distance between the two points,
     */
    func distanceTo(_ point: CGPoint) -> CGFloat {
        return (self - point).length()
    }
    
    /**
        The angle of the line drawn from the origin to this point in radians. Ranges from -π to π with 0 on the positive x-axis.
     */
    var angle: CGFloat {
        return atan2(y, x)
    }
    
    /**
        Converts the `CGPoint` to a `CGVector` by assuming that the origin of the vector is at the point (0, 0)
        - Returns: A `CGVector` corresponding to the `CGPoint`
     */
    func toCGVector() -> CGVector {
        return CGVector(dx: self.x, dy: self.y)
    }
}
