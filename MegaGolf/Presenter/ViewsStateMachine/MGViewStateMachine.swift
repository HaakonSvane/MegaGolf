//
//  MGViewsStateMachine.swift
//  MegaGolf
//
//  Created by Haakon Svane on 08/03/2021.
//

import GameKit

class MGViewStateMachine : GKStateMachine {
    weak var manager : MGViewManager?
    var previousState : GKState?
    
    init(manager: MGViewManager, states: [MGViewState]) {
        self.manager = manager
        super.init(states: states)
    }
    
    override func enter(_ stateClass: AnyClass) -> Bool {
        if self.previousState != self.currentState{
            self.previousState = self.currentState
        }
        return super.enter(stateClass)
    }
}
