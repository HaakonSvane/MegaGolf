//
//  MGGameScene.swift
//  MegaGolf
//
//  Created by Haakon Svane on 23/03/2021.
//

import GameKit

protocol MGLevelSceneProtocol {
    init(viewSize : CGSize, onlineMatch: GKMatch?)
}

enum MGHazardType {
    case outOfBounds
    case water
}

class MGGameScene : MGScene, SKPhysicsContactDelegate{
    private weak var onlineMatch : GKMatch?
    
    let bounds: CGRect
    let playerStartPos: CGPoint
    private var stateMachine: MGGamePlayStateMachine?
    
    let ball: GolfBallEntity
    private(set) var onlineBalls : [GhostGolfBallEntity]
    let goal: BlackHoleEntity
    var time: TimeInterval {
        didSet{
            guard let state = (managingState as? GameSceneState) else {return}
            state.updateGameTime(time)
        }
    }
    let sceneLight: MGLightEntity
    let cameraDeadZoneFactor = CGRect(x:0.25 , y: 0.25, width: 0.08, height: 0.3)
    
    let levelPar: Int
    var currentShots: Int {
        didSet{
            guard let gState = (self.managingState as? GameSceneState) else{
                return
            }
            gState.setShotsMade(currentShots)
        }
    }
    
    init(viewSize: CGSize, gameBounds: CGRect, playerStartPos : CGPoint, goalPos: CGPoint, goalRadius: CGFloat, levelPar: Int, onlineMatch: GKMatch?){
        self.bounds = gameBounds
        self.playerStartPos = playerStartPos
        
        // Initializing the game invariants (ball, goal and lights)
        self.ball = GameObjectFactory.makeGolfBall(type: .normal)
        self.goal = GameObjectFactory.makeBlackHole(radius: goalRadius, gravityRadiusFactor: 0.7)
        self.sceneLight = GameObjectFactory.makeSceneLight()
        
        // Initializing the game scoring (current shots made and level par)
        self.currentShots = 0
        self.levelPar = levelPar
        self.onlineBalls = []
        self.onlineMatch = onlineMatch
        self.time = 0
        
        super.init(size: viewSize)
        
        // Physics initialization
        self.backgroundColor = GLOBALCOLOR.SKY ?? GLOBALCOLOR.DEFAULT
        self.physicsWorld.gravity = .zero
        self.physicsWorld.contactDelegate = self
        
        // Setting entity positions and initializing the game bounds
        let boundsEnt = GameBoundsEntity(rect: gameBounds)
        ball.getNode()?.position = playerStartPos
        goal.getNode()?.position = goalPos
        sceneLight.getNode()?.position.x = viewSize.width*0.6
        
        // Adding all entities to the scene...
        self.addEntity(boundsEnt)
        self.addEntity(ball)
        self.addEntity(goal)
        self.addEntity(sceneLight)
        
        // ...and their nodes
        self.addChild(boundsEnt.getNode()!, isGUI: false)
        self.addChild(ball.getNode()!, isGUI: false)
        self.addChild(goal.getNode()!, isGUI: false)
        self.addChild(sceneLight.getNode()!, isGUI: false)
        
        // Set up camera
        (self.camera as! MGCameraNode).deadZoneFactor = self.cameraDeadZoneFactor
        (self.camera as! MGCameraNode).followEntity(ball)
        
        // Initializing states and entering the aiming state of the gameplay
        let aimState = MGAimingGameState()
        let launchState = MGLaunchingGameState()
        self.stateMachine = MGGamePlayStateMachine(scene: self, states: [aimState, launchState])
        self.stateMachine?.enter(MGAimingGameState.self)
        
        let sky = StarSkyEntity(size: self.bounds.size, camera: (self.camera as! MGCameraNode))
        entities.append(sky)
        self.addChild(sky.getNode()!, isGUI: false)
        
        if let match = onlineMatch {
            for p in match.players{
                let b = GameObjectFactory.makeGhostGolfBall(type: .normal, ballName: p.alias)
                b.getNode()?.name = p.gamePlayerID
                self.addChild(b.getNode()!, isGUI: false)
                entities.append(b)
                onlineBalls.append(b)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        // Initialize lastUpdateTime if it has not already been
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        
        // Calculate time since last update
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        (self.camera as! MGCameraNode).update(deltaTime: dt)
        self.stateMachine?.update(deltaTime: dt)
        
        sceneLight.getNode()?.position = ball.getNode()!.position + (goal.getNode()!.position-ball.getNode()!.position).normalized()*self.size.width*0.6
        
        self.transmitGameData()
        self.time += dt
        
        self.lastUpdateTime = currentTime
    
    }
    
    // Since the UI views are added after scene initialization, the level par value must be set after scene initialization.
    // This function is called whenever the scene is actually presented.
    override func didMove(to view: SKView) {
        guard let gState = (self.managingState as? GameSceneState) else{
            return
        }
        gState.setLevelPar(levelPar)
        self.time = 0
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        stateMachine?.notifyContactBegan(contact: MGPhysicsContact(contact: contact))
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        stateMachine?.notifyContactEnd(contact: MGPhysicsContact(contact: contact))
    }
    
    func didEnterHazard(type: MGHazardType){
        guard let gState = (self.managingState as? GameSceneState) else{
            return
        }
        gState.didEnterHazard(type: type)
    }
    
    func didEnterGoal(){
        guard let gState = (self.managingState as? GameSceneState) else{
            return
        }
        gState.didEnterGoal(shots: currentShots, par: levelPar)
    }
    
    func transmitGameData(){
        guard onlineMatch != nil else{return}
        guard let gState = (self.managingState as? GameSceneState) else{
            return
        }
        gState.transmitData(data: MGGameData(pos: ball.getNode()!.position, vel: ball.getPhysicsBody()!.velocity))
    }
    
    func onReceiveGameData(player: GKPlayer, data: MGGameData){
        let ob = onlineBalls.first(where: {$0.getNode()!.name == player.gamePlayerID})
        ob?.getNode()?.position = data.pos
        ob?.getPhysicsBody()?.velocity = data.vel
    }
    
    func followGoal(){
        (self.camera as! MGCameraNode).deadZoneFactor = CGRect(x: 1/2, y: 1/2, width: 2/size.width, height: 2/size.height)
        (self.camera as! MGCameraNode).followEntity(goal)
    }
    
    func followBall(){
        (self.camera as! MGCameraNode).deadZoneFactor = self.cameraDeadZoneFactor
        (self.camera as! MGCameraNode).followEntity(ball)
    }
    
    func followEntity(_ entity : GKEntity){
        (self.camera as! MGCameraNode).followEntity(entity)
    }
    
}

class MGPhysicsContact {
    var bodyA: SKPhysicsBody
    var bodyB: SKPhysicsBody
    var collisionImpulse: CGFloat
    var contactPoint: CGPoint
    var contactNormal: CGVector
    
    init(contact: SKPhysicsContact){
        self.bodyA = contact.bodyA
        self.bodyB = contact.bodyB
        self.collisionImpulse = contact.collisionImpulse
        self.contactPoint = contact.contactPoint
        self.contactNormal = contact.contactNormal
    }
    
    func contains(_ entity: GKEntity?) -> Bool{
        return (bodyA.node as? MGNode)?.parentEntity === entity || (bodyB.node as? MGNode)?.parentEntity === entity
    }
    
    var planet: MGPlanetEntity?{
        get{
            if let ent = ((bodyA.node as? MGNode)?.parentEntity as? MGPlanetEntity) {
                return ent
            }
            if let ent = ((bodyB.node as? MGNode)?.parentEntity as? MGPlanetEntity) {
                return ent
            }
            return nil
        }
    }
    var blackHole: BlackHoleEntity? {
        get{
            if let ent = ((bodyA.node as? MGNode)?.parentEntity as? BlackHoleEntity) {
                return ent
            }
            if let ent = ((bodyB.node as? MGNode)?.parentEntity as? BlackHoleEntity) {
                return ent
            }
            return nil
        }
    }
}
