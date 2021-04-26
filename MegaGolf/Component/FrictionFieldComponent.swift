//
//  FrictionFieldComponent.swift
//  MegaGolf
//
//  Created by Haakon Svane on 25/03/2021.
//

import GameKit

enum MGFrictionFieldShapeType{
    case circle(radius: CGFloat)
    case rectancle(size: CGSize)
}

/**
    A component for adding a friction field to the entity. The field can be displayed  by setting  the `showField` parameter. Defaults to true
    
    - Requires :
        - `NodeComponent`
 
 */

class FrictionFieldComponent : GKComponent {
    
    private let fieldNode : SKFieldNode
    private let fieldShape : SKShapeNode
    private static let frictionFunction : SKFieldForceEvaluator = {
        (position: vector_float3, velocity: vector_float3, mass: Float, charge: Float, deltaTime: TimeInterval) in
        let absSq = normalize(velocity)
        let fx = -FrictionFieldComponent.frictionForce*absSq.x
        let fy = -FrictionFieldComponent.frictionForce*absSq.y
        return vector_float3(fx, fy, 0)
    }
    
    private static var frictionForce: Float = 1
    
    var showField : Bool {
        set(newValue){
            fieldShape.isHidden = !newValue
        }
        get{
            return !fieldShape.isHidden
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
    
    var friction : CGFloat {
        set(newValue){
            FrictionFieldComponent.frictionForce = Float(newValue.clamped(to: 0...1))*15
        }
        get{
            return CGFloat(FrictionFieldComponent.frictionForce)/15
        }
    }
    
    
    init(shapeType: MGFrictionFieldShapeType, showField : Bool = true){
        fieldNode = SKFieldNode.customField(evaluationBlock: FrictionFieldComponent.frictionFunction)
        fieldNode.isEnabled = true
        fieldNode.isExclusive = true
        
        let reg: SKRegion
        switch shapeType {
        case .circle(let radius):
            fieldShape = SKShapeNode(circleOfRadius: radius)
            reg = SKRegion(radius: Float(radius))
        case .rectancle(let size):
            fieldShape = SKShapeNode(rectOf: size)
            reg = SKRegion(size: size)
        }
        
        fieldShape.fillColor = GLOBALCOLOR.DEFAULT
        fieldShape.strokeColor = .clear
        
        super.init()
        self.region = reg
        fieldShape.zPosition = -1
        fieldNode.addChild(fieldShape)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didAddToEntity() {
        guard let eNode = entity?.getNode() else {
            fatalError("The entity does not have a NodeComponent yet. Add this before adding a FrictionFieldComponent.")
        }
        eNode.addChild(fieldNode)
    }
}
