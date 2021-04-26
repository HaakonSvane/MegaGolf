//
//  GamePausedViewState.swift
//  MegaGolf
//
//  Created by Haakon Svane on 24/03/2021.
//

import GameKit

class GamePausedViewState : MGViewState{
    init(viewSize: CGSize){
        super.init(viewType: GamePausedView.self, viewSize: viewSize)
    }

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is SettingsViewState.Type || stateClass is GameViewState.Type
    }
    
    func playClick(){
        if !(self.stateMachine?.enter(GameViewState.self) ?? false){
            print("Failed to enter game view state.")
        }
    }
    
    func gameExitClick(){
        let man = (stateMachine as! MGViewStateMachine).manager
        man?.delegate?.loadMenus()
    }
    
    func settingsClick(){
        if !(self.stateMachine?.enter(SettingsViewState.self) ?? false){
            print("Failed to enter settings state.")
        }
    }
}
