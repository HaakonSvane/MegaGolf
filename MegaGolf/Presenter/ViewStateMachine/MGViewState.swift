//
//  MGViewState.swift
//  MegaGolf
//
//  Created by Haakon Svane on 08/03/2021.
//

import GameKit

class MGViewState : GKState{
    var associatedView : MGView?
    
    init(viewType: MGView.Type, viewSize : CGSize) {
        super.init()
        associatedView = viewType.init(managingState: self, size: viewSize)
    }

    
    private func removeViewFromScene(){
        let man = (stateMachine as! MGViewStateMachine).manager
        man?.requestRemoveFromScene(view: associatedView!)
    }
    
    private func addViewToScene(){
        let man = (stateMachine as! MGViewStateMachine).manager
        man?.requestAddToScene(view: associatedView!)
    }
    
    override func didEnter(from previousState: GKState?) {
        associatedView?.alpha = 0
        addViewToScene()
        associatedView?.run(SKAction.fadeIn(withDuration: 0.1))
    }
    
    override func willExit(to nextState: GKState) {
        associatedView?.run(SKAction.fadeOut(withDuration: 0.1), completion: removeViewFromScene)
        associatedView?.alpha = 1
    }
    
    
}
