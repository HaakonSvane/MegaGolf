//
//  Level_1_1.swift
//  MegaGolf
//
//  Created by Haakon Svane on 07/04/2021.
//

import GameKit

class Level_1_1 : MGGameScene, MGLevelSceneProtocol{
    required init(viewSize: CGSize, onlineMatch: GKMatch?) {
        let bounds = CGRect(x: -800, y: -800, width: 4000, height: 1600)
        let start = CGPoint(x: -100, y: 0)
        let end = CGPoint(x: 1900, y: 0)
        
        super.init(viewSize: viewSize,
                   gameBounds: bounds,
                   playerStartPos: start,
                   goalPos: end,
                   goalRadius: 70,
                   levelPar: 5,
                   onlineMatch: onlineMatch)
        
        let f1 = GameObjectFactory.makeFieldPlanet(radius: 90, gravityRadiusFactor: 1.4, angularVelocity: 0.05)
        f1.getNode()?.position = CGPoint(x: 200, y: 120)
        
        let f2 = GameObjectFactory.makeFieldPlanet(radius: 70, gravityRadiusFactor: 1.5, angularVelocity: -0.3)
        f2.getNode()?.position = CGPoint(x: 800, y: -50)
        
        let f3 = GameObjectFactory.makeFieldPlanet(radius: 135, gravityRadiusFactor: 0.7, angularVelocity: 0.2)
        f3.getNode()?.position = CGPoint(x: 1300, y: -200)
        let m1 = GameObjectFactory.makeMoonPlanet(radius: 40, gravityRadiusFactor: 0.8, angularVelocity: -0.05)
        m1.getNode()?.position = CGPoint(x: 1600, y: -200)
        m1.component(ofType: OrbitComponent.self)?.orbitAround(entity: f3, overrideSpeed: 50)
        
        let f4 = GameObjectFactory.makeFieldPlanet(radius: 120, gravityRadiusFactor: 1.3, angularVelocity: -0.1)
        f4.getNode()?.position = CGPoint(x: 1700, y: 500)
        
        self.entities.append(f1)
        self.entities.append(f2)
        self.entities.append(f3)
        self.entities.append(m1)
        self.entities.append(f4)
        
        self.addChild(f1.getNode()!, isGUI: false)
        self.addChild(f2.getNode()!, isGUI: false)
        self.addChild(f3.getNode()!, isGUI: false)
        self.addChild(m1.getNode()!, isGUI: false)
        self.addChild(f4.getNode()!, isGUI: false)
    }
    

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
