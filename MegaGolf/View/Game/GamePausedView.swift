//
//  GamePausedView.swift
//  MegaGolf
//
//  Created by Haakon Svane on 24/03/2021.
//

import GameKit

class GamePausedView : MGView {
    
    required init(managingState: MGViewState, size: CGSize) {
        super.init(managingState: managingState, size: size)
        
        guard let manager = self.managingState! as? GamePausedViewState else{
            fatalError("The game paused view does not have a game paused state to manage it!")
        }
        
        let pane = UIFactory.makePausePane(titleText: "GAME PAUSED")
        let paneS = pane.getNode()?.calculateAccumulatedFrame().size
        
        let backButton = UIFactory.makeBackButton(linkedClosure: manager.playClick)
        backButton.getNode()?.position = CGPoint(x: -paneS!.width*0.34, y: -paneS!.height*0.21)
        backButton.getNode()?.zPosition = 1
        
        let quitButton = UIFactory.makeMediumButton(buttonText: "QUIT", textColor: GLOBALCOLOR.TEXTRED ?? GLOBALCOLOR.DEFAULT, linkedClosure: manager.gameExitClick)
        quitButton.getNode()?.position = CGPoint(x: paneS!.width*0.24, y: -paneS!.height*0.213)
        quitButton.getNode()?.zPosition = 1
        
        let settingsButton = UIFactory.makeSettingsButton(linkedClosure:manager.settingsClick)
        settingsButton.getNode()?.position = CGPoint(x: -paneS!.width*0.105, y: -paneS!.height*0.21)
        settingsButton.getNode()?.zPosition = 1
        
        elements.append(pane)
        elements.append(backButton)
        elements.append(quitButton)
        elements.append(settingsButton)
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
