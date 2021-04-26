//
//  LevelDesignFactory.swift
//  MegaGolf
//
//  Created by Haakon Svane on 07/04/2021.
//

import GameKit


class LevelDesignFactory {
    
    static func fieldAndMoon() -> LevelEntity {
        let lvlEnt = LevelEntity()
        let planet = GameObjectFactory.makeFieldPlanet(radius: 110, gravityRadiusFactor: 1, angularVelocity: 0.1)
        let moon = GameObjectFactory.makeMoonPlanet(radius: 40, gravityRadiusFactor: 1, angularVelocity: -0.07)
        
        planet.component(ofType: GravityComponent.self)?.showField = false
        moon.component(ofType: GravityComponent.self)?.showField = false
        
        moon.getNode()?.position.x = 180
        moon.component(ofType: OrbitComponent.self)?.orbitAround(entity: planet, overrideSpeed: 50)
        moon.component(ofType: OrbitComponent.self)?.showingOrbitLine = true
        
        lvlEnt.getNode()?.addChild(planet)
        lvlEnt.getNode()?.addChild(moon)
        return lvlEnt
    }
    
    static func bunkerAndTwoMoons() -> LevelEntity {
        let lvlEnt = LevelEntity()
        let planet = GameObjectFactory.makeBunkerPlanet(radius: 70, gravityRadiusFactor: 1, angularVelocity: 0.4)
        let moon1 = GameObjectFactory.makeMoonPlanet(radius: 30, gravityRadiusFactor: 1, angularVelocity: -0.1)
        let moon2 = GameObjectFactory.makeMoonPlanet(radius: 45, gravityRadiusFactor: 1, angularVelocity: 0.3)
        
        planet.component(ofType: GravityComponent.self)?.showField = false
        moon1.component(ofType: GravityComponent.self)?.showField = false
        moon2.component(ofType: GravityComponent.self)?.showField = false
        
        moon1.getNode()?.position.x = 120
        moon1.component(ofType: OrbitComponent.self)?.orbitAround(entity: planet, overrideSpeed: 60)
        moon1.component(ofType: OrbitComponent.self)?.showingOrbitLine = true
        
        moon2.getNode()?.position = CGPoint(angle: 5/4*CGFloat.pi)*210
        moon2.component(ofType: OrbitComponent.self)?.orbitAround(entity: planet, overrideSpeed: 50)
        moon2.component(ofType: OrbitComponent.self)?.showingOrbitLine = true
        
        lvlEnt.getNode()?.addChild(planet)
        lvlEnt.getNode()?.addChild(moon1)
        lvlEnt.getNode()?.addChild(moon2)
        return lvlEnt
    }
    
    static func waterAndField() -> LevelEntity {
        let lvlEnt = LevelEntity()
        let wPlanet = GameObjectFactory.makeWaterPlanet(radius: 70, gravityRadiusFactor: 1, angularVelocity: 0.5)
        let fPlanet = GameObjectFactory.makeFieldPlanet(radius: 80, gravityRadiusFactor: 1, angularVelocity: -0.2)
        
        wPlanet.component(ofType: GravityComponent.self)?.showField = false
        fPlanet.component(ofType: GravityComponent.self)?.showField = false
        
        wPlanet.getNode()?.position.x = 100
        wPlanet.component(ofType: OrbitComponent.self)?.orbitAround(point: .zero, overrideSpeed: 80)
        wPlanet.component(ofType: OrbitComponent.self)?.showingOrbitLine = true
        
        fPlanet.getNode()?.position.x = -100
        fPlanet.component(ofType: OrbitComponent.self)?.orbitAround(point: .zero, overrideSpeed: 80)
        fPlanet.component(ofType: OrbitComponent.self)?.showingOrbitLine = false
        
        lvlEnt.getNode()?.addChild(wPlanet)
        lvlEnt.getNode()?.addChild(fPlanet)
        return lvlEnt
    }
}
