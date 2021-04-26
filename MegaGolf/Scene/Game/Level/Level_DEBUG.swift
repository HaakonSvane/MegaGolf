//
//  Level_DEBUG.swift
//  MegaGolf
//
//  Created by Haakon Svane on 24/03/2021.
//

import GameKit

class Level_DEBUG : MGGameScene, MGLevelSceneProtocol{
    required init(viewSize: CGSize, onlineMatch: GKMatch?) {
        let bounds = CGRect(x: -viewSize.width, y: -viewSize.height, width: viewSize.width*2, height: viewSize.height*2)
        let start = CGPoint(x: 0, y: 0)
        let end = CGPoint(x: 0, y: -350)
        super.init(viewSize: viewSize,
                   gameBounds: bounds,
                   playerStartPos: start,
                   goalPos: end,
                   goalRadius: 70,
                   levelPar: 10,
                   onlineMatch: onlineMatch)
        let fieldPlanet = GameObjectFactory.makeFieldPlanet(radius: 100, gravityRadiusFactor: 1.3, angularVelocity: 1/2)
        let bunkerPlanet = GameObjectFactory.makeBunkerPlanet(radius: 90, gravityRadiusFactor: 0.9, angularVelocity: -0.5)
        let waterPlanet = GameObjectFactory.makeWaterPlanet(radius: 100, gravityRadiusFactor: 1.3, angularVelocity: -0.09)
        let moonPlanet = GameObjectFactory.makeMoonPlanet(radius: 30, gravityRadiusFactor: 1, angularVelocity: 0)
        
        fieldPlanet.getNode()?.position.x = 350
        bunkerPlanet.getNode()?.position.y = 350
        waterPlanet.getNode()?.position.x = -350
        moonPlanet.getNode()?.position.x = 100
        
        moonPlanet.component(ofType: OrbitComponent.self)?.orbitAround(point: .zero, overrideSpeed: 100)
        moonPlanet.component(ofType: OrbitComponent.self)?.showingOrbitLine = true

        
        self.addEntity(fieldPlanet)
        self.addEntity(bunkerPlanet)
        self.addEntity(waterPlanet)
        self.addEntity(moonPlanet)
        
        self.addChild(fieldPlanet.getNode()!, isGUI: false)
        self.addChild(bunkerPlanet.getNode()!, isGUI: false)
        self.addChild(waterPlanet.getNode()!, isGUI: false)
        self.addChild(moonPlanet.getNode()!, isGUI: false)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
