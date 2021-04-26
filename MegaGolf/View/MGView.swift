//
//  MGView.swift
//  MegaGolf
//
//  Created by Haakon Svane on 16/03/2021.
//

import GameKit

class MGView : SKNode {
    let size: CGSize
    var elements : [GKEntity] {
        didSet{
            self.addChild((elements.last?.getNode())!)

        }
    }
    
    weak var managingState : MGViewState?
    
    required init(managingState : MGViewState, size: CGSize){
        self.managingState = managingState
        self.size = size
        self.elements = []
        super.init()
        self.zPosition = 1
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
