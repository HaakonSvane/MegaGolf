//
//  MGLabelNode.swift
//  MegaGolf
//
//  Created by Haakon Svane on 19/03/2021.
//

import SpriteKit


class MGLabelNode : SKNode {
    private var label : SKLabelNode
    private var shadowLabel : SKLabelNode
    
    var text: String? {
        set(newValue){
            label.text = newValue
            shadowLabel.text = newValue
        }
        get{
            return label.text
        }
    }
    
    var fontSize: CGFloat {
        set(newValue){
            label.fontSize = newValue
            shadowLabel.fontSize = newValue
        }
        get{
            return label.fontSize
        }
    }
    
    var fontColor: UIColor? {
        set(newValue){
            label.fontColor = newValue
        }
        get{
            return label.fontColor
        }
    }
    
    var showShadow: Bool {
        set(newValue){
            shadowLabel.fontColor = GLOBALCOLOR.TEXTSHADOW ?? GLOBALCOLOR.DEFAULT
            shadowLabel.isHidden = !newValue
        }
        get{
            return !shadowLabel.isHidden
        }
    }
    
    var horizontalAlignment : SKLabelHorizontalAlignmentMode {
        set(newValue){
            label.horizontalAlignmentMode = newValue
            shadowLabel.horizontalAlignmentMode = newValue
        }
        get{
            return label.horizontalAlignmentMode
        }
    }
    
    var verticalAlignment : SKLabelVerticalAlignmentMode {
        set(newValue){
            label.verticalAlignmentMode = newValue
            shadowLabel.verticalAlignmentMode = newValue
        }
        get{
            return label.verticalAlignmentMode
        }
    }
    
    var preferredMaxLayoutWidth : CGFloat {
        set(newValue){
            label.preferredMaxLayoutWidth = newValue
            shadowLabel.preferredMaxLayoutWidth = newValue
        }
        get{
            return label.preferredMaxLayoutWidth
        }
    }
    
    var numberOfLines : Int {
        set(newValue){
            label.numberOfLines = newValue
            shadowLabel.numberOfLines = newValue
        }
        get{
            return label.numberOfLines
        }
    }
    
    init(text: String? = nil){
        
        label = SKLabelNode(fontNamed: DEFAULTPROPERTIES.FONT)
        shadowLabel = SKLabelNode(fontNamed: DEFAULTPROPERTIES.FONT)
        super.init()
        
        self.text = text ?? ""
        self.fontSize = 70
        self.fontColor = GLOBALCOLOR.TEXTMAIN ?? GLOBALCOLOR.DEFAULT
        self.showShadow = false
        self.horizontalAlignment = .center
        self.verticalAlignment = .center
        
        label.addChild(shadowLabel)
        shadowLabel.position.x = self.fontSize / 18
        shadowLabel.position.y = -self.fontSize / 18
        shadowLabel.zPosition = -1

        // Should we skip adding the label to another SKNode and instead just return the label with the shadowLabel as a child??
        self.addChild(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
