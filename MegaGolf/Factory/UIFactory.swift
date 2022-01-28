//
//  UIFactory.swift
//  MegaGolf
//
//  Created by Haakon Svane on 19/03/2021.
//

import GameKit

class UIFactory {
    static let atlasName: String = "UITexture"
    
    static func makeTopButton(buttonText: String,
                       textColor: UIColor = GLOBALCOLOR.TEXTMAIN ?? GLOBALCOLOR.DEFAULT,
                       linkedClosure: @escaping ()->Void = {}) -> MGUILabelButtonEntity {
        return MGUILabelButtonEntity(type: .top,
                                     atlasName: UIFactory.atlasName,
                                     buttonText: buttonText,
                                     textColor: textColor,
                                     textRelPos: CGPoint(x: 10, y: 0),
                                     onCompletion: linkedClosure)
    }
    
    static func makeBotButton(buttonText: String,
                       textColor: UIColor = GLOBALCOLOR.TEXTMAIN ?? GLOBALCOLOR.DEFAULT,
                       linkedClosure: @escaping ()->Void = {}) -> MGUILabelButtonEntity {
        return MGUILabelButtonEntity(type: .bot,
                                     atlasName: UIFactory.atlasName,
                                     buttonText: buttonText,
                                     textColor: textColor,
                                     textRelPos: .zero,
                                     onCompletion: linkedClosure)
    }
    
    static func makeMediumButton(buttonText: String,
                          textColor: UIColor = GLOBALCOLOR.TEXTMAIN ?? GLOBALCOLOR.DEFAULT,
                          linkedClosure: @escaping ()->Void = {}) -> MGUILabelButtonEntity {
        return MGUILabelButtonEntity(type: .medium,
                                     atlasName: UIFactory.atlasName,
                                     buttonText: buttonText,
                                     textColor: textColor,
                                     textRelPos: CGPoint(x:-15, y:5),
                                     onCompletion: linkedClosure)
    }
    
    static func makeSettignsPane() -> MGUISettingsPaneEntity {
        return MGUISettingsPaneEntity(options: DEFAULTPROPERTIES.SETTINGSOPTIONS ?? [],
                                      atlasName: UIFactory.atlasName,
                                      optionsAreaRelativeHeight: 0.7,
                                      headerText: "-- SETTINGS --")
    }
    
    static func makeSettingsButton(linkedClosure: @escaping ()->Void = {}) -> MGUIIconButtonEntity{
        return MGUIIconButtonEntity(type: .settings,
                                    atlasName: UIFactory.atlasName,
                                    onCompletion: linkedClosure)
    }
    
    static func makeHelpButton(linkedClosure: @escaping ()->Void = {}) -> MGUIIconButtonEntity{
        return MGUIIconButtonEntity(type: .help,
                                    atlasName: UIFactory.atlasName,
                                    onCompletion: linkedClosure)
    }
    
    static func makeBackButton(linkedClosure: @escaping ()->Void = {}) -> MGUIIconButtonEntity{
        return MGUIIconButtonEntity(type: .back,
                                    atlasName: UIFactory.atlasName,
                                    onCompletion: linkedClosure)
    }
    
    static func makePauseButton(linkedClosure: @escaping ()->Void = {}) -> MGUIIconButtonEntity {
        return MGUIIconButtonEntity(type: .pause,
                                    atlasName: UIFactory.atlasName,
                                    onCompletion: linkedClosure)
    }
    
    static func makeLeftNavButton(linkedClosure: @escaping ()->Void = {}) -> MGUIIconButtonEntity {
        return MGUIIconButtonEntity(type: .left,
                                    atlasName: UIFactory.atlasName,
                                    onCompletion: linkedClosure)
    }
    
    static func makeRightNavButton(linkedClosure: @escaping ()->Void = {}) -> MGUIIconButtonEntity {
        return MGUIIconButtonEntity(type: .right,
                                    atlasName: UIFactory.atlasName,
                                    onCompletion: linkedClosure)
    }
    
    static func makeBallCheckButton(linkedClosure: @escaping ()->Void = {}) -> MGUIIconButtonEntity {
        return MGUIIconButtonEntity(type: .ballCheck,
                                    atlasName: UIFactory.atlasName,
                                    onCompletion: linkedClosure)
    }
    
    static func makeGoalCheckButton(linkedClosure: @escaping ()->Void = {}) -> MGUIIconButtonEntity {
        return MGUIIconButtonEntity(type: .goalCheck,
                                    atlasName: UIFactory.atlasName,
                                    onCompletion: linkedClosure)
    }
    
    static func makeSlider(sliderSettings: MGUISliderSettings,
                    linkedClosure : @escaping (CGFloat) -> Void = {val in}) -> MGUISliderButtonEntity{
        return MGUISliderButtonEntity(atlasName: UIFactory.atlasName,
                                      sliderSettings: sliderSettings,
                                      onValueChange: linkedClosure)
    }
    
    static func makePausePane(titleText: String) -> MGPaneEntity {
        let ent = MGPaneEntity(type: .small, atlasName: UIFactory.atlasName)
        let s = ent.component(ofType: SpriteComponent.self)!.spriteNode.size
        ent.component(ofType: LabelComponent.self)!.labels.addLabel(text: titleText)
        ent.component(ofType: LabelComponent.self)!.labels.shadow(option: true, locator: .all)
        ent.component(ofType: LabelComponent.self)!.labels.position = CGPoint(x: s.width*0.05, y: s.height*0.21)
        ent.component(ofType: LabelComponent.self)!.labels.zPosition = 2
        return ent
    }
    
    static func makeGameInfoPane() -> MGPaneEntity {
        let ent = MGPaneEntity(type: .gameInfo, atlasName: UIFactory.atlasName)
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
        let ent = MGPaneEntity(type: .alert, atlasName: UIFactory.atlasName)
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
        return MGUIIndicatorEntity(atlasName: UIFactory.atlasName, initialState: initialState)
    }
    
    
}
