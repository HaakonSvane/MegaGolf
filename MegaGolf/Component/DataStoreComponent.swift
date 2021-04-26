//
//  DataStoreComponent.swift
//  MegaGolf
//
//  Created by Haakon Svane on 22/03/2021.
//

import GameKit

/**
    A component for storing custom data on the entity. The data must be of type `Dictionary<String : Any>`.
 */

class DataStoreComponent : GKComponent {
    var data : [String : Any]
    
    init(data : [String : AnyObject]? = nil){
        if let d = data{
            self.data = d
        }
        else{
            self.data = [:]
        }
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
