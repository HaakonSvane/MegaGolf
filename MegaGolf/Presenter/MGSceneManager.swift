//
//  MGSceneManager.swift
//  MegaGolf
//
//  Created by Haakon Svane on 17/03/2021.
//

import GameKit

class MGSceneManager{
    

    private var sceneStateMachine: MGSceneStateMachine?
    weak var delegate: MGManagerDelegate?
    let sceneSize: CGSize
    var currentScene: MGScene? {
        get{
            return sceneStateMachine?.currentScene
        }
    }
    
    var currentState : MGSceneState? {
        get{
            guard let state = sceneStateMachine?.currentState as? MGSceneState else {return nil}
            return state
        }
    }
    

    init(presenter: MGPresenter, sceneSize: CGSize){
        self.delegate = presenter
        self.sceneSize = sceneSize
        
        let menuState = MenuSceneState()
        let loadState = LoadingSceneState()
        let gameState = GameSceneState()
        
        sceneStateMachine = MGSceneStateMachine(manager: self, states: [menuState, loadState, gameState])
    }
    
    func requestStateChange(to state: MGSceneState.Type) -> Bool {
        guard let sMach = sceneStateMachine else {return false}
        if !sMach.enter(state) {
            print("Failed to enter state of type " + String(describing: state))
            return false
        }
        return true
    }
    
    func sceneValueChange(value: MGSceneValueChange){
        delegate?.onNotifySceneValueChange(val: value)
    }
    
    func loadLevel(sysID: Int, lvlID: Int, onlineMatch: GKMatch?){
        // Entering the debug level if the system ID is zero.
        let lvlName = (sysID == 0) ?  "DEBUG" : "\(sysID)_\(lvlID)"
        let cls = Bundle.main.classNamed("MegaGolf.Level_"+lvlName) as? MGLevelSceneProtocol.Type
        guard let lvl = cls else {
            fatalError("Could not retrieve level with systemID: \(sysID), levelID: \(lvlID).")
        }
        guard let MGlvl = lvl.init(viewSize: self.sceneSize, onlineMatch: onlineMatch) as? MGScene else {
            fatalError("The level with systemID: \(sysID), levelID: \(lvlID) could not be interpreted as an MGScene. Are you inheriting properly?")
        }
        sceneStateMachine?.currentScene = MGlvl
    }
}
