//
//  MGLoadingScreenScene.swift
//  MegaGolf
//
//  Created by Haakon Svane on 23/03/2021.
//

import SpriteKit
    
class MGLoadingScene : MGScene {
    let loadingLabel : SingleTextEntity
    
    override init(size: CGSize) {
        loadingLabel = UIFactory.makeTextLabel(text: "Loading", size: 28)
        loadingLabel.component(ofType: LabelComponent.self)?.labels.setHorizontalAlignment(alignment: .left, locator: .all)
        loadingLabel.getNode()?.position = CGPoint(x: -size.width*0.45, y: -size.height*0.45)
        
        super.init(size: size)
        self.backgroundColor = .black
        
        
        self.addEntity(loadingLabel)
        self.addChild(loadingLabel.getNode()!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func sceneDidLoad() {
        super.sceneDidLoad()
    }
    
    override func update(_ currentTime: TimeInterval) {
        let mt = Int(floor(currentTime*4))
        loadingLabel.component(ofType: LabelComponent.self)?.labels.setText(text: "Loading"+String(repeating: ".", count: mt % 4), locator: .all)
    }
}
