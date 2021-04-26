//
//  LevelSelectView.swift
//  MegaGolf
//
//  Created by Haakon Svane on 16/03/2021.
//

import GameKit

class LevelSelectView : MGView {
    
    required init(managingState: MGViewState, size: CGSize){
        super.init(managingState: managingState, size: size)
        guard let manager = self.managingState! as? LevelSelectViewState else{
            fatalError("The level selection view does not have a level select state to manage it!")
        }
        
        let selectButton = UIFactory.makeMediumButton(buttonText: "SELECT", linkedClosure: manager.selectClick)
        selectButton.getNode()?.position = CGPoint(x: 0, y: -size.height*0.3)
        selectButton.getNode()?.name = "selectButton"
        
        let backButton = UIFactory.makeBackButton(linkedClosure: manager.backClick)
        backButton.getNode()?.position = CGPoint(x: -size.width*0.4, y: -size.height*0.3)
        
        let leftButton = UIFactory.makeLeftNavButton(linkedClosure: manager.leftClick)
        leftButton.getNode()?.position = CGPoint(x: -size.width*0.17, y: -size.height*0.3)
        leftButton.getNode()?.name = "leftButton"
        
        let rightButton = UIFactory.makeRightNavButton(linkedClosure: manager.rightClick)
        rightButton.getNode()?.position = CGPoint(x: size.width*0.17, y: -size.height*0.3)
        rightButton.getNode()?.name = "rightButton"
        
        elements.append(selectButton)
        elements.append(backButton)
        elements.append(leftButton)
        elements.append(rightButton)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
