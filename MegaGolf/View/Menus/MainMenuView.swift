//
//  MainMenuView.swift
//  MegaGolf
//
//  Created by Haakon Svane on 15/03/2021.
//

import GameKit

class MainMenuView : MGView{
    
    required init(managingState: MGViewState, size: CGSize){
        super.init(managingState: managingState, size: size)
        
        guard let manager = self.managingState! as? MainMenuViewState else{
            fatalError("The main menu view does not have a main menu state to manage it!")
        }
        
        let spButton = UIFactory.makeTopButton(buttonText: "SINGLE PLAYER", linkedClosure: manager.singlePlayerClick)
        spButton.getNode()?.position = CGPoint(x: size.width*0.25, y: size.height*0.3)
        
        let mpButton = UIFactory.makeBotButton(buttonText: "MULTIPLAYER", linkedClosure: manager.multiplayerClick)
        mpButton.getNode()?.position = CGPoint(x: size.width*0.25, y: -size.height*0.3)
        
        let settingsButton = UIFactory.makeSettingsButton(linkedClosure: manager.settingsClick)
        settingsButton.getNode()?.position = CGPoint(x: -size.width*0.4, y: -size.height*0.3)
        
        
        elements.append(spButton)
        elements.append(mpButton)
        elements.append(settingsButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

