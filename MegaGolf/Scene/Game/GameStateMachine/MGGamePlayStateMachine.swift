//
//  MGGamePlayStateMachine.swift
//  MegaGolf
//
//  Created by Haakon Svane on 25/03/2021.
//

import GameKit


class MGGamePlayStateMachine : GKStateMachine{
    weak var parentScene: MGGameScene?

    
    init(scene: MGGameScene, states: [MGGamePlayState]) {
        self.parentScene = scene
        super.init(states: states)
        states.forEach{
            $0.ball = parentScene?.ball
            $0.goal = parentScene?.goal
        }
    }
    
    func notifyContactBegan(contact: MGPhysicsContact){
        (self.currentState as? MGGamePlayState)?.onContactBegin(contact: contact)
    }
    
    func notifyContactEnd(contact: MGPhysicsContact){
        (self.currentState as? MGGamePlayState)?.onContactEnd(contact: contact)
    }
}
