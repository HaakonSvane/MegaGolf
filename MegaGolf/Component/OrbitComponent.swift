//
//  OrbitComponent.swift
//  MegaGolf
//
//  Created by Haakon Svane on 15/03/2021.
//

import GameKit

/**
    A component for making an object orbit around a point.
    
    - Requires :
        - `NodeComponent`
        - `PhysicsComponent`
 
 */
class OrbitComponent : GKComponent {
    
    private static let ORBIT_LINE_NAME = "orbitLine"
    
    private(set) var orbiting: Bool = false
    private var angularVelocity: CGFloat
    private var angle: CGFloat
    private var radius: CGFloat
    private weak var orbitingEntity: GKEntity?
    private var orbitPoint: CGPoint
    
    private var timeElapsed: TimeInterval
    
    private(set) var orbitLine : SKShapeNode?
    
    var showingOrbitLine : Bool {
        set(newValue){
            guard showingOrbitLine != newValue else {
                return
            }
            guard orbiting else {
                print("The entity is currently not orbiting. Can not show orbit line")
                return
            }
            
            guard let node = entity?.getNode() else {
                print("The entity does not have an attached node. Add a NodeComponent before trying to show its orbit line.")
                return
            }
            
            switch newValue{
            case true:
                // If the node is orbiting, we know for certain that the instance has an orbit line, so we can force unwrap here.
                node.addChild(orbitLine!)
            case false:
                node.childNode(withName: OrbitComponent.ORBIT_LINE_NAME)?.removeFromParent()
            }
            
        }
        get{
            return entity?.getNode()?.childNode(withName: OrbitComponent.ORBIT_LINE_NAME) != nil
        }
    }

    override init(){
        self.angularVelocity = 0
        self.angle = 0
        self.radius = 0
        self.orbitPoint = .zero
        self.timeElapsed = 0
        
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func update(deltaTime seconds: TimeInterval) {
        if !orbiting{return}
        
        // If we are following an entity, update its position in case it has moved
        if let orbEnt = orbitingEntity{
            orbitPoint = orbEnt.getNode()!.position
        }
        
        self.angle += self.angularVelocity*CGFloat(seconds)
        
        // To prevent overflowing
        self.angle = (self.angle+CGFloat.pi).truncatingRemainder(dividingBy: 2*CGFloat.pi)-CGFloat.pi
        entity?.getNode()?.position.x = self.orbitPoint.x + self.radius*cos(self.angle)
        entity?.getNode()?.position.y = self.orbitPoint.y + self.radius*sin(self.angle)
        

        let s = entity?.component(ofType: ScaleComponent.self)?.scaleX ?? 1
        
        // If the entity is rotating, we must subtract its rotational angle when calculating the position (center) of the orbit line
        let r = entity?.getNode()?.zRotation ?? 0
        
        // Updating the position of the orbit line. This makes it seem still around the orbit point
        self.orbitLine?.position = .zero - CGPoint(angle: self.angle - r)*self.radius/s
    }
    
    private func handleOrbit(point: CGPoint, overrideRadius: CGFloat?, overrideSpeed: CGFloat?){
        guard let node = entity?.getNode() else{
            fatalError("The entity does not have a NodeComponent attached to it. Do this before trying to make it orbit.")
        }
        if entity?.component(ofType: PhysicsComponent.self) == nil {
            guard overrideSpeed != nil else {
                fatalError("For an entity without a PhysicsComponent, overrideSpeed must be provided")
            }
        }
        self.orbitPoint = point
        
        entity?.component(ofType: PhysicsComponent.self)?.isDynamic = false
        let speed = overrideSpeed ?? entity?.getPhysicsBody()?.velocity.length()
        self.angle = (node.position-self.orbitPoint).angle
        self.radius = overrideRadius ?? node.position.distanceTo(self.orbitPoint)
        self.angularVelocity = speed! / self.radius
        orbiting = true
        
        // If the enity is scaled, we need to take this into consideration since the orbit line is added as a child node
        // Since orbits are circular, we are assuming an even scaling, so using the x-scaling is sufficient.
        let s = entity?.component(ofType: ScaleComponent.self)?.scaleX ?? 1
        
        self.orbitLine = SKShapeNode(circleOfRadius: self.radius/s)
        self.orbitLine?.position = .zero - CGPoint(angle: self.angle)*self.radius/s
        self.orbitLine?.fillColor = .clear
        self.orbitLine?.lineWidth = 2
        self.orbitLine?.strokeColor = GLOBALCOLOR.ORBITLINE ?? GLOBALCOLOR.DEFAULT
        self.orbitLine?.name = OrbitComponent.ORBIT_LINE_NAME
        self.orbitLine?.zPosition = -1
    }
    
    /**
        Rotates around a set point in space.
        - Parameters:
            - point: The point around which to rotate.
            - overrideRadius: The radius of rotation. This defaults to the distance between the provided point and the orbiting object center.
            - overrideSpeed: The magnitude of velocity to override if a value is provided. If not provided, the object orbits with the same speed at this function call.
     */
    func orbitAround(point: CGPoint, overrideRadius: CGFloat? = nil, overrideSpeed : CGFloat? = nil){
        self.handleOrbit(point: point, overrideRadius: overrideRadius, overrideSpeed: overrideSpeed)
    }
    
    /**
        Rotates around a `GKEntity`. The orbit will follow the entity if it were to move.
        - Parameters:
            - entity: The entity to that the object should rotate around. If the entity changes position, the rotating object will follow.
            - overrideRadius: The radius of rotation. This defaults to the distance between the provided entity center and the orbiting object center.
            - overrideSpeed: The magnitude of velocity to override if a value is provided. If not provided, the object orbits with the same speed at this function call.
     */
    func orbitAround(entity: GKEntity, overrideRadius: CGFloat? = nil, overrideSpeed : CGFloat? = nil){
        orbitingEntity = entity
        self.handleOrbit(point: entity.getNode()!.position, overrideRadius: overrideRadius, overrideSpeed: overrideSpeed)
    }
    
    /**
        Rotates around a set point in space with a specified angular velocity (radians / sec).
        - Parameters:
            - point: The point around which to rotate.
            - overrideRadius: The radius of rotation. This defaults to the distance between the provided point and the orbiting object center.
            - angularVelocity: The angular velocity of the orbiting object (radians / sec).
     */
    //func orbitAround(point: CGPoint, overrideRadius: CGFloat? = nil, angularVelocity: CGFloat){
    //}
    
    /**
        Rotates around a `GKEntity` with a specified angular velocity (radians / sec). The orbit will follow the entity if it were to move.
        - Parameters:
            - entity: The entity to that the object should rotate around. If the entity changes position, the rotating object will follow.
            - overrideRadius: The radius of rotation. This defaults to the distance between the provided entity center and the orbiting object center.
            - angularVelocity: The angular velocity of the orbiting object (radians / sec).
     */
    //func orbitAround(entity: GKEntity, overrideRadius: CGFloat? = nil, angularVelocity: CGFloat){
    //}
    
    func releaseFromOrbit(makeDynamic: Bool = true){
        if !orbiting{return}
        guard let physBody = entity?.getPhysicsBody() else{
            fatalError("The entity does not have a PhysicsComponent attached to it. Do this before trying to make it orbit.")
        }
        self.orbiting = false
        physBody.isDynamic = makeDynamic
        let releaseVec = CGVector(angle: self.angle+CGFloat.pi/2)*self.angularVelocity*self.radius
        physBody.velocity = releaseVec

    }
    
}
