//
//  LevelEntity.swift
//  MegaGolf
//
//  Created by Haakon Svane on 07/04/2021.
//

import GameKit

fileprivate typealias anim = MGAnimation

class LevelEntity : GKEntity{
    override init(){
        super.init()
        let nodeComp = NodeComponent()
        let orbitComp = OrbitComponent()
        let dataComp = DataStoreComponent()
        let labelComp = LabelComponent()
        let animComp = ActionAnimationComponent()
        
        
        animComp.addAnimation(action: anim.invisible(), withName: "hide")
        animComp.addAnimation(action: anim.visible(), withName: "unhide")
        animComp.addAnimation(action: anim.fadeOut(duration: 0.5), withName: "fadeOut")
        animComp.addAnimation(action: anim.fadeIn(duration: 0.5), withName: "fadeIn")
        
        self.addComponent(nodeComp)
        self.addComponent(orbitComp)
        self.addComponent(dataComp)
        self.addComponent(labelComp)
        self.addComponent(animComp)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
