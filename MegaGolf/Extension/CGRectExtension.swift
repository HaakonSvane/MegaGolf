//
//  CGRectExtension.swift
//  MegaGolf
//
//  Created by Haakon Svane on 30/03/2021.
//

import SpriteKit

extension CGRect {
    
    /**
        Given a `CGPoint`, a displacement vector is returned such that it points to the center of the rectangle and has a length equal to the distance between the `CGPoint` and the point at the rectangle that intersects the vector.
     
        - Parameters:
            - pos: Position to be evaluated.
     
        - Returns:  A `CGVector`pointing from the center of the rectangle to the provided point. If the point lies within the rectangle, a zero vector is returned.
     */
    func displacementVector(point: CGPoint) -> CGVector {
        if self.contains(point) {return .zero}
        let xRad = self.width/2
        let yRad = self.height/2
        
        let cPoint = CGPoint(x: self.origin.x + xRad , y: self.origin.y + yRad)
        let relPoint = point-cPoint
        let angle = relPoint.angle
        
        let dVec = CGVector(angle: angle)
        
        let y = xRad*tan(angle)
        
        let pointOnRect: CGPoint
        if abs(y) <= yRad {
            pointOnRect = CGPoint(x: xRad, y: y)
        }else{
            let x = yRad/tan(angle)
            pointOnRect = CGPoint(x: x, y: yRad)
        }
        
        return dVec*(point.distanceTo(cPoint)-pointOnRect.length())
    }
}
