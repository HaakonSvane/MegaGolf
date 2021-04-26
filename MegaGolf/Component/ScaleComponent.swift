//
//  ScaleComponent.swift
//  MegaGolf
//
//  Created by Haakon Svane on 05/03/2021.
//

import GameKit


/**
    Component for scaling a entity and all its attached components. When this is attached to an entity, all previous spacial components (for example `SpriteComponent`, `PhysicsComponent` ) are scaled.
    
    - Requires :
        - `NodeComponent`
 
 */
class ScaleComponent : GKComponent {
    
    /// The X scale applied to the entity.
    var scaleX : CGFloat{
        didSet{
            entity?.getNode()?.xScale = scaleX
        }
    }
    /// The Y scale applied to the entity.
    var scaleY : CGFloat{
        didSet{
            entity?.getNode()?.yScale = scaleY
        }
    }
    /**
        Initializes a new `ScaleComponent`.
        - Parameters:
            - x: Scaling factor applied to the entity in the x direction.
            - y: Scaling factor applied to the entity in the y direction.
     */
    init(x: CGFloat = 1, y: CGFloat = 1){
        scaleX = x
        scaleY = y
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didAddToEntity() {
        guard let eNode = entity?.getNode() else {
            fatalError("The entity does not have a NodeComponent attached to it. Do this before adding a ScaleComponent.")
        }
        eNode.xScale = scaleX
        eNode.yScale = scaleY
    }
}
