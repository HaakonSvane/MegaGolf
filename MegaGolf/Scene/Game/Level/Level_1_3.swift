//
//  Level_1_3.swift
//  MegaGolf
//
//  Created by Haakon Svane on 24/04/2021.
//

import GameKit


class Level_1_3 : MGGameScene, MGLevelSceneProtocol{
    required init(viewSize: CGSize, onlineMatch: GKMatch?) {
        let bounds = CGRect(x: -800, y: -500, width: 2700, height: 1000)
        let start = CGPoint(x: -150, y: 0)
        let end = CGPoint(x: 1500, y: 250)
        super.init(viewSize: viewSize,
                   gameBounds: bounds,
                   playerStartPos: start,
                   goalPos: end,
                   goalRadius: 50,
                   levelPar: 4,
                   onlineMatch: onlineMatch)
        
        
        let f1 = GameObjectFactory.makeFieldPlanet(radius: 180, gravityRadiusFactor: 0.5, angularVelocity: 0.35)
        f1.getNode()?.position = CGPoint(x: 380, y: 0)
        
        let w1Rad : CGFloat = 370
        let w1NumPlanets = 7
        for d in 0..<w1NumPlanets {
            
            let wp = GameObjectFactory.makeWaterPlanet(radius: 60, gravityRadiusFactor: 0.3, angularVelocity: 0)
            wp.getNode()?.position = f1.getNode()!.position + CGPoint(angle: 2*CGFloat.pi*CGFloat(d)/CGFloat(w1NumPlanets))*w1Rad
            wp.component(ofType: OrbitComponent.self)?.orbitAround(entity: f1, overrideSpeed: 50)
            if d == 0 {
                wp.component(ofType: OrbitComponent.self)?.showingOrbitLine = true
            }
            
            entities.append(wp)
            self.addChild(wp.getNode()!, isGUI: false)
        }
        
        let f2 = GameObjectFactory.makeFieldPlanet(radius: 80, gravityRadiusFactor: 0.5, angularVelocity: 0.2)
        f2.getNode()?.position = CGPoint(x: 1100, y: 230)
        
        let w2Rad : CGFloat = 170
        let w2NumPlanets = 5
        for d in 0..<w2NumPlanets {
            
            let wp = GameObjectFactory.makeWaterPlanet(radius: 30, gravityRadiusFactor: 0.5, angularVelocity: 0)
            wp.getNode()?.position = f2.getNode()!.position + CGPoint(angle: 2*CGFloat.pi*CGFloat(d)/CGFloat(w2NumPlanets))*w2Rad
            wp.component(ofType: OrbitComponent.self)?.orbitAround(entity: f2, overrideSpeed: 50)
            if d == 0 {
                wp.component(ofType: OrbitComponent.self)?.showingOrbitLine = true
            }
            
            entities.append(wp)
            self.addChild(wp.getNode()!, isGUI: false)
        }
        
        let b1 = GameObjectFactory.makeBunkerPlanet(radius: 100, gravityRadiusFactor: 0.5, angularVelocity: 0.0)
        b1.getNode()?.position = CGPoint(x: 1100, y: -230)
        
        let w3Rad : CGFloat = 200
        let w3NumPlanets = 3
        for d in 0..<w3NumPlanets {
            
            let wp = GameObjectFactory.makeWaterPlanet(radius: 40, gravityRadiusFactor: 0.3, angularVelocity: 0)
            wp.getNode()?.position = b1.getNode()!.position + CGPoint(angle: 2*CGFloat.pi*CGFloat(d)/CGFloat(w3NumPlanets))*w3Rad
            wp.component(ofType: OrbitComponent.self)?.orbitAround(entity: b1, overrideSpeed: 50)
            if d == 0 {
                wp.component(ofType: OrbitComponent.self)?.showingOrbitLine = true
            }
            
            entities.append(wp)
            self.addChild(wp.getNode()!, isGUI: false)
        }
        
        entities.append(f1)
        entities.append(f2)
        entities.append(b1)
        
        self.addChild(f1.getNode()!, isGUI: false)
        self.addChild(f2.getNode()!, isGUI: false)
        self.addChild(b1.getNode()!, isGUI: false)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
