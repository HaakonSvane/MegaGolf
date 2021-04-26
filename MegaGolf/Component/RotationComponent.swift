//
//  RotationComponent.swift
//  MegaGolf
//
//  Created by Haakon Svane on 12/03/2021.
//

import GameKit


/**
    A component for making the entity rotate with a constant angular velocity.
    
    - Requires :
        - `NodeComponent`
 
 */
class RotationComponent : GKComponent {
    static let actionName : String = "rotationAction"
    var rotationAction : SKAction
    
    var omega : CGFloat {
        didSet{
            rotationAction = SKAction.repeatForever(SKAction.rotate(byAngle: omega, duration: 1))
            self.stop()
            self.start()
        }
    }
    
    /**
        Initializes a new `RotationComponent` instance with angular velocity.
        - Parameters:
            - omega: Angular velocity (radians per second) of the rotating body.
            - around: The relative point on the node where rotation happens around. Defaults to the center of the node (x: 0.5, y: 0.5).
        - Returns: A new `RotationComponent` instance.
     
     */
    init(omega: CGFloat){
        rotationAction = SKAction.repeatForever(SKAction.rotate(byAngle: omega, duration: 1))
        self.omega = omega
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didAddToEntity() {
        guard let eNode = entity?.getNode() else {
            fatalError("There is no NodeComponent to rotate. Add this to the entity first.")
        }
        eNode.run(rotationAction, withKey: RotationComponent.actionName)
    }
    
    func stop() -> Void {

        guard let eNode = entity?.getNode() else {
            fatalError("The component has not been attached to an entity with a node. Do this first.")
        }
        eNode.removeAction(forKey: RotationComponent.actionName)
    }
    
    func start() -> Void{
        guard let eNode = entity?.getNode() else {
            fatalError("The component has not been attached to an entity with a node. Do this first.")
        }
        eNode.run(rotationAction, withKey: RotationComponent.actionName)
    }
    
}
