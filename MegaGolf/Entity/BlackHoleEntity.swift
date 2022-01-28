//
//  BlackHoleEntity.swift
//  MegaGolf
//
//  Created by Haakon Svane on 30/03/2021.
//

import GameKit

class BlackHoleEntity : GKEntity {
    
    init(radius: CGFloat, gravityRadiusFactor: CGFloat, config: MGPlanetConfiguration){
        super.init()
        
        let nodeComp = NodeComponent()
        let spriteComp = SpriteComponent(textureName: "blackHole")
        
        let spriteRadius = spriteComp.spriteNode.size.width/2
        
        let physComp = PhysicsComponent(bodyType: .circular(radius: spriteRadius*(1-30/radius)))
        let lightEComp = LightEmitterComponent()
        let gravComp = GravityComponent(radius: spriteRadius*(1+gravityRadiusFactor))
        let scaleComp = ScaleComponent(x: radius/spriteRadius, y: radius/spriteRadius)
        
        physComp.respondsToGravity = false
        physComp.isDynamic = false
        physComp.categoryBitMask = 0b00000
        physComp.collisionBitMask = 0b00000
        physComp.contactBitMask = 0b00001

        physComp.kineticFriction = config.kineticFriction
        physComp.staticFriction = config.staticFriction
        physComp.restitution = config.restitution
        physComp.density = config.density
        
        gravComp.strength = 2*physComp.density*(1+2*exp(-radius/100))
        gravComp.fieldColor = GLOBALCOLOR.GRAVITYFIELDBH ?? GLOBALCOLOR.DEFAULT

        lightEComp.lights.categoryBitMask = 0b00001
        lightEComp.lights.falloff = 0.4
        lightEComp.lights.lightColor = UIColor(hex: 0xE26313, a: 0x10)
        lightEComp.lights.ambientColor = UIColor(hex: 0x101010, a: 0xFF)
        lightEComp.lights.shadowColor = UIColor(hex: 0x000000, a: 0x10)
        
        self.addComponent(nodeComp)
        self.addComponent(spriteComp)
        self.addComponent(physComp)
        self.addComponent(lightEComp)
        self.addComponent(gravComp)
        self.addComponent(scaleComp)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
