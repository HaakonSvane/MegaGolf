//
//  HapticComponent.swift
//  MegaGolf
//
//  Created by Haakon Svane on 16/03/2021.
//

import GameKit

/**
    A component for adding haptic feedback to the entity. The impact type is set using the `impact` variable and is played using the `run()` method.
 */

class HapticComponent : GKComponent{
    var generator : UIImpactFeedbackGenerator
    
    var impact : UIImpactFeedbackGenerator.FeedbackStyle {
        didSet{
            generator = UIImpactFeedbackGenerator(style: impact)
        }
    }
    
    init(impact: UIImpactFeedbackGenerator.FeedbackStyle){
        self.generator = UIImpactFeedbackGenerator(style: impact)
        self.generator.prepare()
        self.impact = impact
        super.init()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func run(impactType: UIImpactFeedbackGenerator.FeedbackStyle? = nil){
        if let imp = impactType{
            impact = imp
        }
        self.generator.impactOccurred()
    }
    
    
}
