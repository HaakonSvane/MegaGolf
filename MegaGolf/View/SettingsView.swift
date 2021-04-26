//
//  SettingsView.swift
//  MegaGolf
//
//  Created by Haakon Svane on 16/03/2021.
//

import GameKit

class SettingsView : MGView {
    
    required init(managingState: MGViewState, size: CGSize){
        super.init(managingState: managingState, size: size)
        
        guard let manager = self.managingState! as? SettingsViewState else{
            fatalError("The settings view does not have a settings state to manage it!")
        }
        
        let settingsPane = UIFactory.makeSettignsPane()
        let backButton = UIFactory.makeMediumButton(buttonText: "BACK", linkedClosure: manager.backClick)
        let aboutButton = UIFactory.makeHelpButton()
        
        let s = settingsPane.getNode()?.calculateAccumulatedFrame().size
        
        let musicSettings = MGUISliderSettings(minValue: 0.0, maxValue: 1.0, length: s!.width, defaultValue: CGFloat(UserDefaults.standard.float(forKey: USERDEFAULTSTRING.MUSICVOLUME)))
        
        let sfxSettings = MGUISliderSettings(minValue: 0.0, maxValue: 1.0, length: s!.width, defaultValue: CGFloat(UserDefaults.standard.float(forKey: USERDEFAULTSTRING.SFXVOLUME)))
        
        let musicSlider = UIFactory.makeSlider(sliderSettings: musicSettings, linkedClosure: manager.onMusicSliderChange)
        let sfxSlider = UIFactory.makeSlider(sliderSettings: sfxSettings, linkedClosure: manager.onSfxSliderChange)
        
        backButton.getNode()?.zPosition = 1
        aboutButton.getNode()?.zPosition = 1
        musicSlider.getNode()?.zPosition = 2
        sfxSlider.getNode()?.zPosition = 2
        
        backButton.getNode()?.position = CGPoint(x: s!.width*(0.3-1/2), y: s!.height*(0.122-1/2))
        aboutButton.getNode()?.position = CGPoint(x: s!.width*(-0.2+1/2), y: s!.height*(0.127-1/2))
        musicSlider.getNode()?.position = CGPoint(x: 0, y: s!.height/10)
        sfxSlider.getNode()?.position = CGPoint(x: 0, y: -s!.height/7)
        
        elements.append(settingsPane)
        elements.append(backButton)
        elements.append(aboutButton)
        elements.append(musicSlider)
        elements.append(sfxSlider)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
