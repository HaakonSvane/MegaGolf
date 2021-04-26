//
//  LabelComponent.swift
//  MegaGolf
//
//  Created by Haakon Svane on 15/03/2021.
//

import GameKit

/**
    A component for adding a label container to the entity. The container can hold multiple `MGLabel`s
    
    - Requires :
        - `NodeComponent`
 
 */

class LabelComponent : GKComponent {
    
    var labels : MGLabelNodeContainer
    
    init(numLabels: Int = 1){
        labels = MGLabelNodeContainer(numLabels: numLabels)
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didAddToEntity() {
        guard let eNode = entity?.getNode() else{
            fatalError("The entity does not have a NodeComponent attached to it. Add this before adding a SpriteComponent")
        }
        eNode.addChild(labels)
    }
}
