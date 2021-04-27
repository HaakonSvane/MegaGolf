//
//  GameResultViewState.swift
//  MegaGolf
//
//  Created by Haakon Svane on 06/04/2021.
//

import GameKit

fileprivate typealias anim = MGAnimation

class GameResultViewState : MGViewState{
    init(viewSize: CGSize){
        super.init(viewType: GameResultView.self, viewSize: viewSize)
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        // No need to make the menu view states available since the state machine will be reset if the player exits to the menus anyways.
        return stateClass is GameViewState.Type
    }
    
    func nextClick(){
        
    }
    
    func quitClick(){
        let man = (stateMachine as! MGViewStateMachine).manager
        associatedView?.run(anim.moveSmooth(by: CGVector(dx: 900, dy: 0), duration: 0.2), completion: man?.delegate?.loadMenus ?? {})
    }

}
