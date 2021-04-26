//
//  SettingsViewState.swift
//  MegaGolf
//
//  Created by Haakon Svane on 16/03/2021.
//

import GameKit

class SettingsViewState : MGViewState{
    init(viewSize: CGSize){
        super.init(viewType: SettingsView.self, viewSize: viewSize)
    }

    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass is MGViewState.Type
    }
    
    func backClick(){
        let man = (stateMachine as! MGViewStateMachine).manager
        man?.enterPreviousState()
    }
    
    func onMusicSliderChange(val: CGFloat){
        let man = (stateMachine as! MGViewStateMachine).manager
        for ent in man!.delegate!.getCurrentSceneEntities()!{
            if let comp = ent.component(ofType: AudioComponent.self){
                if comp.audioData.type == .music{comp.setVolume(value: val)}
            }
        }
        UserDefaults.standard.setValue(Float(val), forKey: USERDEFAULTSTRING.MUSICVOLUME)
    }
    
    func onSfxSliderChange(val: CGFloat){
        UserDefaults.standard.setValue(Float(val), forKey: USERDEFAULTSTRING.SFXVOLUME)
    }
}
