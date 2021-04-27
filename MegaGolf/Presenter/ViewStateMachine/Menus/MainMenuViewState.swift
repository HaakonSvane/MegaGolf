//
//  MainMenuViewState.swift
//  MegaGolf
//
//  Created by Haakon Svane on 16/03/2021.
//

import GameKit

fileprivate typealias anim = MGAnimation

class MainMenuViewState : MGViewState{
    init(viewSize: CGSize){
        super.init(viewType: MainMenuView.self, viewSize: viewSize)
    }
    
    override func isValidNextState(_ stateClass : AnyClass) -> Bool{
        return stateClass is SettingsViewState.Type
            || stateClass is LevelSelectViewState.Type
            || stateClass is MultiplayerViewState.Type
            || stateClass is GCValidateViewState.Type
    }
    
    override func didEnter(from previousState: GKState?) {
        let man = (stateMachine as! MGViewStateMachine).manager
        if man!.delegate!.isGCAuthenticated(){
            man!.delegate!.showGCAccessWindow(true)
        }
        
        man?.delegate?.getCurrentScene()?.camera?.run(
            SKAction.group([anim.scaleSmooth(to: 9, duration: 1), anim.moveSmooth(to: CGPoint(x: associatedView!.size.width*9/5, y: 0), duration: 1)])
        )

        // Hide the buttons
        associatedView?.isHidden = true
        
        // Add the buttons to the scene
        super.didEnter(from: previousState)
        
        // Move all buttons away from the screen
        associatedView!.elements.forEach{
            if type(of: $0) == MGUILabelButtonEntity.self {
                $0.component(ofType: ActionAnimationComponent.self)?.runAnimation(withName: "fastRight", orderType: .parallel)
            }else{
                $0.component(ofType: ActionAnimationComponent.self)?.runAnimation(withName: "fastLeft", orderType: .parallel)
            }
        }
        
        // Unhide them
        associatedView!.isHidden = false
        
        // Move them back into the screen smoothly
        associatedView!.elements.forEach{
            if type(of: $0) == MGUILabelButtonEntity.self {
                $0.component(ofType: ActionAnimationComponent.self)?.runAnimation(withName: "smoothLeft", orderType: .parallel)
            }else{
                $0.component(ofType: ActionAnimationComponent.self)?.runAnimation(withName: "smoothRight", orderType: .parallel)
            }
        }
        

    }
    
    override func willExit(to nextState: GKState) {
        let man = (stateMachine as! MGViewStateMachine).manager
        switch nextState{
        
        // Only hide the Game Center access window if the next state is not MultiPlayerState
        case is MultiplayerViewState:
            break
        default:
            man?.delegate!.showGCAccessWindow(false)
        }
        super.willExit(to: nextState)
    }
    
    func singlePlayerClick(){
        if !(self.stateMachine?.enter(LevelSelectViewState.self) ?? false){
            print("Failed to enter level select state.")
        }
    }
    
    func multiplayerClick(){
        let man = (stateMachine as! MGViewStateMachine).manager
        if man!.delegate!.isGCAuthenticated(){
            if !(self.stateMachine?.enter(MultiplayerViewState.self) ?? false){
                print("Failed to enter multiplayer state.")
            }
        }else{
            if !(self.stateMachine?.enter(GCValidateViewState.self) ?? false){
                print("Failed to enter Game Center validation state.")
            }
        }

    }
    
    func settingsClick(){
        if !(self.stateMachine?.enter(SettingsViewState.self) ?? false){
            print("Failed to enter settings state.")
        }
    }
    
}
