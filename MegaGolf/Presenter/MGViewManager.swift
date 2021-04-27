//
//  MGViewManager.swift
//  MegaGolf
//
//  Created by Haakon Svane on 22/03/2021.
//

import GameKit

class MGViewManager{
    private var viewStateMachine : MGViewStateMachine?
    weak var delegate : MGManagerDelegate?
    let viewSize: CGSize
    weak var currentView: MGView? {
        return (viewStateMachine?.currentState as? MGViewState)?.associatedView
    }
    
    var currentState : MGViewState? {
        get {
            guard let state = viewStateMachine?.currentState as? MGViewState else {return nil}
            return state
        }
    }
    
    init(presenter: MGPresenter, viewSize: CGSize){
        self.delegate = presenter
        self.viewSize = viewSize
    }
    
    func loadMenuViews(){
        viewStateMachine = nil
        let menuState = MainMenuViewState(viewSize: self.viewSize)
        let levelState = LevelSelectViewState(viewSize: self.viewSize)
        let settingsState = SettingsViewState(viewSize: self.viewSize)
        let multiState = MultiplayerViewState(viewSize: self.viewSize)
        let validateState = GCValidateViewState(viewSize: self.viewSize)
        let lobbyState = MultiplayerLobbyViewState(viewSize: self.viewSize)

        self.viewStateMachine = MGViewStateMachine(manager: self, states: [menuState, levelState, settingsState, multiState, validateState, lobbyState])
    }
    
    func loadGameViews(){
        viewStateMachine = nil
        let gameState = GameViewState(viewSize: self.viewSize)
        let gamePauseState = GamePausedViewState(viewSize: self.viewSize)
        let gameResultState = GameResultViewState(viewSize: self.viewSize)
        let settingsState = SettingsViewState(viewSize: self.viewSize)
        self.viewStateMachine = MGViewStateMachine(manager: self, states: [gameState, gamePauseState, gameResultState, settingsState])
    }
    
    func canEnterState(_ state: MGViewState.Type) -> Bool {
        guard let sMach = viewStateMachine else {return false}
        return sMach.canEnterState(state)
    }
    
    func requestStateChange(to state: MGViewState.Type) -> Bool {
        guard let sMach = viewStateMachine else {return false}
        if !sMach.enter(state) {
            print("Failed to enter state of type " + String(describing: state))
            return false
        }
        return true
    }
    
    
    func requestAddToScene(view: MGView){
        delegate?.addViewToCurrentScene(view, isGUI: true)
    }
    
    func requestRemoveFromScene(view: MGView){
        delegate?.removeViewFromCurrentScene(view)
    }
    
    func enterPreviousState(){
        guard let prev = viewStateMachine?.previousState else {
            return
        }
        if !(viewStateMachine?.enter(type(of: prev)) ?? false){
            print("Failed to enter previous state.")
        }
    }
    
    
    func loginComplete(success: Bool){
        if let state = currentState as? GCValidateViewState {
            state.onNotifyValidationSuccess(success: success)
        }
    }
    
    func exitLobby(){
        _ = requestStateChange(to: MultiplayerViewState.self)
        delegate?.disconnectFromMatch()
    }
    
    func requestTransmitLobbyData(data: MGLobbyData){
        delegate?.transmitData(data: MGOnlineMessageModel.lobbyStatus(data: data), with: .reliable)
    }
}
