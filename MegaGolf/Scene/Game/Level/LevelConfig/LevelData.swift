//
//  LevelData.swift
//  MegaGolf
//
//  Created by Haakon Svane on 07/04/2021.
//


import GameKit


enum MGStarType {
    case redStar
    case yellowStar
    case blackHole
    
    func makeStar(radius: CGFloat, angularVelocity: CGFloat) -> GKEntity {
        switch self {
        case .redStar:
            return GameObjectFactory.makeRedStar(radius: radius, gravityRadiusFactor: 1, angularVelocity: angularVelocity)
        case .yellowStar:
            return GameObjectFactory.makeYellowStar(radius: radius, gravityRadiusFactor: 1, angularVelocity: angularVelocity)
        case .blackHole:
            return GameObjectFactory.makeBlackHole(radius: radius, gravityRadiusFactor: 1)
        }
    }
}

struct MGSolarSystem {
    let ID : Int
    let name : String
    let systemStar : MGSolarSystemStar
    let levels : [MGLevelSystem]
}

struct MGSolarSystemStar{
    let type : MGStarType
    let radius : CGFloat
    let angularVelocity : CGFloat
}

struct MGLevelSystem {
    let levelID : Int
    let levelName : String
    let levelVisualMaker : () -> LevelEntity
}

