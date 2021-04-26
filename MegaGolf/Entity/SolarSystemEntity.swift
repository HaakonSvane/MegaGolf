//
//  SolarSystemEntity.swift
//  MegaGolf
//
//  Created by Haakon Svane on 09/04/2021.
//

import GameKit

class SolarSystemEntity : GKEntity {
    override init(){
        super.init()
        let nodeComp = NodeComponent()
        let dataComp = DataStoreComponent()
        self.addComponent(nodeComp)
        self.addComponent(dataComp)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
