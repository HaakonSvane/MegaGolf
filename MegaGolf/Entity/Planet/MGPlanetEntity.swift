//
//  MGPlanetEntity.swift
//  MegaGolf
//
//  Created by Haakon Svane on 27/03/2021.
//

/**
    Using inheritance with Entity & Component seems a little counterintuitive, but there are lots of benefits to defining a generic `MGPlanetEntity`
    that all other planet entities can inherit from since they have so many similar components.
 
 */
import GameKit


class MGPlanetEntity : GKEntity {
    init(radius: CGFloat, gravityRadiusFactor: CGFloat, angularVelocity: CGFloat, config: MGPlanetConfiguration, textureName: String){
        super.init()
        
        let nodeComp = NodeComponent()
        let spriteComp = SpriteComponent(with: textureName, addNormalMap: true)
        
        let spriteRadius = spriteComp.spriteNode.size.width/2
        let lightRComp = LightReceiverComponent()
        let rotComp = RotationComponent(omega: angularVelocity)
        let gravComp = GravityComponent(radius: spriteRadius*(1+gravityRadiusFactor))
        let scaleComp = ScaleComponent(x: radius/spriteRadius, y: radius/spriteRadius)
        let physComp = PhysicsComponent(bodyType: .circular(radius: radius-10))
        let orbComp = OrbitComponent()
        let dataComp = DataStoreComponent()
        
        physComp.respondsToGravity = false
        physComp.isDynamic = false
        physComp.categoryBitMask = 0b00001
        physComp.collisionBitMask = 0b00001
        physComp.contactBitMask = 0b00001

        physComp.kineticFriction = config.kineticFriction
        physComp.staticFriction = config.staticFriction
        physComp.restitution = config.restitution
        physComp.density = config.density
        
        gravComp.strength = 2*physComp.density*(1+2*exp(-radius/100))
        lightRComp.lightingBitMask = 0b00001
        lightRComp.shadowCastBitMask = 0b00001
        lightRComp.shadowedBitMask = 0b00001
        
        dataComp.data = ["spriteRadius":radius, "physicsRadius":radius-10]
        
        self.addComponent(nodeComp)
        self.addComponent(spriteComp)
        self.addComponent(lightRComp)
        self.addComponent(rotComp)
        self.addComponent(gravComp)
        self.addComponent(scaleComp)
        self.addComponent(physComp)
        self.addComponent(dataComp)
        self.addComponent(orbComp)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
