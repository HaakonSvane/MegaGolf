//
//  MGAnimation.swift
//  MegaGolf
//
//  Created by Haakon Svane on 05/04/2021.
//

import SpriteKit


enum MGAnimation {
    
    static func fadeIn(duration: TimeInterval) -> SKAction{
        return SKAction.fadeIn(withDuration: duration)
    }
    
    static func fadeOut(duration: TimeInterval) -> SKAction{
        return SKAction.fadeOut(withDuration: duration)
    }
    
    static func moveSmooth(by delta: CGVector, duration: TimeInterval) -> SKAction {
        let moveAct = SKAction.move(by: delta, duration: duration)
        moveAct.timingFunction = {time in
            return simd_smoothstep(0, 1, time)
        }
        return moveAct
    }
    
    static func moveSmoothTo(to point: CGPoint, duration: TimeInterval) -> SKAction {
        let moveAct = SKAction.move(to: point, duration: duration)
        moveAct.timingFunction = {time in
            return simd_smoothstep(0, 1, time)
        }
        return moveAct
    }
    
    static func invisible() -> SKAction {
        return fadeOut(duration: 0)
    }
    
    static func visible() -> SKAction {
        return fadeIn(duration: 0)
    }
    
    static func scaleLinear(by scale: CGFloat, duration: TimeInterval) -> SKAction {
        return SKAction.scale(by: scale, duration: duration)
    }
    
    static func scaleLinear(to scale: CGFloat, duration: TimeInterval) -> SKAction {
        return SKAction.scale(to: scale, duration: duration)
    }
    
    
    static func scaleSmooth(by scale: CGFloat, duration: TimeInterval) -> SKAction {
        let scaleAct = scaleLinear(by: scale, duration: duration)
        scaleAct.timingFunction = {time in
            return simd_smoothstep(0, 1, time)
        }
        return scaleAct
    }
    
    static func scaleSmooth(to scale: CGFloat, duration: TimeInterval) -> SKAction {
        let scaleAct = scaleLinear(to: scale, duration: duration)
        scaleAct.timingFunction = {time in
            return simd_smoothstep(0, 1, time)
        }
        return scaleAct
    }
    
}
