//
//  MGMenuScene.swift
//  MegaGolf
//
//  Created by Haakon Svane on 22/03/2021.
//

import SpriteKit

fileprivate typealias anim = MGAnimation

class MGMenuScene : MGScene {
    
    private var systems : [(SolarSystemEntity, [LevelEntity])]
    private let music : MGMusicEntity
    
    override init(size: CGSize) {
        systems = []
        music = MGMusicEntity(songNamed: "mainMenuTheme.mp3")
        
        super.init(size: size)
        (self.camera as? MGCameraNode)?.cameraSpeed = 50
        (self.camera as? MGCameraNode)?.deadZoneFactor = CGRect(x: 1/2, y: 3/5, width: 2/size.width, height: 2/size.height)
        self.backgroundColor = GLOBALCOLOR.SKY ?? GLOBALCOLOR.DEFAULT
        
        let sky = StarSkyEntity(size: CGSize(width: 1000, height: 1000), camera: (self.camera as! MGCameraNode))
        entities.append(sky)
        self.addChild(sky.getNode()!, isGUI: false)
        
        
        entities.append(music)
        self.addChild(music.getNode()!, isGUI: false)
        
        for i in 1...MenuSceneLevelsFactory.numSystems {
            let sys = MenuSceneLevelsFactory.makeSystemWithID(i)
            // Adding the child entities in the SolarSystemEntity (LevelEntity and StarEntity)
            sys.getNode()?.childEntities.forEach{self.entities.append($0)}
            
            // Filter all the child entities of type LevelEntity to a new array. This array contains all the LevelEntity instances for the SolarSystemEntity.
            var levels : [LevelEntity] = sys.getNode()?.childEntities.filter{($0 as? LevelEntity) != nil} as! [LevelEntity]
            levels.reverse()
            // Adding all the child entities in each LevelEntity (These are of type MGPlanetEntity)
            levels.forEach{ lvl in
                lvl.getNode()?.childEntities.forEach{self.entities.append($0)}
            }
            
            sys.getNode()?.position.x = CGFloat((i-1)*10000)
            
            systems.append((sys, levels))
            self.addChild(sys.getNode()!, isGUI: false)
        }

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(_ currentTime: TimeInterval){
        // Called before each frame is rendered
        
        // Initialize _lastUpdateTime if it has not already been
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
        
        self.lastUpdateTime = currentTime

    }
    
    override func didMove(to view: SKView) {
        for ent in self.entities{
            if let sComp = ent.component(ofType: SpriteComponent.self){
                if sComp.isAnimated {sComp.runAnimation()}
            }
        }
    }
    
    func getLevelEntityByID(sysID: Int, lvlID: Int) -> LevelEntity?{
        guard sysID <= MenuSceneLevelsFactory.numSystems else {
            return nil
        }
        guard lvlID <= MenuSceneLevelsFactory.getNumLevelsInSystem(withID: sysID)! else {
            return nil
        }
        return (self.systems[sysID-1].1)[lvlID-1]
    }
    
    func getSystemEntityByID(_ ID : Int) -> SolarSystemEntity? {
        guard ID <= MenuSceneLevelsFactory.numSystems else {
            return nil
        }
        return systems[ID-1].0
    }
    
    func focusOnLevelEntity(sysID: Int, lvlID: Int){
        let ent = getLevelEntityByID(sysID: sysID, lvlID: lvlID)
        let cam = (self.camera as? MGCameraNode)
        let labels = ent?.component(ofType: LabelComponent.self)?.labels
        
        cam?.followEntity(ent)
        cam?.run(anim.scaleSmooth(to: 1.7, duration: 0.7))
        ent?.component(ofType: ActionAnimationComponent.self)?.runAnimation(withName: "fadeIn", orderType: .parallel, target: labels)
        
    }
    
    func unfocusOnLevelEntity(sysID: Int, lvlID: Int, scaleBackTo: CGFloat? = nil, moveToPos: CGPoint? = nil){
        let ent = getLevelEntityByID(sysID: sysID, lvlID: lvlID)
        let cam = (self.camera as? MGCameraNode)
        let labels = ent?.component(ofType: LabelComponent.self)?.labels
        
        cam?.stopFollowing()
        ent?.component(ofType: ActionAnimationComponent.self)?.runAnimation(withName: "fadeOut", orderType: .parallel, target: labels)
        
        guard let scaleBackTo = scaleBackTo, let moveToPos = moveToPos else {
            return
        }
        cam?.run(SKAction.group([anim.scaleSmooth(to: scaleBackTo, duration: 0.7), anim.moveSmoothTo(to: moveToPos, duration: 0.5)]))
    }
}
