//
//  PhysicsComponent.swift
//  MegaGolf
//
//  Created by Haakon Svane on 07/03/2021.
//

import GameKit


enum MGPhysicsBodyType{
    case circular(radius : CGFloat)
    case fromTexture(tex : SKTexture, alphaThresh : Float = 0.9)
}

/**
    A component for adding a physics body to the entity. The body is simulated using Apple's provided physics engine.
    
    - Requires :
        - `NodeComponent`
 
 */
class PhysicsComponent : GKComponent {
    let bodyType : MGPhysicsBodyType
    private let physicsCompBody : SKPhysicsBody
    
    var categoryBitMask : UInt32 {
        set(newValue){
            physicsCompBody.categoryBitMask = newValue
        }
        get{
            return physicsCompBody.categoryBitMask
        }
    }
    
    var collisionBitMask : UInt32 {
        set(newValue){
            physicsCompBody.collisionBitMask = newValue
        }
        get{
            return physicsCompBody.collisionBitMask
        }
    }
    var contactBitMask : UInt32 {
        set(newValue){
            physicsCompBody.contactTestBitMask = newValue
        }
        get{
            return physicsCompBody.contactTestBitMask
        }
    }
    
    var fieldBitMask : UInt32 {
        set(newValue){
            physicsCompBody.fieldBitMask = newValue
        }
        get{
            return physicsCompBody.fieldBitMask
        }
    }
    var velocity : CGVector {
        set(newValue){
            physicsCompBody.velocity = newValue
        }
        get{
            return physicsCompBody.velocity
            }
        }
    
    var angularVelocity : CGFloat {
        set(newValue){
            physicsCompBody.angularVelocity = newValue
        }
        get{
            return physicsCompBody.angularVelocity
        }
    }
    
    var respondsToGravity : Bool {
        didSet{
            physicsCompBody.affectedByGravity = respondsToGravity
        }
    }
    
    var isDynamic : Bool {
        didSet{
            physicsCompBody.isDynamic = isDynamic
        }
    }
    
    var kineticFriction : CGFloat {
        set(newValue){
            physicsCompBody.friction = newValue
        }
        get{
            return physicsCompBody.friction
        }
    }
    
    var staticFriction : CGFloat
    
    var linearDamping : CGFloat {
        didSet{
            physicsCompBody.linearDamping = linearDamping
        }
    }
    
    var angularDamping : CGFloat {
        didSet{
            physicsCompBody.angularDamping = angularDamping
        }
    }
    
    var allowsRotation: Bool {
        didSet{
            physicsCompBody.allowsRotation = allowsRotation
        }
    }
    
    var usesPreciseCollisionDetection : Bool {
        set(newValue){
            physicsCompBody.usesPreciseCollisionDetection = newValue
        }
        get{
            return physicsCompBody.usesPreciseCollisionDetection
        }
    }
    
    var restitution : CGFloat{
        set(newValue){
            physicsCompBody.restitution = newValue
        }
        get{
            return physicsCompBody.restitution
        }
    }
        
    var density : CGFloat {
        set(newValue){
            physicsCompBody.density = newValue
        }
        get{
            return physicsCompBody.density
        }
    }
    
    var mass : CGFloat {
        set(newValue){
            physicsCompBody.mass = newValue
        }
        get{
            return physicsCompBody.mass
        }
    }
    
    init(bodyType : MGPhysicsBodyType){
        self.bodyType = bodyType
        switch bodyType {
        case .circular(let radius):
            physicsCompBody = SKPhysicsBody(circleOfRadius: radius)
        case .fromTexture(let texture, let alphaT):
            physicsCompBody = SKPhysicsBody(texture: texture, alphaThreshold: alphaT, size: texture.size())
        }
        
        self.respondsToGravity = false
        self.isDynamic = true
        self.linearDamping = 0.1
        self.angularDamping = 0.1
        self.allowsRotation = true
        self.staticFriction = 0.1
        super.init()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didAddToEntity() {
        guard let eNode = entity?.getNode() else {
            fatalError("The entity does not have a SpriteComponent attached to it. Add this before adding a PhysicsComponent")
        }
        eNode.physicsBody = physicsCompBody
    }
}
