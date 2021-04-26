//
//  GravityComponent.swift
//  MegaGolf
//
//  Created by Haakon Svane on 14/03/2021.
//

import GameKit

/**
    A component for adding a gravitational field to the entity. The field can be displayed  by setting  the `showField` parameter. Defaults to true
    
    - Requires :
        - `NodeComponent`
 
 */

class GravityComponent : GKComponent {
    
    private let fieldNode : SKFieldNode
    private let fieldShape : SKShapeNode
    
    var showField : Bool {
        set(newValue){
            fieldShape.isHidden = !newValue
        }
        get{
            return !fieldShape.isHidden
        }
    }
    
    var radius : CGFloat {
        willSet(newRadius){
            fieldShape.setScale(newRadius/radius)
            self.region = SKRegion(radius: Float(newRadius))
        }
    }
    
    var falloff : Float {
        set(newValue){
            fieldNode.falloff = newValue
        }
        get{
            return fieldNode.falloff
        }
    }
    
    var categoryBitMask : UInt32 {
        set(newValue){
            fieldNode.categoryBitMask = newValue
        }
        get{
            return fieldNode.categoryBitMask
        }
    }
    
    var region : SKRegion?{
        set(newValue){
            fieldNode.region = newValue
        }
        get{
            return fieldNode.region
        }
    }
    
    var strength : CGFloat {
        set(newValue){
            fieldNode.strength = Float(newValue)
        }
        get{
            return CGFloat(fieldNode.strength)
        }
    }
    
    
    var fieldColor : UIColor {
        set(newValue){
            fieldShape.fillColor = newValue
        }
        get{
            return fieldShape.fillColor
        }
    }
    
    
    init(radius : CGFloat, showField : Bool = true){
        fieldNode = SKFieldNode.radialGravityField()
        fieldShape = SKShapeNode(circleOfRadius: radius)
        fieldShape.fillColor = GLOBALCOLOR.GRAVITYFIELD ?? GLOBALCOLOR.DEFAULT
        fieldShape.strokeColor = .clear
        fieldShape.fillShader = SKShader(fileNamed: "RadialAlphaGradient")
        self.radius = radius
        super.init()
        self.region = SKRegion(radius: Float(radius))
        fieldShape.zPosition = -1
        fieldNode.addChild(fieldShape)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didAddToEntity() {
        guard let eNode = entity?.getNode() else {
            fatalError("The entity does not have a NodeComponent yet. Add this before adding a GravityComponent.")
        }
       eNode.addChild(fieldNode)
    }
    
}
