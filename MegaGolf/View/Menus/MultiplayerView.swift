//
//  MultiplayerView.swift
//  MegaGolf
//
//  Created by Haakon Svane on 16/03/2021.
//

import GameKit

class MultiplayerView : MGView {
    
    required init(managingState: MGViewState, size: CGSize){
        super.init(managingState: managingState, size: size)
        
        guard let manager = self.managingState! as? MultiplayerViewState else{
            fatalError("The multiplayer view does not have a multiplayer state to manage it!")
        }
        
        
        let findButton = UIFactory.makeMediumButton(buttonText: "FIND", linkedClosure: manager.findClick)
        findButton.getNode()?.position = CGPoint(x: size.width*0.3, y: -size.height*0.3)
        
        let backButton = UIFactory.makeBackButton(linkedClosure: manager.backClick)
        backButton.getNode()?.position = CGPoint(x: -size.width*0.4, y: -size.height*0.3)
        
        elements.append(findButton)
        elements.append(backButton)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
