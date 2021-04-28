//
//  GCValidateViewState.swift
//  MegaGolf
//
//  Created by Haakon Svane on 31/03/2021.
//

import GameKit

class GCValidateViewState : MGViewState{

    init(viewSize: CGSize){
        super.init(viewType: GCValidateView.self, viewSize: viewSize)
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is MainMenuViewState.Type || stateClass is MultiplayerViewState.Type
    }
    
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
        showLoginAlert()
    }
    
    private func showLoginAlert(){
        associatedView!.elements.forEach{
            if $0.getNode()!.name!.starts(with: "login"){
                $0.getNode()!.isHidden = false
            }else{
                $0.getNode()!.isHidden = true
            }
        }
    }
    private func showErrorAlert(){
        associatedView!.elements.forEach{
            if $0.getNode()!.name!.starts(with: "error"){
                $0.getNode()!.isHidden = false
            }else{
                $0.getNode()!.isHidden = true
            }
        }
    }
    
    private func showWaitingAlert(){
        associatedView!.elements.forEach{
            if $0.getNode()!.name!.starts(with: "waiting"){
                $0.getNode()!.isHidden = false
            }else{
                $0.getNode()!.isHidden = true
            }
        }
    }
    
    func GCSignInClick(){
        let man = (stateMachine as! MGViewStateMachine).manager
        
        if !man!.delegate!.isGCAuthenticated(){
            showWaitingAlert()
            man!.delegate!.requestGCLoginView()
        }
    }
    
    func backClick(){
        _ = self.stateMachine?.enter(MainMenuViewState.self)
    }
    
    func onNotifyValidationSuccess(success: Bool){
        if !success{
            showErrorAlert()
        }else{
            // When the login is complete, present the multiplayer view.
            // The back button should refer to the main menu state and not the Game Center validate state.
            let prevState = (self.stateMachine as! MGViewStateMachine).previousState
            if !(self.stateMachine?.enter(MultiplayerViewState.self) ?? false){
                print("Failed to enter Multiplayer state")
            }else{
                (self.stateMachine as! MGViewStateMachine).previousState = prevState
            }
        }
    }
    
}
