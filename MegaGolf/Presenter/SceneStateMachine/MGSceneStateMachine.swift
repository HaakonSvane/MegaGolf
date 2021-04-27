//
//  MGSceneStateMachine.swift
//  MegaGolf
//
//  Created by Haakon Svane on 22/03/2021.
//

import GameKit

class MGSceneStateMachine : GKStateMachine {
    weak var manager : MGSceneManager?
    var currentScene : MGScene?
    
    init(manager: MGSceneManager, states: [MGSceneState]) {
        self.manager = manager
        super.init(states: states)
    }
}
