//
//  MultiplayerLobbyViewState.swift
//  MegaGolf
//
//  Created by Haakon Svane on 17/04/2021.
//

import GameKit

fileprivate typealias anim = MGAnimation

struct MGLobbyPlayerInfo {
    let text : SingleTextEntity
    let indicator : MGUIIndicatorEntity
    var isReady : Bool
    var selectedSystemID: Int
}

class MultiplayerLobbyViewState : MGViewState {
    private let camScaleToSelect : CGFloat = 13
    private let camScaleToStart : CGFloat = 7
    private var currentSystemID : Int
    private var playersInfo : [MGLobbyPlayerInfo]
    private var currentPlayers : [GKPlayer]
    private var numPlayersReady : Int
    
    init(viewSize: CGSize){
        currentSystemID = 1
        playersInfo = []
        currentPlayers = []
        numPlayersReady = 0
        super.init(viewType: MultiplayerLobbyView.self, viewSize: viewSize)
        
        for i in 1...8 {
            let tex = associatedView?.elements.first(where: {$0.getNode()!.name == "lobbyPlayer\(i)"}) as! SingleTextEntity
            let ind = associatedView?.elements.first(where: {$0.getNode()!.name == "lobbyIndicator\(i)"}) as! MGUIIndicatorEntity
            playersInfo.append(MGLobbyPlayerInfo(text: tex, indicator: ind, isReady: false, selectedSystemID: 1))
        }
        
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is MultiplayerViewState.Type || stateClass is SettingsViewState.Type
    }
    
    
    override func didEnter(from previousState: GKState?) {
        super.didEnter(from: previousState)
        
        let man = (stateMachine as! MGViewStateMachine).manager
        showLobbyLayout()
        man?.delegate?.getCurrentScene()?.camera?.run(anim.scaleSmooth(to: self.camScaleToSelect, duration: 1))
        moveCamToCurrentSystem()
        currentPlayers.append(GKLocalPlayer.local)
        self.updatePlayersInfo()
        self.handleButtonLayout()
    }
    
    override func willExit(to nextState: GKState) {
        switch nextState{
        case is SettingsViewState:
            super.willExit(to: nextState)
        default:
            super.willExit(to: nextState)
            self.currentPlayers = []
            self.resetPlayersInfo()
            self.currentSystemID = 1
        }
    }
    
    private func moveCamToCurrentSystem(){
        let man = (stateMachine as! MGViewStateMachine).manager

        let camPosX = associatedView!.size.width * self.camScaleToSelect * (0.4-0.17) + (CGFloat(self.currentSystemID)-1) * 10000
        man?.delegate?.getCurrentScene()?.camera?.run(anim.moveSmoothTo(to: CGPoint(x: camPosX, y: 0), duration: 0.5))
    }
    
    private func centerCamOnCurrentSystem(){
        let man = (stateMachine as! MGViewStateMachine).manager
        let camPos = CGPoint(x: (CGFloat(self.currentSystemID)-1) * 10000, y: 0)
        man?.delegate?.getCurrentScene()?.camera?.run(SKAction.group([
                                                                        anim.scaleSmooth(to: self.camScaleToStart, duration: 0.7),
                                                                        anim.moveSmoothTo(to: camPos, duration: 0.5)]))
    }
    
    private func resetPlayersInfo(){
        for (n, p) in self.playersInfo.enumerated(){
            self.playersInfo[n].isReady = false
            self.playersInfo[n].selectedSystemID = 1
            p.indicator.component(ofType: SpriteComponent.self)?.setTexture(textureName: "indicatorIconGreen")
            p.text.component(ofType: LabelComponent.self)?.labels.setText(text: DEFAULTPROPERTIES.DEFAULTPLAYERNAME ?? "_NAME_ERROR_", locator: .all)
        }
    }
    private func updatePlayersInfo(){
        var numPlayers = 0
        for (n, p) in currentPlayers.enumerated() {
            playersInfo[n].text.component(ofType: LabelComponent.self)?.labels.setText(text: p.alias, locator: .all)
            let texName = playersInfo[n].isReady ? "indicatorIconGreen" : "indicatorIconRed"
            playersInfo[n].indicator.component(ofType: SpriteComponent.self)?.setTexture(textureName: texName)
            
            playersInfo[n].indicator.getNode()?.isHidden = false
            playersInfo[n].text.getNode()?.isHidden = false
            numPlayers += 1
        }
        playersInfo.suffix(from: numPlayers).forEach{
            $0.indicator.getNode()?.isHidden = true
            $0.text.getNode()?.isHidden = true
        }
    }
    
    private func showLobbyLayout(){
        associatedView?.elements.forEach{
            if $0.getNode()!.name!.starts(with: "lobby") && !$0.getNode()!.name!.starts(with: "lobbyStart"){
                $0.getNode()?.isHidden = false
            }else{
                $0.getNode()?.isHidden = true
            }
        }
        updatePlayersInfo()
    }
    
    private func showExitLayout(){
        associatedView?.elements.forEach{
            if $0.getNode()!.name!.starts(with: "alert"){
                $0.getNode()?.isHidden = false
            }else{
                $0.getNode()?.isHidden = true
            }
        }
    }
    
    private func showStartingLayout(){
        associatedView?.elements.forEach{
            if $0.getNode()!.name!.contains("Button") || $0.getNode()!.name! == "lobbyVoteLabel"{
                $0.getNode()?.isHidden = true
            }
        }
    }
    
    private func handleButtonLayout(){
        let numSystems = MenuSceneLevelsFactory.numSystems
        
        associatedView?.elements.first(where: {$0.getNode()!.name == "lobbyLeftButton"})?.getNode()!.isHidden = false
        associatedView?.elements.first(where: {$0.getNode()!.name == "lobbyRightButton"})?.getNode()!.isHidden = false
        
        if playersInfo[0].isReady {
            associatedView?.elements.first(where: {$0.getNode()!.name == "lobbyReadyButton"})?.component(ofType: LabelComponent.self)?.labels.setText(text: "NOT READY", locator: .all)
            associatedView?.elements.first(where: {$0.getNode()!.name == "lobbyLeftButton"})?.getNode()!.isHidden = true
            associatedView?.elements.first(where: {$0.getNode()!.name == "lobbyRightButton"})?.getNode()!.isHidden = true
        }else {
            associatedView?.elements.first(where: {$0.getNode()!.name == "lobbyReadyButton"})?.component(ofType: LabelComponent.self)?.labels.setText(text: "READY UP", locator: .all)
            if currentSystemID == 1 {
                associatedView?.elements.first(where: {$0.getNode()!.name == "lobbyLeftButton"})?.getNode()!.isHidden = true
            }
            if currentSystemID == numSystems {
                associatedView?.elements.first(where: {$0.getNode()!.name == "lobbyRightButton"})?.getNode()!.isHidden = true
            }
        }
    }
    
    func onExitClick(){
        showExitLayout()
    }
    
    func onYesClick(){
        let man = (stateMachine as! MGViewStateMachine).manager
        man?.exitLobby()
    }
    
    func onNoClick(){
        showLobbyLayout()
    }
    
    func onSettingsClick(){
        return
    }
    
    func onLeftClick(){
        let numSystems = MenuSceneLevelsFactory.numSystems
        currentSystemID = (currentSystemID - 1).clamped(to: 1...numSystems)
        handleButtonLayout()
        moveCamToCurrentSystem()
    }
    
    func onRightClick(){
        let numSystems = MenuSceneLevelsFactory.numSystems
        currentSystemID = (currentSystemID + 1).clamped(to: 1...numSystems)
        handleButtonLayout()
        moveCamToCurrentSystem()
    }
    func onReadyToggle(){
        let man = (stateMachine as! MGViewStateMachine).manager
        
        playersInfo[0].isReady.toggle()
        let data = MGLobbyData.readyStatus(playersInfo[0].isReady, currentSystemID)
        man?.requestTransmitLobbyData(data: data)
        self.onReceiveData(from: currentPlayers.first!, data: data)

    }
    
    func onReceiveMatch(match: GKMatch) {
        for p in match.players {
            currentPlayers.append(p)
        }
        self.updatePlayersInfo()
    }
    
    
    func onReceiveData(from player: GKPlayer, data: MGLobbyData) {
        let index = currentPlayers.firstIndex(where: {player === $0})
        switch data{
        case .readyStatus(let ready, let chosenSysID):
            guard let index = index else {
                print("Player with alias \(player.alias) was not found in the view state list of current players!")
                return
            }
            playersInfo[index].isReady = ready
            playersInfo[index].selectedSystemID = chosenSysID
            numPlayersReady += ready ? 1 : -1
            numPlayersReady = numPlayersReady.clamped(to: 0...currentPlayers.count)
            if numPlayersReady == currentPlayers.count {self.gameStart()}
        case .isInLobby(let present):
            // Do nothing if the player is present and the local lobby is aware of it or
            // if the player leaves and the lobby has already handled it.
            if present == (index != nil){
                return
            }
            if present && index == nil {
                currentPlayers.append(player)
            }else {
                currentPlayers.remove(at: index!)
            }
        }
        self.updatePlayersInfo()
        self.handleButtonLayout()
    }
    
    private func gameStart(){
        // No player is selected as host, so to avoid dealing with networking, the map is selected based on a deterministic random number
        // with the sum of the votes as a seed. This ensures that all systems start the game on the same level without communicating
        // what level to start.
        let votes = (self.playersInfo.map{$0.selectedSystemID}).sorted()
        let sum = votes.reduce(0, {sum, elem in sum + elem})
        let src = GKLinearCongruentialRandomSource(seed: UInt64(sum))
        currentSystemID = votes[src.nextInt(upperBound: votes.count)]
        showStartingLayout()
        centerCamOnCurrentSystem()
        
        let startLabel = associatedView!.elements.first(where: {$0.getNode()!.name == "lobbyStartLabel"})
        startLabel?.getNode()?.isHidden = false
        var countdownSeconds = 3
        func countdown(){
            startLabel?.component(ofType: LabelComponent.self)?.labels.setText(text: "STARTING GAME IN \(countdownSeconds)", locator: .all)
            countdownSeconds -= 1
        }
        func loadGame(){
            let man = (stateMachine as! MGViewStateMachine).manager
            man?.delegate?.loadGame(systemID: currentSystemID, levelID: 1, onlineMatch: man?.delegate?.getOnlineMatch())
        }
        
        let countAction = SKAction.run(countdown)
        startLabel?.getNode()?.run(SKAction.repeat(SKAction.sequence([countAction, SKAction.wait(forDuration: 1)]), count: countdownSeconds), completion: loadGame)
    }
}
