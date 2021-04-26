//
//  MenuSceneLevelsFactory.swift
//  MegaGolf
//
//  Created by Haakon Svane on 07/04/2021.
//

import GameKit

enum MenuSceneLevelsFactory {
    private static let data : [MGSolarSystem] = MGLevelPropertiesParser().getLevelsData()
    
    static var numSystems : Int {
        get{
            return data.count
        }
    }
    
    static func getSystemByID(_ id : Int) -> MGSolarSystem? {
        return data.first(where: {$0.ID  == id})
    }
    
    static func getSystemByName(_ name : String) -> MGSolarSystem? {
        return data.first(where: {$0.name  == name})
    }
    
    static func getNumLevelsInSystem(withID: Int) -> Int? {
        return getSystemByID(withID)?.levels.count
    }
    
    static func getNumLevelsInSystem(withName: String) -> Int? {
        return getSystemByName(withName)?.levels.count
    }
    
    private static func makeSystem(_ sys : MGSolarSystem) -> SolarSystemEntity {
        let system : SolarSystemEntity = SolarSystemEntity()
        
        // Add the star to the system
        let starRad = sys.systemStar.radius
        let starAngVel = sys.systemStar.angularVelocity
        let star = sys.systemStar.type.makeStar(radius: starRad, angularVelocity: starAngVel)
        star.component(ofType: GravityComponent.self)?.showField = false
        system.getNode()?.addChild(star)
        system.component(ofType: DataStoreComponent.self)?.data = ["systemID" : sys.ID, "systemName" : sys.name]
        
        // Sort the levels on their ID
        let sysSorted = sys.levels.sorted(by: {$0.levelID < $1.levelID})
        
        // Initial radius of the first planet in orbit around the sun
        var rad = starRad + 300
        
        // Traverse each level in reverse order so that the outer levels refer to the first.
        for lvl in sysSorted.reversed() {
            let lvlEnt = lvl.levelVisualMaker()
            lvlEnt.getNode()!.position = CGPoint(angle: CGFloat.random(in: 0...2*CGFloat.pi))*rad
            lvlEnt.component(ofType: OrbitComponent.self)?.orbitAround(entity: star, overrideSpeed: 200)
            lvlEnt.component(ofType: OrbitComponent.self)?.showingOrbitLine = true
            lvlEnt.component(ofType: DataStoreComponent.self)?.data = ["levelID" : lvl.levelID, "levelName" : lvl.levelName]
            
            let labels = lvlEnt.component(ofType: LabelComponent.self)?.labels
            labels?.setText(text: lvl.levelName, locator: .all)
            labels?.shadow(option: true, locator: .all)
            labels?.setSize(size: 70, locator: .all)
            labels?.position.y = 150
            labels?.zPosition = 2
            lvlEnt.component(ofType: ActionAnimationComponent.self)?.runAnimation(withName: "hide", orderType: .parallel, target: labels)
            rad += 500
            system.getNode()?.addChild(lvlEnt)
        }
        
        
        return system
    }
    
    static func makeSystemWithID(_ id: Int) -> SolarSystemEntity {
        guard let sys = getSystemByID(id) else {
            fatalError("No MGSolarSystem was found with id: \(id)")
        }
        return makeSystem(sys)
    }
    
    static func makeSystemWithName(_ name: String) -> SolarSystemEntity {
        guard let sys = getSystemByName(name) else {
            fatalError("No MGSolarSystem was found with name: \(name)")
        }
        return makeSystem(sys)
    }
}
