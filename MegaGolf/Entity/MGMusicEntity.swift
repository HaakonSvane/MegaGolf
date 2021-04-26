//
//  MGMusicEntity.swift
//  MegaGolf
//
//  Created by Haakon Svane on 07/04/2021.
//

import GameKit

class MGMusicEntity : GKEntity {
    init(songNamed: String){
        super.init()
        
        let nodeComp = NodeComponent()
        let audioComp = AudioComponent(sound: MGAudioUnit(fileName: songNamed, type: .music), loopAudio: true)
        
        self.addComponent(nodeComp)
        self.addComponent(audioComp)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
