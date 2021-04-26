//
//  ParticleEmitterComponent.swift
//  MegaGolf
//
//  Created by Haakon Svane on 06/04/2021.
//

import GameKit

/**
    A component for adding a particle emmiter to the entity. The emitter can be started using the `emit()` method.
    
    - Requires :
        - `NodeComponent`
 
 */

class ParticleEmitterComponent : GKComponent {
    let emitterNode: SKEmitterNode
    
    init(emitterName: String){
        let em = SKEmitterNode(fileNamed: emitterName)
        guard let emitter = em else{
            fatalError("Found no emitter with name \(emitterName)")
        }
        self.emitterNode = emitter
        self.emitterNode.name = "emitter"
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didAddToEntity() {
        guard let eNode = entity?.getNode() else {
            fatalError("ParticleEmitterComponenet requires a NodeComponent. Add this first")
        }
        self.emitterNode.targetNode = eNode
    }

    
    func emit(at relPoint: CGPoint, emitTime : TimeInterval){
        guard let node = entity?.getNode() else {
            fatalError("ParticleEmitterComponenet requires a NodeComponent. Add this first")
        }
        let scFac: CGPoint
        if let sComp = entity?.component(ofType: ScaleComponent.self){
            scFac = CGPoint(x: sComp.scaleX, y: sComp.scaleY)
        }else{
            scFac = CGPoint(x: 1.0, y: 1.0)
        }
        emitterNode.position = relPoint/scFac
        emitterNode.removeFromParent()
        node.addChild(emitterNode)
        emitterNode.run(SKAction.sequence([
                                            SKAction.group([SKAction.wait(forDuration: emitTime), SKAction.fadeOut(withDuration: emitTime)]), SKAction.removeFromParent()]))
    }
}
