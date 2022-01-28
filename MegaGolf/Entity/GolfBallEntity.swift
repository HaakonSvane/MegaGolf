//
//  GolfBallEntity.swift
//  MegaGolf
//
//  Created by Haakon Svane on 24/03/2021.
//

import GameKit

fileprivate typealias anim = MGAnimation

enum MGBallType{
    case normal
}

class GolfBallEntity : GKEntity{
    init(type: MGBallType){
        super.init()
        
        let textureName: String
        switch type{
        case .normal:
            textureName = "golfBall"
        }
        
        let ballScale: CGFloat = 0.3
        
        let nodeComp = NodeComponent()
        let spriteComp = SpriteComponent(textureName: textureName, addNormalMap: true)
        let physComp = PhysicsComponent(bodyType: .circular(radius: spriteComp.spriteNode.size.width/2*ballScale))
        let touchComp = TouchableCompoment()
        let lightRComp = LightReceiverComponent()
        let audioComp = AudioComponent(sound: MGAudioUnit(fileName: "ballHit", type: .effect), loopAudio: false)
        let shapeComp = ShapeComponent(shapeType: .rectangle(CGSize(width: 1, height: 10)), name: "launcherShape")
        let scaleComp = ScaleComponent(x: ballScale, y: ballScale)
        let haptComp = HapticComponent(impact: .light)
        let orbitComp = OrbitComponent()
        let dataComp = DataStoreComponent()
        let animComp = ActionAnimationComponent()
        let emitterComp = ParticleEmitterComponent(emitterName: "golfBallShotEmitter")
        
        let radius = spriteComp.spriteNode.size.width/2
        
        physComp.categoryBitMask = 0b00001
        physComp.collisionBitMask = 0b00001
        physComp.contactBitMask = 0b00001
        physComp.fieldBitMask = 0b00001
        physComp.linearDamping = 0.0
        physComp.kineticFriction = 0.5
        physComp.angularDamping = 1.0
        physComp.mass = 0.5
        physComp.restitution = 0.2
        physComp.usesPreciseCollisionDetection = true
        
        lightRComp.lightingBitMask = 0b00011
        lightRComp.shadowCastBitMask = 0b00000
        lightRComp.shadowedBitMask = 0b00010
        
        shapeComp.shapes.addShape(shapeType: .rectangle(CGSize(width: 1, height: 5)), fillColor: .red, strokeColor: .clear, name: "aimerShape")
        shapeComp.shapes.addShape(shapeType: .circle(radius*1.6), name: "anchorShape")
        
        shapeComp.shapes.visible(option: false, locator: .forName("launcherShape"))
        shapeComp.shapes.visible(option: false, locator: .forName("aimerShape"))
        shapeComp.shapes.visible(option: false, locator: .forName("anchorShape"))
        shapeComp.shapes.setFill(color: GLOBALCOLOR.BALLAIMREADY ?? GLOBALCOLOR.DEFAULT, locator: .forName("launcherShape"))
        shapeComp.shapes.setFill(color: GLOBALCOLOR.BALLAIMREADY ?? GLOBALCOLOR.DEFAULT, locator: .forName("aimerShape"))
        shapeComp.shapes.setFill(color: GLOBALCOLOR.BALLAIMREADY ?? GLOBALCOLOR.DEFAULT, locator: .forName("anchorShape"))
        
        let shaderUniform = SKUniform(name: "u_angle", float: 0)
        shapeComp.shapes.setFillShader(shaderName: "MovingDashedFill", locator: .forName("aimerShape"), uniforms: [shaderUniform])
        
        
        dataComp.data = ["spriteRadius": spriteComp.spriteNode.size.width/2*scaleComp.scaleX, "physicsRadius": spriteComp.spriteNode.size.width/2*scaleComp.scaleX]
        
        animComp.addAnimation(actions: [anim.scaleLinear(by: 2/3, duration: 2), anim.fadeOut(duration: 1.5)], withName: "scaleAndFade")
        animComp.addAnimation(actions: [anim.scaleLinear(to: scaleComp.scaleX, duration: 0), anim.visible()], withName: "scaleAndFadeReset")
        
        self.addComponent(nodeComp)
        self.addComponent(spriteComp)
        self.addComponent(physComp)
        self.addComponent(touchComp)
        self.addComponent(lightRComp)
        self.addComponent(audioComp)
        self.addComponent(shapeComp)
        self.addComponent(scaleComp)
        self.addComponent(haptComp)
        self.addComponent(orbitComp)
        self.addComponent(dataComp)
        self.addComponent(animComp)
        self.addComponent(emitterComp)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
