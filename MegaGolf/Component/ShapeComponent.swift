//
//  ShapeComponent.swift
//  MegaGolf
//
//  Created by Haakon Svane on 21/03/2021.
//

import GameKit

/**
    A component for adding a shape container to the entity. The container can hold multiple shapes.
    
    - Requires :
        - `NodeComponent`
 
 */

class ShapeComponent : GKComponent {
    
    let shapes : SKShapeNodeContainer
    
    init(shapeType: SKShapeType? = nil, name: String? = nil){
        shapes = SKShapeNodeContainer()
        super.init()
        if let sType = shapeType{
            shapes.addShape(shapeType: sType, name: name)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didAddToEntity() {
        entity?.getNode()?.addChild(shapes)
    }
    
    
    
}
