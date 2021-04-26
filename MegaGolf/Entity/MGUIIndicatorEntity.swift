//
//  MGUIIndicatorEntity.swift
//  MegaGolf
//
//  Created by Haakon Svane on 18/04/2021.
//

import GameplayKit

enum MGUIIndicatorValue {
    case red
    case green
}

class MGUIIndicatorEntity : GKEntity {
    
    init(atlas: SKTextureAtlas, initialState: MGUIIndicatorValue = .red){
        super.init()
        
        let nodeComp = NodeComponent()
        let spriteComp = SpriteComponent(from: atlas, initTextureName: "indicatorIconRed")
        let scaleComp = ScaleComponent(x: 1/4, y: 1/4)
        
        self.addComponent(nodeComp)
        self.addComponent(spriteComp)
        self.addComponent(scaleComp)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
