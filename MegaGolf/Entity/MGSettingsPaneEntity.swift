//
//  MGSettingsPaneEntity.swift
//  MegaGolf
//
//  Created by Haakon Svane on 19/03/2021.
//

import GameKit

class MGUISettingsPaneEntity : GKEntity{
    init(options: [String], atlas: SKTextureAtlas, optionsAreaRelativeHeight: CGFloat, headerText: String = "SETTINGS"){
        super.init()
        
        let nodeComp = NodeComponent()
        let spriteComp = SpriteComponent(from: atlas, initTextureName: "settingsPane")
        let labelComp = LabelComponent(numLabels: options.count+1)
        let scaleComp = ScaleComponent(x: 1/2, y: 1/2)
        
        
        self.addComponent(nodeComp)
        self.addComponent(spriteComp)
        self.addComponent(labelComp)
        self.addComponent(scaleComp)
        
        let winHeight = spriteComp.spriteNode.size.height
        let optionsHeight = winHeight*optionsAreaRelativeHeight
        let frac = optionsHeight/(CGFloat(options.count)+1)
        let yOff = winHeight/15
        
        for (index, label) in labelComp.labels.enumerated(){
            if index == options.count{
                label.text = headerText
                label.fontSize = 70
                label.position.y = winHeight*(1/2-1/6)
                label.showShadow = true
            }else{
                label.text = options[index]+":"
                label.fontSize = 40
                label.position.y = winHeight/2-frac*(CGFloat(index) + 1)-yOff
                label.showShadow = true
            }
        }
        labelComp.labels.zPosition = 2
        labelComp.labels.position.x = winHeight/60
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
