//
//  SingleTextEntity.swift
//  MegaGolf
//
//  Created by Haakon Svane on 23/03/2021.
//

fileprivate typealias anim = MGAnimation

import GameKit

class SingleTextEntity : GKEntity {
    
    init(text: String, size: CGFloat = 100, shadowed: Bool = true) {
        super.init()
        
        let nodeComp = NodeComponent()
        let textComp = LabelComponent(numLabels: 1)
        let animComp = ActionAnimationComponent()
        
        
        textComp.labels.setText(text: text, locator: .all)
        textComp.labels.setSize(size: size, locator: .all)
        textComp.labels.shadow(option: true, locator: .all)
        
        animComp.addAnimation(action: anim.invisible(), withName: "hide")
        animComp.addAnimation(action: anim.visible(), withName: "unhide")
        animComp.addAnimation(actions: [anim.scaleSmooth(by: 1.2, duration: 0.15), anim.scaleLinear(to: 1, duration: 0.07)], withName: "pop")
        animComp.addAnimation(actions: [anim.scaleLinear(by: 2/3, duration: 2), anim.fadeOut(duration: 1.5)], withName: "scaleAndFade")
        animComp.addAnimation(actions: [anim.scaleLinear(to: 1, duration: 0), anim.visible()], withName: "scaleAndFadeReset")
        _ = animComp.pairAnimations(nameOfFirst: "pop",
                                    nameOfSecond: "scaleAndFade",
                                    orderOfFirst: .sequence(delayBetween: 0),
                                    orderOfSecond: .parallel,
                                    nameOfResult: "popScaleAndFade")
        
        self.addComponent(nodeComp)
        self.addComponent(textComp)
        self.addComponent(animComp)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
