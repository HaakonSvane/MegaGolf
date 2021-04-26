//
//  MGUIIconButtonEntity.swift
//  MegaGolf
//
//  Created by Haakon Svane on 21/03/2021.
//


import GameKit

fileprivate typealias anim = MGAnimation

enum MGUIIconType{
    case settings
    case help
    case back
    case pause
    case left
    case right
    case goalCheck
    case ballCheck
}

class MGUIIconButtonEntity : GKEntity {
    init(type : MGUIIconType, textureAtlas: SKTextureAtlas, onCompletion : @escaping ()->Void){
        super.init()
        
        var textureName: String = ""
        switch type{
        case .settings:
            textureName = "settingsButton"
        case .help:
            textureName = "helpButton"
        case .back:
            textureName = "backButton"
        case .pause:
            textureName = "pauseButton"
        case .left:
            textureName = "leftButton"
        case .right:
            textureName = "rightButton"
        case .goalCheck:
            textureName = "goalCheckButton"
        case .ballCheck:
            textureName = "ballCheckButton"
        }
        
        let nodeComp = NodeComponent()
        let spriteComp = SpriteComponent(from: textureAtlas, initTextureName: textureName+"1")
        let touchComp = TouchableCompoment()
        let audioComp = AudioComponent(sound: MGAudioUnit(fileName: "TestUIClick", type: .effect), loopAudio: false)
        let scaleComp = ScaleComponent(x: 1/2, y: 1/2)
        let hapticComp = HapticComponent(impact: .light)
        let animComp = ActionAnimationComponent()
        
        self.addComponent(nodeComp)
        self.addComponent(spriteComp)
        self.addComponent(touchComp)
        self.addComponent(audioComp)
        self.addComponent(scaleComp)
        self.addComponent(hapticComp)
        self.addComponent(animComp)
        
        touchComp.onTouchDown = {touches, event in
            self.getNode()?.run(SKAction.run{
                self.component(ofType: SpriteComponent.self)?.setTexture(textureName: "\(textureName)2")
                self.component(ofType: HapticComponent.self)?.run()
            })
        }
        
        touchComp.onTouchUp = {touches, event in
            self.getNode()?.run(SKAction.run{
                self.component(ofType: SpriteComponent.self)?.setTexture(textureName: "\(textureName)1")
                self.component(ofType: AudioComponent.self)?.play()
                self.component(ofType: HapticComponent.self)?.run()
            }, completion: onCompletion)
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
