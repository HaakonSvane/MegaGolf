//
//  GameObjectFactory.swift
//  MegaGolf
//
//  Created by Haakon Svane on 24/03/2021.
//

import SpriteKit

struct MGPlanetConfiguration{
    let density: CGFloat
    let kineticFriction: CGFloat
    let staticFriction: CGFloat
    let restitution: CGFloat
}

class GameObjectFactory {
    static let starAtlas : SKTextureAtlas = SKTextureAtlas(named: "Stars")
    static let planetConfiguration : MGPlanetPropertiesParser = MGPlanetPropertiesParser()
    
    static func makeGolfBall(type: MGBallType) -> GolfBallEntity {
        let ball = GolfBallEntity(type: type)
        ball.getNode()!.zPosition = 2
        return ball
    }
    
    static func makeGhostGolfBall(type: MGBallType, ballName: String) -> GhostGolfBallEntity {
        let ball = GhostGolfBallEntity(type: type, ballName: ballName)
        ball.getNode()!.zPosition = 1
        return ball
    }
    
    static func makeFieldPlanet(radius: CGFloat, gravityRadiusFactor: CGFloat, angularVelocity: CGFloat) -> FieldPlanetEntity {
        return FieldPlanetEntity(radius: radius,
                                 gravityRadiusFactor: gravityRadiusFactor,
                                 angularVelocity: angularVelocity,
                                 config: GameObjectFactory.planetConfiguration.getPlanetConfiguration(planetEntityName: "FieldPlanet"))
    }
    
    static func makeBunkerPlanet(radius: CGFloat, gravityRadiusFactor: CGFloat, angularVelocity: CGFloat) -> BunkerPlanetEntity {
        return BunkerPlanetEntity(radius: radius,
                                 gravityRadiusFactor: gravityRadiusFactor,
                                 angularVelocity: angularVelocity,
                                 config: GameObjectFactory.planetConfiguration.getPlanetConfiguration(planetEntityName: "BunkerPlanet"))
    }
    
    static func makeWaterPlanet(radius: CGFloat, gravityRadiusFactor: CGFloat, angularVelocity: CGFloat) -> WaterPlanetEntity {
        return WaterPlanetEntity(radius: radius,
                                 gravityRadiusFactor: gravityRadiusFactor,
                                 angularVelocity: angularVelocity,
                                 config: GameObjectFactory.planetConfiguration.getPlanetConfiguration(planetEntityName: "WaterPlanet"))
    }
    
    static func makeBlackHole(radius: CGFloat, gravityRadiusFactor: CGFloat) -> BlackHoleEntity {
        return BlackHoleEntity(radius: radius,
                               gravityRadiusFactor: gravityRadiusFactor,
                               config: GameObjectFactory.planetConfiguration.getPlanetConfiguration(planetEntityName: "BlackHole"))
    }
    
    static func makeRedStar(radius: CGFloat, gravityRadiusFactor: CGFloat, angularVelocity: CGFloat) -> RedStarEntity {
        return RedStarEntity(atlas: GameObjectFactory.starAtlas,
                             radius: radius,
                             gravityRadiusFactor: gravityRadiusFactor,
                             angularVelocity: angularVelocity,
                             config: GameObjectFactory.planetConfiguration.getPlanetConfiguration(planetEntityName: "RedStar"))
    }
    
    static func makeYellowStar(radius: CGFloat, gravityRadiusFactor: CGFloat, angularVelocity: CGFloat) -> YellowStarEntity {
        return YellowStarEntity(atlas: GameObjectFactory.starAtlas,
                             radius: radius,
                             gravityRadiusFactor: gravityRadiusFactor,
                             angularVelocity: angularVelocity,
                             config: GameObjectFactory.planetConfiguration.getPlanetConfiguration(planetEntityName: "YellowStar"))
    }
    
    static func makeMoonPlanet(radius: CGFloat, gravityRadiusFactor: CGFloat, angularVelocity: CGFloat) -> MoonPlanetEntity{
        return MoonPlanetEntity(radius: radius,
                                gravityRadiusFactor: gravityRadiusFactor,
                                angularVelocity: angularVelocity,
                                config: GameObjectFactory.planetConfiguration.getPlanetConfiguration(planetEntityName: "MoonPlanet"))
    }
    
    static func makeSceneLight() -> MGLightEntity{
        let light = MGLightEntity(lightColor: UIColor(hex: 0xFEFEAA, a: 0x60),
                                 shadowColor: UIColor(hex: 0x000000, a: 0x00),
                                 ambientColor: UIColor(hex: 0x1A1A1F, a: 0xFF),
                                 categoryBitMask: 0b00011,
                                 falloff: 0.2)
        light.component(ofType: LightEmitterComponent.self)?.lights.addLight(name: "ballLight")
        let node = (light.component(ofType: LightEmitterComponent.self)?.lights.childNode(withName: "ballLight") as! SKLightNode)
        node.categoryBitMask = 0b00010
        node.lightColor = UIColor(hex: 0xFEFEAA, a: 0x30)
        node.shadowColor = UIColor(hex: 0x000000, a: 0x20)
        node.ambientColor = UIColor(hex: 0xC0C0CF, a: 0xFF)
        return light
    }
}
