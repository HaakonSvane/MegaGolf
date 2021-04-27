//
//  MGAimingGameState.swift
//  MegaGolf
//
//  Created by Haakon Svane on 25/03/2021.
//

import GameKit

class MGAimingGameState : MGGamePlayState {
    let maxDist: CGFloat = 150
    let strength: CGFloat = 40
    let aimLength: CGFloat = 150 * 1.9
    
    // The relative distance (of maxDist) before the ball is to be considered for launch.
    let threshLaunch: CGFloat = 0.17
    
    private var dist: CGFloat
    private var angle: CGFloat
    private var lastTouchDownPos: CGPoint
    private var isAiming: Bool
    
    override init(){
        self.dist = 0
        self.angle = 0
        self.lastTouchDownPos = .zero
        self.isAiming = false
        super.init()
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is MGLaunchingGameState.Type
    }
    
    override func didEnter(from previousState: GKState?) {
        self.ball?.component(ofType: PhysicsComponent.self)?.isDynamic = false
        self.ball?.component(ofType: PhysicsComponent.self)?.collisionBitMask = 0b00000
        self.ball?.component(ofType: ShapeComponent.self)?.shapes.visible(option: true, locator: .forName("anchorShape"))
        
        ball?.component(ofType: TouchableCompoment.self)?.onTouchDown = {touches, event in
            self.lastTouchDownPos = touches.first!.location(in: (self.stateMachine as! MGGamePlayStateMachine).parentScene!)
            self.ball?.component(ofType: HapticComponent.self)?.run(impactType: .light)
            self.ball?.component(ofType: ShapeComponent.self)?.shapes.visible(option: true, locator: .forName("launcherShape"))
        }
        
        ball?.component(ofType: TouchableCompoment.self)?.onTouchUp = {touches, event in
            let sComp = self.ball?.component(ofType: ShapeComponent.self)
            sComp?.shapes.xScale(amount: 1, locator: .all)
            sComp?.shapes.yScale(amount: 1, locator: .all)
            sComp?.shapes.visible(option: false, locator: .forName("launcherShape"))
            sComp?.shapes.visible(option: false, locator: .forName("aimerShape"))
            sComp?.shapes.setPosition(to: .zero, locator: .all)
            
            let lAngle: CGFloat = self.angle + CGFloat.pi
            let relDist: CGFloat = self.dist / self.maxDist
            let lVec = CGVector(dx: self.strength*relDist*cos(lAngle), dy: self.strength*relDist*sin(lAngle))
            if self.dist/self.maxDist >= self.threshLaunch {self.launchBall(impulse: lVec)}
            self.isAiming = false
            
            
        }
        
        ball?.component(ofType: TouchableCompoment.self)?.onTouchMove = {touches, event in
            self.lastTouchDownPos = touches.first!.location(in: (self.stateMachine as! MGGamePlayStateMachine).parentScene!)
            self.ball?.component(ofType: ShapeComponent.self)?.shapes.visible(option: true, locator: .forName("launcherShape"))
            self.ball?.component(ofType: ShapeComponent.self)?.shapes.visible(option: true, locator: .forName("aimerShape"))
            self.isAiming = true
        }
    }
    
    
    private func launchBall(impulse: CGVector){
        self.ball?.component(ofType: OrbitComponent.self)?.releaseFromOrbit()
        self.ball?.component(ofType: PhysicsComponent.self)?.velocity = .zero
        self.ball?.component(ofType: PhysicsComponent.self)?.isDynamic = true
        self.ball?.component(ofType: ShapeComponent.self)?.shapes.setPosition(to: .zero, locator: .forName("anchorShape"))
        self.ball?.component(ofType: ShapeComponent.self)?.shapes.visible(option: false, locator: .forName("anchorShape"))
        self.ball?.getPhysicsBody()?.applyImpulse(impulse)
        self.ball?.component(ofType: AudioComponent.self)?.play()
        (self.stateMachine as! MGGamePlayStateMachine).parentScene?.currentShots += 1
        self.stateMachine?.enter(MGLaunchingGameState.self)
    }
    
    private func colorBallShapes(){
        let col: UIColor
        if self.dist / self.maxDist < self.threshLaunch {
            col = GLOBALCOLOR.BALLAIMREADY ?? GLOBALCOLOR.DEFAULT
        } else {
            col = UIColor(rgba: RGBA(R: (self.dist-self.threshLaunch)/(self.maxDist-self.threshLaunch),
                                     G: 1-(self.dist-self.threshLaunch)/(self.maxDist-self.threshLaunch), B: 0.3, A: 1))
        }
        
        let sComp = self.ball?.component(ofType: ShapeComponent.self)
        sComp?.shapes.setFill(color: col, locator: .forName("anchorShape"))
        sComp?.shapes.setFill(color: col, locator: .forName("launcherShape"))
        
    }
    
    private func aimBall(){
        let relPos = lastTouchDownPos - ball!.getNode()!.position
        let ballScale = ball!.component(ofType: ScaleComponent.self)!.scaleX
        self.angle = relPos.angle
        self.dist = relPos.length().clamped(to: 0...maxDist)
        
        // The relative angle is needed to account for the fact that the ball might rotate and the shapes are children of it.
        let relAngle = self.angle - ball!.getNode()!.zRotation
        
        let sComp = self.ball?.component(ofType: ShapeComponent.self)
        sComp?.shapes.zRotation(amount: relAngle, locator: .forName("launcherShape"))
        sComp?.shapes.zRotation(amount: relAngle, locator: .forName("aimerShape"))
        
        let xScl = self.dist/ballScale
        sComp?.shapes.xScale(amount: xScl, locator: .forName("launcherShape"))
        sComp?.shapes.xScale(amount: aimLength/ballScale, locator: .forName("aimerShape"))
        sComp?.shapes.yScale(amount: 10-8*self.dist/self.maxDist, locator: .forName("launcherShape"))
        sComp?.shapes.setScale(amount: 1-0.2*self.dist/self.maxDist, locator: .forName("anchorShape"))
        
        let offSetPosLauncher = CGPoint(x: self.dist*cos(relAngle)/2/ballScale, y: self.dist*sin(relAngle)/2/ballScale)
        let offSetPosAimer = CGPoint(x: self.aimLength*cos(relAngle)/2/ballScale, y: self.aimLength*sin(relAngle)/2/ballScale)
        
        sComp?.shapes.setPosition(to: offSetPosLauncher, locator: .forName("launcherShape"))
        sComp?.shapes.setPosition(to: .zero - offSetPosAimer, locator: .forName("aimerShape"))
        sComp?.shapes.setPosition(to: CGPoint(angle: relAngle) * self.dist / ballScale, locator: .forName("anchorShape"))
        sComp?.shapes.updateFillShaderUniform(uniformNamed: "u_angle", floatValue: Float(self.angle), locator: .forName("aimerShape"))
        
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        if isAiming {
            aimBall()
        }else {
            self.dist = 0
        }
        colorBallShapes()
    }
}
