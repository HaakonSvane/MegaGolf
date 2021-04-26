//
//  MenuState.swift
//  MegaGolf
//
//  Created by Haakon Svane on 22/03/2021.
//

import GameKit

class MenuSceneState : MGSceneState {
    override init() {
        super.init()
    }

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is LoadingSceneState.Type
    }
    
    override func didEnter(from previousState: GKState?) {
        let sMach = (self.stateMachine as! MGSceneStateMachine)
        let scn = MGMenuScene(size: sMach.manager!.sceneSize)
        scn.managingState = self
        sMach.currentScene = scn
    }
}
