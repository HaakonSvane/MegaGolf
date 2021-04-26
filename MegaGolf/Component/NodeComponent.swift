//
//  NodeComponent.swift
//  MegaGolf
//
//  Created by Haakon Svane on 10/03/2021.
//

import GameKit

/**
    A top-level node used with entities that needs to have some elements added to an `MGScene`. Once this component is added to an entity, the `MGNode` representing this component is accesible
    using the .getNode() method on the entity itself for easier access.
 */
class NodeComponent : GKComponent{
    private(set) var node : MGNode
    
    override init(){
        node = MGNode()
        super.init()
    }
    override func didAddToEntity(){
        node.name = String(describing: type(of: entity!.self))
        node.parentEntity = entity
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
