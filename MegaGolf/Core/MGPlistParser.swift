//
//  MGPlistParser.swift
//  MegaGolf
//
//  Created by Haakon Svane on 15/03/2021.
//
import UIKit
import GameKit

class MGPlistParser {
    var data : [String : AnyObject]
    
    init(fileName : String){
        self.data = [:]
        var format = PropertyListSerialization.PropertyListFormat.xml
        guard let path = Bundle.main.path(forResource: fileName, ofType: "plist") else {
            fatalError("Failed to find plist with name \(fileName) due to an error!")
        }
        guard let loadedData = FileManager.default.contents(atPath: path) else {
            fatalError("Failed to load plist with name \(fileName) due to an error!")
        }
        do {
            self.data = try PropertyListSerialization.propertyList(from: loadedData, options: .mutableContainersAndLeaves, format: &format) as! [String:AnyObject]
            } catch {
                print("Error reading plist: \(error), format: \(format)")
            }
    }
}

class MGColorPlistParser : MGPlistParser {
    static let FILENAME = "Colors"
    
    init(){
        super.init(fileName: MGColorPlistParser.FILENAME)
    }
    
    func entryToUIColor(entryName : String) -> UIColor{
        guard let ent = data[entryName] as? Dictionary<String, AnyObject> else {
            fatalError("Could not find entry named '\(entryName)' in \(MGColorPlistParser.FILENAME).plist.")
        }
        guard let cHexString = ent["hex"] as? String else {
            fatalError("Could not find hex value in entry.")
        }
        guard let aHexString = ent["alpha"] as? String else{
            fatalError("Could not find alpha value in entry.")
        }
        let chex = cHexString.replacingOccurrences(of: "#", with: "")
        let ahex = aHexString.replacingOccurrences(of: "#", with: "")
        
        guard let hexInt = UInt32(chex, radix: 16) else {
            fatalError("Could not convert \(cHexString) to UInt32. Please check this value.")
        }
        guard let alphaInt = UInt32(ahex, radix: 16) else {
            fatalError("Could not convert \(aHexString) to UInt32. Please check this value.")
        }
        return UIColor(hex: hexInt, a: alphaInt)
    }
}

class MGDefaultPropertiesParser : MGPlistParser {
    static let FILENAME = "DefaultProperties"
    init(){
        super.init(fileName: MGDefaultPropertiesParser.FILENAME)
    }
    
}

class MGPlanetPropertiesParser : MGPlistParser {
    static let FILENAME = "MGPlanetProperties"
    init(){
        super.init(fileName: MGPlanetPropertiesParser.FILENAME)
    }
    func getPlanetConfiguration(planetEntityName: String) -> MGPlanetConfiguration{
        guard let planet = data[planetEntityName] as? Dictionary<String, AnyObject> else{
            fatalError("Could not find planet configuration for \(planetEntityName). Does it have an entry in MGPlanetProperties.plist?")
        }
        guard let density = planet["density"] as? CGFloat else{
            fatalError("Could not find property 'density' for \(planetEntityName) in MGPlanetProperties.plist.")
        }
        guard let kineticFriction = planet["kinetic friction"] as? CGFloat else{
            fatalError("Could not find property 'kinetic friction' for \(planetEntityName) in MGPlanetProperties.plist.")
        }
        guard let staticFriction = planet["static friction"] as? CGFloat else{
            fatalError("Could not find property 'static friction' for \(planetEntityName) in MGPlanetProperties.plist.")
        }
        guard let restitution = planet["restitution"] as? CGFloat else{
            fatalError("Could not find property 'restitution' for \(planetEntityName) in MGPlanetProperties.plist.")
        }
        return MGPlanetConfiguration(density: density, kineticFriction: kineticFriction, staticFriction: staticFriction, restitution: restitution)
    }
}

class MGLevelPropertiesParser : MGPlistParser {
    static let FILENAME = "MGLevelProperties"
    
    private static let makerStringToFunction : [String: ()->LevelEntity] = [
        "fieldAndMoon" : LevelDesignFactory.fieldAndMoon,
        "bunkerAndTwoMoons" : LevelDesignFactory.bunkerAndTwoMoons,
        "waterAndField" : LevelDesignFactory.waterAndField
    ]
    
    private static let starStringToEnum : [String : MGStarType] = [
        "RedStar" : .redStar,
        "YellowStar" : .yellowStar,
        "BlackHole" : .blackHole
    ]
    
    init(){
        super.init(fileName: MGLevelPropertiesParser.FILENAME)
    }
    
    func getLevelsData() -> [MGSolarSystem] {
        var systems : [MGSolarSystem] = []
        for systemName in data.keys {
            guard let system = data[systemName] as? Dictionary<String, AnyObject> else{
                fatalError("Could not interpret value with key " + systemName + " as Dictionary<String, AnyObject> in LevelProperties.plist")
            }
            guard let id = system["systemID"] as? Int else {
                fatalError("Could not interpret value with key 'systemID' as Int for " + systemName + " in LevelProperties.plist")
            }
            guard let name = system["name"] as? String else {
                fatalError("Could not interpret value with key 'name' as String for " + systemName + " in LevelProperties.plist")
            }
            guard let levelDict = system["levels"] as? Dictionary<String, AnyObject> else {
                fatalError("Could not interpret value with key 'levels' as Dictionary<String, AnyObject> for " + systemName + " in LevelProperties.plist")
            }
            guard let starDict = system["systemStar"] as? Dictionary<String, AnyObject> else {
                fatalError("Could not interpret value with key 'systemStar' as Dictionary<String, AnyObject> for " + systemName + " in LevelProperties.plist")
            }
            guard let starRad = starDict["radius"] as? CGFloat else {
                fatalError("Could not interpret value with key 'radius' as CGFloat for " + systemName + "/systemStar in LevelProperties.plist")
            }
            guard let starAngVel = starDict["angularVelocity"] as? CGFloat else {
                fatalError("Could not interpret value with key 'angularVelocity' as CGFloat for " + systemName + "/systemStar in LevelProperties.plist")
            }
            guard let starTypeString = starDict["type"] as? String else {
                fatalError("Could not interpret value with key 'type' as String for " + systemName + "/systemStar in LevelProperties.plist")
            }
            guard let starType = MGLevelPropertiesParser.starStringToEnum[starTypeString] else {
                fatalError("Could not find enum mapping for key '" + starTypeString + "' in MGLevelPropertiesParser.starStringToEnum for " + systemName + " in LevelProperties.plist")
            }
            
            var levels : [MGLevelSystem] = []
            for levelKey in levelDict.keys {
                guard let level = levelDict[levelKey] as? Dictionary<String, AnyObject> else{
                    fatalError("Could not interpret value with key " + levelKey + " for " + systemName + " as Dictionary<String, AnyObject> in LevelProperties.plist")
                }
                guard let levelName = level["name"] as? String else {
                    fatalError("Could not interpret value with key 'name' as String for " + systemName + "/" + levelKey + " in LevelProperties.plist")
                }
                guard let levelID = level["levelID"] as? Int else {
                    fatalError("Could not interpret value with key 'levelID' as Int for " + systemName + "/" + levelKey + " in LevelProperties.plist")
                }
                guard let makerName = level["levelEntityType"] as? String else {
                    fatalError("Could not interpret value with key 'levelEntityType' as String for " + systemName + "/" + levelKey + " in LevelProperties.plist")
                }
                guard let makerFunc = MGLevelPropertiesParser.makerStringToFunction[makerName] else{
                    fatalError("Could not find maker funtion with key '" + makerName + "' in MGLevelPropertiesParser.makerStringToFunction for " + systemName + "/" + levelKey + " in LevelProperties.plist")
                }
                levels.append(
                    MGLevelSystem(levelID: levelID,
                                  levelName: levelName,
                                  levelVisualMaker: makerFunc))
            }
            systems.append(
                MGSolarSystem(ID: id,
                              name: name,
                              systemStar: MGSolarSystemStar(type: starType,
                                                                radius: starRad,
                                                                angularVelocity: starAngVel),
                              levels: levels))
        }
        return systems
    }
}
