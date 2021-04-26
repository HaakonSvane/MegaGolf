//
//  GhostGolfBallEntity.swift
//  MegaGolf
//
//  Created by Haakon Svane on 19/04/2021.
//

import GameplayKit

fileprivate typealias anim = MGAnimation

class GhostGolfBallEntity : GKEntity {
    init(type: MGBallType, ballName: String){
        super.init()
        
        let textureName: String
        switch type{
        case .normal:
            textureName = "golfBall"
        }
        
        let nodeComp = NodeComponent()
        let spriteComp = SpriteComponent(with: textureName, addNormalMap: true)
        let labelComp = LabelComponent(numLabels: 1)
        let lightRComp = LightReceiverComponent()
        let scaleComp = ScaleComponent(x: 0.3, y: 0.3)
        let animComp = ActionAnimationComponent()
        
        let radius = spriteComp.spriteNode.size.width/2
        
        labelComp.labels.shadow(option: true, locator: .all)
        labelComp.labels.setSize(size: 30, locator: .all)
        labelComp.labels.position.y = radius*1.4
        labelComp.labels.setText(text: ballName, locator: .all)
        
        lightRComp.lightingBitMask = 0b00011
        lightRComp.shadowCastBitMask = 0b00000
        lightRComp.shadowedBitMask = 0b00010
        
        animComp.addAnimation(actions: [anim.scaleLinear(by: 2/3, duration: 2), anim.fadeOut(duration: 1.5)], withName: "scaleAndFade")
        animComp.addAnimation(actions: [anim.scaleLinear(to: scaleComp.scaleX, duration: 0), anim.visible()], withName: "scaleAndFadeReset")
        
        self.addComponent(nodeComp)
        self.addComponent(spriteComp)
        self.addComponent(lightRComp)
        self.addComponent(scaleComp)
        self.addComponent(animComp)
        self.addComponent(labelComp)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
