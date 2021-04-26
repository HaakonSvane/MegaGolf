//
//  UIFactory.swift
//  MegaGolf
//
//  Created by Haakon Svane on 19/03/2021.
//

import GameKit

class UIFactory {
    static let atlasName: String = "UITexture"
    static let atlas: SKTextureAtlas = SKTextureAtlas(named: UIFactory.atlasName)
    
    static func makeTopButton(buttonText: String,
                       textColor: UIColor = GLOBALCOLOR.TEXTMAIN ?? GLOBALCOLOR.DEFAULT,
                       linkedClosure: @escaping ()->Void = {}) -> MGUILabelButtonEntity {
        return MGUILabelButtonEntity(type: .top,
                                     textureAtlas: UIFactory.atlas,
                                     buttonText: buttonText,
                                     textColor: textColor,
                                     textRelPos: CGPoint(x: 10, y: 0),
                                     onCompletion: linkedClosure)
    }
    
    static func makeBotButton(buttonText: String,
                       textColor: UIColor = GLOBALCOLOR.TEXTMAIN ?? GLOBALCOLOR.DEFAULT,
                       linkedClosure: @escaping ()->Void = {}) -> MGUILabelButtonEntity {
        return MGUILabelButtonEntity(type: .bot,
                                     textureAtlas: UIFactory.atlas,
                                     buttonText: buttonText,
                                     textColor: textColor,
                                     textRelPos: .zero,
                                     onCompletion: linkedClosure)
    }
    
    static func makeMediumButton(buttonText: String,
                          textColor: UIColor = GLOBALCOLOR.TEXTMAIN ?? GLOBALCOLOR.DEFAULT,
                          linkedClosure: @escaping ()->Void = {}) -> MGUILabelButtonEntity {
        return MGUILabelButtonEntity(type: .medium,
                                     textureAtlas: UIFactory.atlas,
                                     buttonText: buttonText,
                                     textColor: textColor,
                                     textRelPos: CGPoint(x:-15, y:5),
                                     onCompletion: linkedClosure)
    }
    
    static func makeSettignsPane() -> MGUISettingsPaneEntity {
        return MGUISettingsPaneEntity(options: DEFAULTPROPERTIES.SETTINGSOPTIONS ?? [],
                                      atlas: UIFactory.atlas,
                                      optionsAreaRelativeHeight: 0.7,
                                      headerText: "-- SETTINGS --")
    }
    
    static func makeSettingsButton(linkedClosure: @escaping ()->Void = {}) -> MGUIIconButtonEntity{
        return MGUIIconButtonEntity(type: .settings,
                                    textureAtlas: UIFactory.atlas,
                                    onCompletion: linkedClosure)
    }
    
    static func makeHelpButton(linkedClosure: @escaping ()->Void = {}) -> MGUIIconButtonEntity{
        return MGUIIconButtonEntity(type: .help,
                                    textureAtlas: UIFactory.atlas,
                                    onCompletion: linkedClosure)
    }
    
    static func makeBackButton(linkedClosure: @escaping ()->Void = {}) -> MGUIIconButtonEntity{
        return MGUIIconButtonEntity(type: .back,
                                    textureAtlas: UIFactory.atlas,
                                    onCompletion: linkedClosure)
    }
    
    static func makePauseButton(linkedClosure: @escaping ()->Void = {}) -> MGUIIconButtonEntity {
        return MGUIIconButtonEntity(type: .pause,
                                    textureAtlas: UIFactory.atlas,
                                    onCompletion: linkedClosure)
    }
    
    static func makeLeftNavButton(linkedClosure: @escaping ()->Void = {}) -> MGUIIconButtonEntity {
        return MGUIIconButtonEntity(type: .left,
                                    textureAtlas: UIFactory.atlas,
                                    onCompletion: linkedClosure)
    }
    
    static func makeRightNavButton(linkedClosure: @escaping ()->Void = {}) -> MGUIIconButtonEntity {
        return MGUIIconButtonEntity(type: .right,
                                    textureAtlas: UIFactory.atlas,
                                    onCompletion: linkedClosure)
    }
    
    static func makeBallCheckButton(linkedClosure: @escaping ()->Void = {}) -> MGUIIconButtonEntity {
        return MGUIIconButtonEntity(type: .ballCheck,
                                    textureAtlas: UIFactory.atlas,
                                    onCompletion: linkedClosure)
    }
    
    static func makeGoalCheckButton(linkedClosure: @escaping ()->Void = {}) -> MGUIIconButtonEntity {
        return MGUIIconButtonEntity(type: .goalCheck,
                                    textureAtlas: UIFactory.atlas,
                                    onCompletion: linkedClosure)
    }
    
    static func makeSlider(sliderSettings: MGUISliderSettings,
                    linkedClosure : @escaping (CGFloat) -> Void = {val in}) -> MGUISliderButtonEntity{
        return MGUISliderButtonEntity(textureAtlas: UIFactory.atlas,
                                      sliderSettings: sliderSettings,
                                      onValueChange: linkedClosure)
    }
    
    static func makePausePane(titleText: String) -> MGPaneEntity {
        let ent = MGPaneEntity(type: .small, atlas: UIFactory.atlas)
        let s = ent.component(ofType: SpriteComponent.self)!.spriteNode.size
        ent.component(ofType: LabelComponent.self)!.labels.addLabel(text: titleText)
        ent.component(ofType: LabelComponent.self)!.labels.shadow(option: true, locator: .all)
        ent.component(ofType: LabelComponent.self)!.labels.position = CGPoint(x: s.width*0.05, y: s.height*0.21)
        ent.component(ofType: LabelComponent.self)!.labels.zPosition = 2
        return ent
    }
    
    static func makeGameInfoPane() -> MGPaneEntity {
        let ent = MGPaneEntity(type: .gameInfo, atlas: UIFactory.atlas)
        let labels = ent.component(ofType: LabelComponent.self)!.labels
        
        labels.addLabel(text: "SHOTS: 0", name: "shots")
        labels.addLabel(text: "PAR: 0", name: "par")
        labels.addLabel(text: "TIME:", name: "time")
        labels.shadow(option: true, locator: .all)
        labels.setHorizontalAlignment(alignment: .left, locator: .all)
        let s = ent.getNode()!.calculateAccumulatedFrame().size
        
        labels.setSize(size: s.height*0.7, locator: .all)
        labels.position = CGPoint(x: -s.width*0.85, y: -s.height*0.05)
        labels.getLabel(locator: .forName("par"))?.position.x += s.width*0.62
        labels.getLabel(locator: .forName("time"))?.position.x += s.width*1.1
        labels.zPosition = 2
        
        return ent
    }
    
    static func makeTextAlertPane(title: String, text: String) -> MGPaneEntity {
        let ent = MGPaneEntity(type: .alert, atlas: UIFactory.atlas)
        let labels = ent.component(ofType: LabelComponent.self)!.labels
        let s = ent.component(ofType: SpriteComponent.self)!.spriteNode.size
        
        labels.addLabel(text: "-- " + title + " --", name: "title")
        labels.addLabel(text: text, name: "text")
        labels.shadow(option: true, locator: .all)
        labels.setSize(size: s.height*0.14, locator: .forName("title"))
        labels.setSize(size: s.height*0.07, locator: .forName("text"))
        
        labels.setHorizontalAlignment(alignment: .center, locator: .forName("title"))
        labels.setHorizontalAlignment(alignment: .left, locator: .forName("text"))
        labels.setNumberOfLines(lines: 0, locator: .forName("text"))
        
        labels.setPreferredMaxLayoutWidth(width: s.width*0.87, locator: .forName("text"))
        
        labels.position.y = s.height*0.32
        labels.getLabel(locator: .forName("text"))?.position.y = -s.height*0.25
        labels.getLabel(locator: .forName("text"))?.position.x = -s.width*0.40
        
        labels.zPosition = 2
        
        return ent
    }
    
    static func makeTextLabel(text: String, size: CGFloat) -> SingleTextEntity{
        return SingleTextEntity(text: text, size: size, shadowed: true)
    }
    
    static func makeIndicator(initialState: MGUIIndicatorValue = .red) -> MGUIIndicatorEntity {
        return MGUIIndicatorEntity(atlas: UIFactory.atlas, initialState: initialState)
    }
    
    
}
