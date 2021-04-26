//
//  LightReceiverComponent.swift
//  MegaGolf
//
//  Created by Haakon Svane on 08/03/2021.
//

import GameKit

/**
    A component for setting the lighting behaviour of the entity.
    
    - Requires :
        - `NodeComponent`
        - `SpriteComponent`
 
 */

class LightReceiverComponent : GKComponent {
    
    
    var lightingBitMask : UInt32 {
        didSet{
            entity?.getSpriteNode()?.lightingBitMask = lightingBitMask
        }
    }
    
    var shadowedBitMask : UInt32 {
        didSet{
            entity?.getSpriteNode()?.shadowedBitMask = shadowedBitMask
        }
    }
    
    var shadowCastBitMask : UInt32 {
        didSet{
            entity?.getSpriteNode()?.shadowCastBitMask = shadowCastBitMask
        }
    }
    
    override init(){
        lightingBitMask = 0b00000
        shadowedBitMask = 0b00000
        shadowCastBitMask = 0b00000
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didAddToEntity() {
        guard let sNode = entity?.component(ofType: SpriteComponent.self) else{
            fatalError("The entity does not have a SpriteComponent attached to it. Do this before adding the LightRecieverComponent.")
        }
        sNode.spriteNode.lightingBitMask = lightingBitMask
        sNode.spriteNode.shadowedBitMask = shadowedBitMask
        sNode.spriteNode.shadowCastBitMask = shadowCastBitMask
    }
}
