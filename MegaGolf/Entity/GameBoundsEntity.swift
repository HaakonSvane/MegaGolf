//
//  GameBoundsEntity.swift
//  MegaGolf
//
//  Created by Haakon Svane on 24/03/2021.
//

import GameKit

class GameBoundsEntity : GKEntity {
    init(rect: CGRect){
        super.init()
        
        let nodeComp = NodeComponent()
        let shapeComp = ShapeComponent(shapeType: .rectangle(rect.size))
        shapeComp.shapes.setFill(color: .clear, locator: .all)
        shapeComp.shapes.setStroke(color: GLOBALCOLOR.TEXTRED ?? GLOBALCOLOR.DEFAULT , locator: .all, lineType: .dashed)
        shapeComp.shapes.position.x = rect.origin.x + rect.width/2
        shapeComp.shapes.position.y = rect.origin.y + rect.height/2
        
        self.addComponent(nodeComp)
        self.addComponent(shapeComp)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
