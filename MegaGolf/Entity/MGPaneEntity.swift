//
//  MGPaneEntity.swift
//  MegaGolf
//
//  Created by Haakon Svane on 24/03/2021.
//

import GameKit

enum MGPaneType {
    case small
    case gameInfo
    case alert
}

class MGPaneEntity : GKEntity{
    init(type: MGPaneType, atlasName: String){
        super.init()
        
        let textureName: String
        switch type{
        case .small:
            textureName = "smallPane"
        case .gameInfo:
            textureName = "gameInfoPane"
        case .alert:
            textureName = "alertPane"
        }
        
        let nodeComp = NodeComponent()
        let spriteComp = SpriteComponent(atlasName: atlasName, initTextureName: textureName)
        let labelComp = LabelComponent(numLabels: 0)
        let scaleComp = ScaleComponent(x: 1/2, y: 1/2)
        
        self.addComponent(nodeComp)
        self.addComponent(spriteComp)
        self.addComponent(labelComp)
        self.addComponent(scaleComp)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
