//
//  MultiplayerLobbyView.swift
//  MegaGolf
//
//  Created by Haakon Svane on 17/04/2021.
//

import GameplayKit

class MultiplayerLobbyView : MGView {
    required init(managingState: MGViewState, size: CGSize) {
        super.init(managingState: managingState, size: size)
        
        guard let manager = self.managingState! as? MultiplayerLobbyViewState else{
            fatalError("The multiplayer lobby view does not have a multiplayer lobby state to manage it!")
        }
        
        let exitText = "Are you sure you want to exit the multiplayer lobby?"
        let voteText = "Solar system vote:"
        
        let voteLabel = UIFactory.makeTextLabel(text: voteText, size: 28)
        let startLabel = UIFactory.makeTextLabel(text: "STARTING GAME IN", size: 32)
        let exitButton = UIFactory.makeMediumButton(buttonText: "EXIT", linkedClosure: manager.onExitClick)
        let readyButton = UIFactory.makeBotButton(buttonText: "READY UP", linkedClosure: manager.onReadyToggle)
        let alertPane = UIFactory.makeTextAlertPane(title: "EXIT?", text: exitText)
        let yesButton = UIFactory.makeMediumButton(buttonText: "YES", linkedClosure: manager.onYesClick)
        let noButton = UIFactory.makeMediumButton(buttonText: "NO", linkedClosure: manager.onNoClick)
        let settingsButton = UIFactory.makeSettingsButton(linkedClosure: manager.onSettingsClick)
        let leftButton = UIFactory.makeLeftNavButton(linkedClosure: manager.onLeftClick)
        let rightButton = UIFactory.makeRightNavButton(linkedClosure: manager.onRightClick)
        var playerLabels : [SingleTextEntity] = []
        var rdyIndicators : [MGUIIndicatorEntity] = []
        
        for _ in 1...8 {
            let t = UIFactory.makeTextLabel(text: DEFAULTPROPERTIES.DEFAULTPLAYERNAME ?? "_NAME_ERROR_", size: 20)
            let i = UIFactory.makeIndicator(initialState: .red)
            playerLabels.append(t)
            rdyIndicators.append(i)
        }
        
        let s = alertPane.getNode()!.calculateAccumulatedFrame().size
        
        yesButton.getNode()?.zPosition = 1
        noButton.getNode()?.zPosition = 1
        
        
        exitButton.getNode()?.position = CGPoint(x: -size.width*0.25, y: -size.height*0.35)
        settingsButton.getNode()?.position = CGPoint(x: -size.width*0.4, y: -size.height*0.35)
        readyButton.getNode()?.position = CGPoint(x: size.width*0.25, y: -size.height*0.35)
        rightButton.getNode()?.position = CGPoint(x: -size.width*(0.4-2*0.17), y: 0)
        leftButton.getNode()?.position = CGPoint(x: -size.width*0.4, y: 0)
        voteLabel.getNode()?.position = CGPoint(x: -size.width*(0.4-0.17), y: size.height*0.4)
        startLabel.getNode()?.position = CGPoint(x: 0, y: -size.height*0.4)
        

        yesButton.getNode()?.position = CGPoint(x: -s.width*0.222, y: -s.height*0.325)
        noButton.getNode()?.position = CGPoint(x: s.width*0.24, y: -s.height*0.325)
        
        
        
        for (n, p) in playerLabels.enumerated() {
            p.component(ofType: LabelComponent.self)?.labels.setHorizontalAlignment(alignment: .left, locator: .all)
            p.component(ofType: LabelComponent.self)?.labels.setVerticalAlignment(alignment: .top, locator: .all)
            p.getNode()?.position = CGPoint(x: size.width*0.22, y: size.height*0.43*(1 - 1.25/7*CGFloat(n)) + 10)
            p.getNode()?.name = "lobbyPlayer\(n+1)"
        }
        
        for (n, i) in rdyIndicators.enumerated() {
            i.getNode()?.position = CGPoint(x: size.width*0.19, y: size.height*0.43*(1 - 1.25/7*CGFloat(n)))
            i.getNode()?.name = "lobbyIndicator\(n+1)"
        }
        
        
        exitButton.getNode()?.name = "lobbyExitButton"
        alertPane.getNode()?.name = "alertPane"
        yesButton.getNode()?.name = "alertYesButton"
        noButton.getNode()?.name = "alertNoButton"
        readyButton.getNode()?.name = "lobbyReadyButton"
        settingsButton.getNode()?.name = "lobbySettingsButton"
        leftButton.getNode()?.name = "lobbyLeftButton"
        rightButton.getNode()?.name = "lobbyRightButton"
        voteLabel.getNode()?.name = "lobbyVoteLabel"
        startLabel.getNode()?.name = "lobbyStartLabel"
        
        elements.append(exitButton)
        elements.append(readyButton)
        elements.append(alertPane)
        elements.append(yesButton)
        elements.append(noButton)
        elements.append(settingsButton)
        elements.append(leftButton)
        elements.append(rightButton)
        elements.append(voteLabel)
        elements.append(startLabel)
        playerLabels.forEach{elements.append($0)}
        rdyIndicators.forEach{elements.append($0)}
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
