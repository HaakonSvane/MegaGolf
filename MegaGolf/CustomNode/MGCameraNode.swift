//
//  MGCameraNode.swift
//  MegaGolf
//
//  Created by Haakon Svane on 30/03/2021.
//

import GameKit

class MGCameraNode : SKCameraNode {
    private weak var following: GKEntity?
    private var deadZone: CGRect
    private let sceneSize : CGSize
    private static let debugShow : Bool = false
    var cameraSpeed: CGFloat = 30
    
    // Relative positioning of the deadzone. x and y are the offset factors (of the screen size) for the lower left corner of the zone
    // and width and height refers to its dimensions
    var deadZoneFactor: CGRect {
        didSet{
            deadZone = CGRect(x: self.sceneSize.width*(deadZoneFactor.minX-1/2),
                              y: self.sceneSize.height*(deadZoneFactor.minY-1/2),
                              width: self.sceneSize.width*deadZoneFactor.width,
                              height: self.sceneSize.height*deadZoneFactor.height)
            
            if MGCameraNode.debugShow{
                self.childNode(withName: "deadZoneShape")?.removeFromParent()
                let deadZoneShape = SKShapeNode(rect: deadZone)
                deadZoneShape.name = "deadZoneShape"
                deadZoneShape.fillColor = .clear
                deadZoneShape.strokeColor = GLOBALCOLOR.DEFAULT
                self.addChild(deadZoneShape)
            }
        }
    }
    
    
    var center : CGPoint {
        return deadZone.origin + CGPoint(x:deadZone.width/2, y:deadZone.height) + self.position
    }
    
    init(sceneSize: CGSize){
        self.sceneSize = sceneSize
        deadZone = CGRect(x: -1, y: -1, width: 2, height: 2)
        deadZoneFactor = CGRect(x: 0, y: 0, width: 0, height: 0)
        super.init()
        
        if MGCameraNode.debugShow{
            let deadZoneShape = SKShapeNode(rect: deadZone)
            deadZoneShape.name = "deadZoneShape"
            deadZoneShape.fillColor = .clear
            deadZoneShape.strokeColor = GLOBALCOLOR.DEFAULT
            self.addChild(deadZoneShape)
        }
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var isFollowing : Bool {
        return (following != nil)
    }
    
    func followEntity(_ entity : GKEntity?){
        guard let ent = entity else {
            following = nil
            return
        }
        guard ent.getNode() != nil else{
            fatalError("The entity to follow must contain a NodeComponent!")
        }

        following = ent
    }
    
    func stopFollowing(){
        following = nil
    }
    
    private static func cameraSpeedFunc(distance: CGFloat) -> CGFloat{
        let cutoffDistance : Float = 300
        return CGFloat(simd_smoothstep(0, cutoffDistance, Float(distance)))
    }
    
    func update(deltaTime seconds : TimeInterval){
        if !isFollowing {return}
        let dRect = deadZone.offsetBy(dx: self.position.x, dy: self.position.y)
        let fPos = following!.getNode()!.sceneCoordinates!
        let dVec = dRect.displacementVector(point: fPos)
        if dVec != .zero {
            self.position += CGPoint(angle: dVec.angle)*MGCameraNode.cameraSpeedFunc(distance: dVec.length())*cameraSpeed
        }
        
    }
}
