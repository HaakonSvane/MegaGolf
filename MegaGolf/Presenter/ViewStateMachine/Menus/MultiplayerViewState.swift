//
//  MultiplayerViewState.swift
//  MegaGolf
//
//  Created by Haakon Svane on 16/03/2021.
//

import GameplayKit

class MultiplayerViewState : MGViewState{
    
    init(viewSize: CGSize){
        super.init(viewType: MultiplayerView.self, viewSize: viewSize)
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is MainMenuViewState.Type || stateClass is MultiplayerLobbyViewState.Type
    }
    
    override func didEnter(from previousState: GKState?) {
        let man = (stateMachine as! MGViewStateMachine).manager
        man?.delegate?.showGCAccessWindow(true)
        super.didEnter(from: previousState)
    }
    
    override func willExit(to nextState: GKState) {
        let man = (stateMachine as! MGViewStateMachine).manager
        switch nextState {
        case is MainMenuViewState:
            super.willExit(to: nextState)
        default:
            man?.delegate?.showGCAccessWindow(false)
            super.willExit(to: nextState)
        }
    }
    
    func findClick(){
        let man = (stateMachine as! MGViewStateMachine).manager
        
        let viewController = man?.delegate?.prepareMatch()
        guard let vc = viewController else{
            print("failed to get viewcontroller for matchmaking")
            return
        }
        man?.delegate?.requestPresentController(viewController: vc)
    }
    
    func backClick(){
        let man = (stateMachine as! MGViewStateMachine).manager
        _ = man?.requestStateChange(to: MainMenuViewState.self)
    }
}
