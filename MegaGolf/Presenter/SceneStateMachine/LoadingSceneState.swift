//
//  LoadingScreenState.swift
//  MegaGolf
//
//  Created by Haakon Svane on 23/03/2021.
//

import GameKit

class LoadingSceneState : MGSceneState {
    override init(){
        super.init()
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is MenuSceneState.Type || stateClass is GameSceneState.Type
    }
    
    override func didEnter(from previousState: GKState?) {
        let sMach = (self.stateMachine as! MGSceneStateMachine)
        let scn = MGLoadingScene(size: sMach.manager!.sceneSize)
        scn.managingState = self
        sMach.currentScene = scn
    }
}
