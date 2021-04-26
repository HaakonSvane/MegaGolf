//
//  GKNode.swift
//  MegaGolf
//
//  Created by Haakon Svane on 04/03/2021.
//

import GameKit

enum MGContainerLocator{
    case atIndex(Int)
    case forName(String)
    case all
}

class MGNode : SKNode{
    
    weak var touchDelegate: InternalTouchEventDelegate?
    weak var parentEntity: GKEntity?
    private(set) var childEntities: [GKEntity]
    
    override init(){
        childEntities = []
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchDelegate?._onTouchDown(touches: touches, event: event)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchDelegate?._onTouchMove(touches: touches, event: event)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchDelegate?._onTouchUp(touches: touches, event: event)
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        touchDelegate?._onTouchCancelled(touches: touches, event: event)
    }
    
    /**
        Wrapper function for adding other entities as children to the node. This function also ensures that the entity instance is not garbage collected by the Swift Automatic Reference Counter.
        - Parameters:
            - entity: The `GKEntity` instance to add as a child.
     */
    func addChild(_ entity: GKEntity){
        guard let node = entity.getNode() else {
            fatalError("The entity you wish to add does not have a NodeComponent added to it. Do this first.")
        }
        self.addChild(node)
        self.childEntities.append(entity)
    }
    
    var sceneCoordinates : CGPoint? {
        get {
            guard let scene = scene else{
                return nil
            }
            return self.convert(.zero, to: scene)
        }
    }
}
