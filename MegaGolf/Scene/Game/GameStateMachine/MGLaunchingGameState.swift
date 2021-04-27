//
//  MGLaunchingGameState.swift
//  MegaGolf
//
//  Created by Haakon Svane on 25/03/2021.
//


import GameKit

class MGLaunchingGameState : MGGamePlayState {
    
    // The product of the cutoffVelocity and the static friction of a body is the point at which the ball attaches to the planet and changes state to the aiming state.
    let cutoffVelocity : CGFloat = 4
    
    // For storing the last 10 recorded velocities of the ball
    private var lastVelocities : FiniteStack<CGVector> = FiniteStack<CGVector>(numItems: 10)

    private var lastContactPlanet: MGPlanetEntity?
    private var lastRestOnPlanet: MGPlanetEntity?
    private var lastRestAngle: CGFloat
    private var updateFlag: Bool = true
    
    private var averageVelocity: CGVector{
        get{
            var sum: CGVector = .zero
            var count = 0
            for element in lastVelocities{
                if let elem = element{
                    sum = sum + elem
                    count += 1
                }
            }
            return sum/CGFloat(count)
        }
    }
    
    override init(){
        self.lastRestAngle = 0
        super.init()
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is MGAimingGameState.Type
    }
    
    override func didEnter(from previousState: GKState?) {
        
        // While the ball is in movement it should not respond to any touch events
        self.ball?.component(ofType: TouchableCompoment.self)?.reset()
        
        self.ball?.component(ofType: PhysicsComponent.self)?.collisionBitMask = 0b00001
        self.updateFlag = true
    }

    override func update(deltaTime seconds: TimeInterval) {
        if !updateFlag {return}
        // Friction does not work perfectly between nodes when under the effect of a SKFieldNode.
        // Some extra friction will have to be applied to a sliding golf ball
        if let p = lastContactPlanet, let b = ball {
            let pRad = p.component(ofType: DataStoreComponent.self)?.data["physicsRadius"] as! CGFloat
            let bRad = b.component(ofType: DataStoreComponent.self)?.data["physicsRadius"] as! CGFloat
            let rVec = (b.getNode()!.position-p.getNode()!.position).toCGVector()
            let dist = rVec.length()
            
            // If the the golf ball is hugging the planet with a tolerance of 1 (emperical value)
            if dist - (pRad + bRad) < 2 {
                // Store the cartesian velocity of the ball
                lastVelocities.push(b.component(ofType: PhysicsComponent.self)!.velocity)
                // Calculate the angle of the velocity vector of the rotating planet at the point where it is in contact with the ball.
                let angle = (b.getNode()!.position-p.getNode()!.position).angle + CGFloat.pi/2
                // Calculate the cartesian velocity vector of the planet at the point of contact
                let pVel = CGVector(angle: angle)*p.component(ofType: RotationComponent.self)!.omega*pRad
                let diffVel = pVel-averageVelocity
                b.component(ofType: PhysicsComponent.self)!.velocity += diffVel.normalized()*p.component(ofType: PhysicsComponent.self)!.kineticFriction*10 // Factor of 10 is an emperical value
                
                if diffVel.length() < cutoffVelocity*p.component(ofType: PhysicsComponent.self)!.staticFriction {
                    self.restOnPlanet(p)
                    stateMachine?.enter(MGAimingGameState.self)
                }
                
                let emitLoc = CGPoint(vector: rVec.rotated(by: -p.getNode()!.zRotation))
                p.component(ofType: ParticleEmitterComponent.self)?.emit(at: emitLoc, emitTime: 1)
            }
        }
        
        if let scn = (stateMachine as? MGGamePlayStateMachine)?.parentScene {
            if !scn.bounds.contains(scn.ball.getNode()!.position){
                self.updateFlag = false
                scn.didEnterHazard(type: .outOfBounds)
                self.ball?.component(ofType: ActionAnimationComponent.self)?.runAnimation(withName: "scaleAndFade",
                                                                                    orderType: .parallel,
                                                                                    onCompletion: {self.resetToLastPosition()})
            }
        }
    }
    
    private func restOnPlanet(_ planet: MGPlanetEntity){
        if planet is WaterPlanetEntity {return}
        let pRad = planet.component(ofType: DataStoreComponent.self)?.data["physicsRadius"] as! CGFloat
        let bRad = self.ball?.component(ofType: DataStoreComponent.self)?.data["physicsRadius"] as! CGFloat
        let totRad = pRad + bRad + 1
        let speed = planet.component(ofType: RotationComponent.self)!.omega * totRad
        
        self.ball?.component(ofType: OrbitComponent.self)?.orbitAround(entity: planet,
                                                              overrideRadius: totRad,
                                                              overrideSpeed: speed)
        self.lastRestOnPlanet = planet
        self.lastRestAngle = (self.ball!.getNode()!.position-planet.getNode()!.position).angle
    }
    
    private func resetToLastPosition() {
        guard let scn = (stateMachine as? MGGamePlayStateMachine)?.parentScene else {
            return
        }
        if let cP = lastRestOnPlanet {
            let pRad = cP.component(ofType: DataStoreComponent.self)?.data["physicsRadius"] as! CGFloat
            let bRad = self.ball?.component(ofType: DataStoreComponent.self)?.data["physicsRadius"] as! CGFloat
            let pos = cP.getNode()!.position + CGPoint(angle: lastRestAngle) * (pRad + bRad + 1)
            self.ball?.getNode()?.position = pos
            self.restOnPlanet(cP)
        }else {
            let pos = scn.playerStartPos
            self.ball?.getNode()?.position = pos
        }
        self.ball?.component(ofType: ActionAnimationComponent.self)?.runAnimation(withName: "scaleAndFadeReset", orderType: .parallel)
        self.ball?.getPhysicsBody()?.velocity = .zero
        
        self.ball?.getPhysicsBody()?.angularVelocity = 0
        self.ball?.getNode()?.zRotation = 0
        self.stateMachine?.enter(MGAimingGameState.self)
    }
    
    override func onContactBegin(contact: MGPhysicsContact){
        lastContactPlanet = contact.planet
        guard let scn = (stateMachine as? MGGamePlayStateMachine)?.parentScene else {
            return
        }
        if contact.contains(self.goal) && contact.contains(self.ball){
            self.ball?.getPhysicsBody()?.isDynamic = false
            self.ball?.getPhysicsBody()?.velocity = .zero
            scn.didEnterGoal()
            self.ball?.component(ofType: ActionAnimationComponent.self)?.runAnimation(withName: "scaleAndFade", orderType: .parallel)
        }else if contact.contains(self.ball), let p = contact.planet {
            switch p{
            case is WaterPlanetEntity:
                self.ball?.getPhysicsBody()?.isDynamic = false
                self.ball?.getPhysicsBody()?.velocity = .zero
                scn.didEnterHazard(type: .water)
                self.ball?.component(ofType: ActionAnimationComponent.self)?.runAnimation(withName: "scaleAndFade",
                                                                                    orderType: .parallel,
                                                                                    onCompletion: {self.resetToLastPosition()})
            default:
                break
            }
        }
        
        
    }
    
    override func onContactEnd(contact: MGPhysicsContact) {
    }
    
    
}
