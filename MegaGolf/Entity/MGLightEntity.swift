//
//  MGLightEntity.swift
//  MegaGolf
//
//  Created by Haakon Svane on 17/03/2021.
//

import GameKit

class MGLightEntity : GKEntity {
    init(lightColor: UIColor, shadowColor: UIColor, ambientColor: UIColor, categoryBitMask: UInt32, falloff: CGFloat){
        super.init()
        
        let nodeComp = NodeComponent()
        let lightComp = LightEmitterComponent(numLights: 1)
        
        lightComp.lights.falloff = falloff
        lightComp.lights.categoryBitMask = categoryBitMask
        lightComp.lights.lightColor = lightColor
        lightComp.lights.shadowColor = shadowColor
        lightComp.lights.ambientColor = ambientColor
        
        self.addComponent(nodeComp)
        self.addComponent(lightComp)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
