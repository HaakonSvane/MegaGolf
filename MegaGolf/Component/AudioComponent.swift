//
//  AudioComponent.swift
//  MegaGolf
//
//  Created by Haakon Svane on 16/03/2021.
//

import GameKit

/**
    A component for adding a audio node to the entity. Audio can be played and stopped by using the `play()`and `stop()` methods.
    
    - Requires :
        - `NodeComponent`
 
 */

class AudioComponent : GKComponent{
    let soundNode : SKAudioNode
    let audioData : MGAudioUnit
    
    init(sound: MGAudioUnit, loopAudio: Bool){
        self.audioData = sound
        
        soundNode = SKAudioNode(fileNamed: sound.fileName)
        soundNode.autoplayLooped = loopAudio
        soundNode.isPositional = false
        
        var key = ""
        switch sound.type {
        case .effect:
            key = USERDEFAULTSTRING.SFXVOLUME
        case .music:
            key = USERDEFAULTSTRING.MUSICVOLUME
        }
        super.init()
        self.setVolume(value: CGFloat(UserDefaults.standard.float(forKey: key)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didAddToEntity() {
        guard let eNode = entity?.getNode() else{
            fatalError("The entity does not have a NodeComponent attached to it. Add this before adding a AudioComponent.")
        }
        eNode.addChild(soundNode)
    }
    
    func stop(){
        soundNode.run(SKAction.stop())
    }
    
    func play(){
        
        var key = ""
        switch audioData.type {
        case .effect:
            key = USERDEFAULTSTRING.SFXVOLUME
        case .music:
            key = USERDEFAULTSTRING.MUSICVOLUME
        }
        setVolume(value: CGFloat(UserDefaults.standard.float(forKey: key)))
        soundNode.run(SKAction.sequence([SKAction.stop(), SKAction.play()]), withKey: "sound")
    }
    
    func setVolume(value : CGFloat){
        soundNode.run(SKAction.changeVolume(to: Float(value), duration: 0))
    }
}
