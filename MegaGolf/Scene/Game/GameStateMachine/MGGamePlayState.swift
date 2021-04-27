//
//  MGGameState.swift
//  MegaGolf
//
//  Created by Haakon Svane on 26/03/2021.
//

import GameKit



class MGGamePlayState : GKState {
    weak var ball: GolfBallEntity?
    weak var goal: BlackHoleEntity?
    
    override init() {
        super.init()
    }
    
    func onContactBegin(contact: MGPhysicsContact){}
    func onContactEnd(contact: MGPhysicsContact){}
    
}
