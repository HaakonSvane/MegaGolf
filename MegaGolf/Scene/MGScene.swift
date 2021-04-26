//
//  MGScene.swift
//  MegaGolf
//
//  Created by Haakon Svane on 02/03/2021.
//

import SpriteKit

import GameplayKit

enum MGSceneValueChange {
    case golfShots(_ num: Int)
    case gamePar(_ num: Int)
    case enteredHazard(_ type: MGHazardType)
    case enteredGoal(shots: Int, par: Int)
    case gameTime(_ time: TimeInterval)
}

class MGScene: SKScene {
    
    var entities: [GKEntity]
    weak var managingState : MGSceneState?
    let worldNode: SKEffectNode
    
    var lastUpdateTime : TimeInterval = 0
    
    override init(size: CGSize) {
        entities = []
        worldNode = SKEffectNode()
        super.init(size: size)
        self.isUserInteractionEnabled = false
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        let cam = MGCameraNode(sceneSize: size)
        self.camera = cam
        
        worldNode.shouldEnableEffects = false
        worldNode.shouldRasterize = true
        worldNode.zPosition = -5
        
        self.addChild(cam)
        self.addChild(worldNode)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func sceneDidLoad() {
        self.lastUpdateTime = 0
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        
        self.lastUpdateTime = currentTime
    }
    
    func addEntity(_ entity: GKEntity, hasNode: Bool = true){
        self.entities.append(entity)
    }
    
    func removeEntity(_ entity: GKEntity){
        self.entities.removeAll{$0 === entity}
    }
    
    func addChild(_ node: SKNode, isGUI: Bool) {
        switch isGUI {
        case true:
            self.camera?.addChild(node)
        case false:
            self.worldNode.addChild(node)
        }
    }
}
