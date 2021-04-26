//
//  MoonPlanetEntity.swift
//  MegaGolf
//
//  Created by Haakon Svane on 01/04/2021.
//

import GameKit

class MoonPlanetEntity : MGPlanetEntity {
    init(radius: CGFloat, gravityRadiusFactor: CGFloat, angularVelocity: CGFloat, config: MGPlanetConfiguration){
        super.init(radius: radius, gravityRadiusFactor: gravityRadiusFactor, angularVelocity: angularVelocity, config: config, textureName: "moonPlanet1")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
