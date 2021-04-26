//
//  LightEmitterComponent.swift
//  MegaGolf
//
//  Created by Haakon Svane on 08/03/2021.
//

import GameKit

/**
    A component for adding a light container  entity. The container can hold multiple lights.
    
    - Requires :
        - `NodeComponent`
 
 */
class LightEmitterComponent : GKComponent {
    
    let lights : SKLightNodeContainer
    
    init(numLights : Int = 1){
        lights = SKLightNodeContainer()
        for _ in 1...numLights{ lights.addLight()}
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didAddToEntity() {
        guard let eNode = entity?.getNode() else{
            fatalError("The entity does not have a NodeComponent attached to it. Add this before adding a LightEmitterComponent")
        }
        eNode.addChild(lights)
    }
    
}
