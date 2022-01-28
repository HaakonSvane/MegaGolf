//
//  MGUILabelButtonEntity.swift
//  MegaGolf
//
//  Created by Haakon Svane on 16/03/2021.
//

import GameKit

fileprivate typealias anim = MGAnimation

enum MGLabelButtonType{
    case top
    case bot
    case medium
}

class MGUILabelButtonEntity : GKEntity{
    init(type : MGLabelButtonType, atlasName: String, buttonText : String, textColor: UIColor, textRelPos : CGPoint = .zero, onCompletion : @escaping ()->Void){
        super.init()
        
        var textureName : String = ""
        switch type{
        case .bot:
            textureName = "botButton"
        case .top:
            textureName = "topButton"
        case .medium:
            textureName = "mediumButton"
        }
        
        let nodeComp = NodeComponent()
        let spriteComp = SpriteComponent(atlasName: atlasName, initTextureName: textureName+"1")
        let touchComp = TouchableCompoment()
        let audioComp = AudioComponent(sound: MGAudioUnit(fileName: "TestUIClick", type: .effect), loopAudio: false)
        let labelComp = LabelComponent(numLabels: 1)
        let scaleComp = ScaleComponent(x: 1/2, y: 1/2)
        let hapticComp = HapticComponent(impact: .light)
        let animComp = ActionAnimationComponent()
        
        let s = spriteComp.spriteNode.size
        
        self.addComponent(nodeComp)
        self.addComponent(spriteComp)
        self.addComponent(touchComp)
        self.addComponent(audioComp)
        self.addComponent(labelComp)
        self.addComponent(scaleComp)
        self.addComponent(hapticComp)
        self.addComponent(animComp)
        
        
        labelComp.labels.shadow(option: true, locator: .all)
        labelComp.labels.setText(text: buttonText, locator: .all)
        labelComp.labels.setColor(color: textColor, locator: .all)
        labelComp.labels.setSize(size: s.height*0.52, locator: .all)
        labelComp.labels.zPosition = 2
        labelComp.labels.position.x += 10 + textRelPos.x
        labelComp.labels.position.y += 2 + textRelPos.y
        
        touchComp.onTouchDown = {touches, event in
            
            if let _ = touches.first {
                self.getNode()?.run(SKAction.run{
                    self.component(ofType: SpriteComponent.self)?.setTexture(textureName: "\(textureName)2")
                    self.component(ofType: LabelComponent.self)?.labels.position.x += 15
                    self.component(ofType: LabelComponent.self)?.labels.position.y -= 15
                    self.component(ofType: LabelComponent.self)?.labels.shadow(option: false, locator: .all)
                    self.component(ofType: HapticComponent.self)?.run()
                })
            }
        }
        
        touchComp.onTouchUp = {touches, event in
            if let _ = touches.first {
                self.getNode()?.run(SKAction.run{
                    self.component(ofType: SpriteComponent.self)?.setTexture(textureName: "\(textureName)1")
                    self.component(ofType: AudioComponent.self)?.play()
                    self.component(ofType: LabelComponent.self)?.labels.position.x -= 15
                    self.component(ofType: LabelComponent.self)?.labels.position.y += 15
                    self.component(ofType: LabelComponent.self)?.labels.shadow(option: true, locator: .all)
                    self.component(ofType: HapticComponent.self)?.run()
                }, completion: onCompletion)
            }
        }
        
        animComp.addAnimation(actions: [anim.moveSmooth(by: CGVector(dx: 1000, dy: 0), duration: 0)], withName: "fastRight")
        animComp.addAnimation(actions: [anim.moveSmooth(by: CGVector(dx: -1000, dy: 0), duration: 0)], withName: "fastLeft")
        animComp.addAnimation(actions: [anim.moveSmooth(by: CGVector(dx: 1000, dy: 0), duration: 0.5)], withName: "smoothRight")
        animComp.addAnimation(actions: [anim.moveSmooth(by: CGVector(dx: -1000, dy: 0), duration: 0.5)], withName: "smoothLeft")
        animComp.addAnimation(actions: [anim.moveSmooth(by: CGVector(dx: 0, dy: 1000), duration: 0)], withName: "fastUp")
        animComp.addAnimation(actions: [anim.moveSmooth(by: CGVector(dx: 0, dy: -1000), duration: 0)], withName: "fastDown")
        animComp.addAnimation(actions: [anim.moveSmooth(by: CGVector(dx: 0, dy: 1000), duration: 0.5)], withName: "smoothUp")
        animComp.addAnimation(actions: [anim.moveSmooth(by: CGVector(dx: 0, dy: -1000), duration: 0.5)], withName: "smoothDown")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
