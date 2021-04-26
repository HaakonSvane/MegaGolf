//
//  ParallaxComponent.swift
//  MegaGolf
//
//  Created by Haakon Svane on 10/04/2021.
//

import GameKit

/**
    A component for adding a parallax effect to the entity. Set the parallax strength with the `strength` variable and enable/disable the effect using the `isActive` variable.
    
    - Requires :
        - `NodeComponent`
 
 */

class ParallaxComponent : GKComponent {
    weak var camera : MGCameraNode?
    private var anchorPoint : CGPoint
    
    var isActive : Bool {
        willSet(newValue){
            guard let entNode = entity?.getNode() else {
                fatalError("There is no NodeComponent attached to this entity. Do this before adding a ParallaxComponent.")
            }
            if newValue == isActive {return}
            if newValue {
                anchorPoint = entNode.position
            }
        }
    }
    
    var strength : CGFloat {
        didSet{
            strength = strength.clamped(to: 0...1.0)
        }
    }
    
    init(strength : CGFloat, camera: MGCameraNode) {
        self.camera = camera
        self.strength = strength.clamped(to: 0...1.0)
        self.anchorPoint = .zero
        self.isActive = false
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func didAddToEntity() {
        self.isActive = true
    }
    
    
    override func update(deltaTime seconds: TimeInterval) {
        guard let cam = camera else {
            return
        }
        guard isActive else {
            return
        }
        guard let entNode = entity?.getNode() else {
            return
        }
        entNode.position = (cam.position - anchorPoint) * strength
        
        var scale : CGFloat
        if let s = entity?.component(ofType: ScaleComponent.self)?.scaleX {
            scale = s
        }else{
            scale = entNode.xScale
        }
        scale = (cam.xScale == 1) ? scale : scale*cam.xScale*strength
        entNode.setScale(scale)
        
    }
}
