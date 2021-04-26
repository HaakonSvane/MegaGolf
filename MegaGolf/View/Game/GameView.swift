//
//  GameView.swift
//  MegaGolf
//
//  Created by Haakon Svane on 24/03/2021.
//

import GameKit

class GameView : MGView {
    
    required init(managingState: MGViewState, size: CGSize) {
        super.init(managingState: managingState, size: size)
        
        guard let manager = self.managingState! as? GameViewState else{
            fatalError("The game view does not have a game view state to manage it!")
        }
        
        let pauseButton = UIFactory.makePauseButton(linkedClosure: manager.onPauseClick)
        pauseButton.getNode()?.position = CGPoint(x: -size.width*0.4, y: size.height*0.4)
        
        let goalCheckButton = UIFactory.makeGoalCheckButton(linkedClosure: manager.onGoalCheckClick)
        goalCheckButton.getNode()?.position = CGPoint(x: -size.width*0.30, y: size.height*0.4)
        goalCheckButton.getNode()?.name = "goalCheckButton"
        
        let ballCheckButton = UIFactory.makeBallCheckButton(linkedClosure: manager.onBallCheckClick)
        ballCheckButton.getNode()?.position = goalCheckButton.getNode()!.position
        ballCheckButton.getNode()?.name = "ballCheckButton"
        
        let gamePane = UIFactory.makeGameInfoPane()
        gamePane.getNode()?.position = CGPoint(x: size.width*0.05, y: size.height*0.4)
        gamePane.getNode()?.name = "gameInfoPane"
        
        let infoText = UIFactory.makeTextLabel(text: "", size: 60)
        infoText.getNode()?.name = "infoText"
        
        elements.append(pauseButton)
        elements.append(gamePane)
        elements.append(infoText)
        elements.append(goalCheckButton)
        elements.append(ballCheckButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
