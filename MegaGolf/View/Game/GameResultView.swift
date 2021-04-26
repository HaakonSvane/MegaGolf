//
//  GameResultView.swift
//  MegaGolf
//
//  Created by Haakon Svane on 06/04/2021.
//

import GameKit

class GameResultView : MGView {
    
    required init(managingState: MGViewState, size: CGSize) {
        super.init(managingState: managingState, size: size)
        
        guard let manager = self.managingState! as? GameResultViewState else{
            fatalError("The game view does not have a game view state to manage it!")
        }
        
        let resultPane = UIFactory.makeTextAlertPane(title: "COMPLETE", text: "         GOOD JOB!")
        
        let nextButton = UIFactory.makeMediumButton(buttonText: "NEXT",
                                                                   linkedClosure: manager.nextClick)
        
        let quitButton = UIFactory.makeMediumButton(buttonText: "QUIT",
                                                                   textColor: GLOBALCOLOR.TEXTRED ?? GLOBALCOLOR.DEFAULT,
                                                                   linkedClosure: manager.quitClick)
        
        let s = resultPane.getNode()!.calculateAccumulatedFrame().size
        
        nextButton.getNode()?.position = CGPoint(x: -s.width*0.222, y: -s.height*0.325)
        nextButton.getNode()?.zPosition = 1

        quitButton.getNode()?.position = CGPoint(x: s.width*0.24, y: -s.height*0.325)
        quitButton.getNode()?.zPosition = 1
        
        
        elements.append(resultPane)
        elements.append(nextButton)
        elements.append(quitButton)
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
