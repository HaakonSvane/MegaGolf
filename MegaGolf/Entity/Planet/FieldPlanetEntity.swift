//
//  FieldPlanet.swift
//  MegaGolf
//
//  Created by Haakon Svane on 12/03/2021.
//

import GameKit

class FieldPlanetEntity : MGPlanetEntity{
    init(radius: CGFloat, gravityRadiusFactor: CGFloat, angularVelocity: CGFloat, config: MGPlanetConfiguration){
        super.init(radius: radius, gravityRadiusFactor: gravityRadiusFactor, angularVelocity: angularVelocity, config: config, textureName: "fieldPlanet")
        let emComp = ParticleEmitterComponent(emitterName: "fieldPlanetEmitter")
        emComp.emitterNode.zPosition = 2
        emComp.emitterNode.setScale(1/2)
        self.addComponent(emComp)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
