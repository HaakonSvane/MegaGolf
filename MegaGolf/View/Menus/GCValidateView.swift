//
//  GCValidateView.swift
//  MegaGolf
//
//  Created by Haakon Svane on 31/03/2021.
//

import SpriteKit

class GCValidateView : MGView {
    
    required init(managingState: MGViewState, size: CGSize){
        super.init(managingState: managingState, size: size)
        
        guard let manager = self.managingState! as? GCValidateViewState else{
            fatalError("The Game Center validation view does not have a Game Center validation state to manage it!")
        }
        
        let signText = "In order to play multiplayer you must first sign in to Game Center. Would you like to do this now?"
        let failText = "There was an error authenticating your Game Center credentials. Please enable Game Center in your phone settings. You will be taken back to the main menu."
        
        let signInAlert = UIFactory.makeTextAlertPane(title: "SIGN IN", text: signText)
        let errorAlert = UIFactory.makeTextAlertPane(title: "ERROR", text: failText)
        let yesButton = UIFactory.makeMediumButton(buttonText: "YES", linkedClosure: manager.GCSignInClick)
        let noButton = UIFactory.makeMediumButton(buttonText: "NO", linkedClosure: manager.backClick)
        let okButton = UIFactory.makeMediumButton(buttonText: "OK", linkedClosure: manager.backClick)
        let waitingText = UIFactory.makeTextLabel(text: "Waiting for authentication...", size: 40)
        
        signInAlert.getNode()?.name = "loginPane"
        errorAlert.getNode()?.name = "errorPane"
        yesButton.getNode()?.name = "loginYes"
        noButton.getNode()?.name = "loginNo"
        okButton.getNode()?.name = "errorOk"
        waitingText.getNode()?.name = "waiting"
        
        let s = signInAlert.getNode()!.calculateAccumulatedFrame().size
        
        yesButton.getNode()?.zPosition = 1
        noButton.getNode()?.zPosition = 1
        okButton.getNode()?.zPosition = 1
        
        yesButton.getNode()?.position = CGPoint(x: -s.width*0.222, y: -s.height*0.325)
        noButton.getNode()?.position = CGPoint(x: s.width*0.24, y: -s.height*0.325)
        okButton.getNode()?.position = CGPoint(x: 0, y: -s.height*0.325)
        
        elements.append(signInAlert)
        elements.append(errorAlert)
        elements.append(yesButton)
        elements.append(noButton)
        elements.append(okButton)
        elements.append(waitingText)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
