//
//  GameSceneState.swift
//  MegaGolf
//
//  Created by Haakon Svane on 22/03/2021.
//

import GameKit

class GameSceneState : MGSceneState {
    override init() {
        super.init()
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is LoadingSceneState.Type
    }
    
    override func didEnter(from previousState: GKState?) {
        let sMach = (self.stateMachine as! MGSceneStateMachine)
        sMach.currentScene?.managingState = self
    }
    
    func updateGameTime(_ time: TimeInterval){
        let man = (stateMachine as! MGSceneStateMachine).manager
        man?.sceneValueChange(value: .gameTime(time))
    }
    
    func setShotsMade(_ value: Int){
        let man = (stateMachine as! MGSceneStateMachine).manager
        man?.sceneValueChange(value: .golfShots(value))
    }
    
    func setLevelPar(_ value: Int){
        let man = (stateMachine as! MGSceneStateMachine).manager
        man?.sceneValueChange(value: .gamePar(value))
    }
    
    func didEnterHazard(type: MGHazardType){
        let man = (stateMachine as! MGSceneStateMachine).manager
        man?.sceneValueChange(value: .enteredHazard(type))
    }
    
    func didEnterGoal(shots: Int, par: Int){
        let man = (stateMachine as! MGSceneStateMachine).manager
        man?.sceneValueChange(value: .enteredGoal(shots: shots, par: par))
    }
    
    func transmitData(data: MGGameData){
        let man = (stateMachine as! MGSceneStateMachine).manager
        man?.delegate?.transmitData(data: MGOnlineMessageModel.gameData(data: data), with: .unreliable)
    }
    
    func onReceiveData(player: GKPlayer, data: MGGameData){
        guard let gScn = (stateMachine as? MGSceneStateMachine)?.currentScene as? MGGameScene else{return}
        gScn.onReceiveGameData(player: player, data: data)
    }
}
