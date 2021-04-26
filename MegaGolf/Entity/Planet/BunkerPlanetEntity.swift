//
//  BunkerPlanetEntity.swift
//  MegaGolf
//
//  Created by Haakon Svane on 31/03/2021.
//

import SpriteKit

class BunkerPlanetEntity : MGPlanetEntity{
    init(radius: CGFloat, gravityRadiusFactor: CGFloat, angularVelocity: CGFloat, config: MGPlanetConfiguration){
        super.init(radius: radius, gravityRadiusFactor: gravityRadiusFactor, angularVelocity: angularVelocity, config: config, textureName: "bunkerPlanet")
        let emComp = ParticleEmitterComponent(emitterName: "bunkerPlanetEmitter")
        emComp.emitterNode.zPosition = 2
        emComp.emitterNode.setScale(1/2)
        self.addComponent(emComp)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
