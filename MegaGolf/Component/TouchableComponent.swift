//
//  ClickableCompoment.swift
//  MegaGolf
//
//  Created by Haakon Svane on 02/03/2021.
//

import GameplayKit



protocol InternalTouchEventDelegate : AnyObject{
    func _onTouchDown(touches: Set<UITouch>,event: UIEvent?) -> Void
    func _onTouchUp(touches: Set<UITouch>,event: UIEvent?) -> Void
    func _onTouchMove(touches: Set<UITouch>,event: UIEvent?) -> Void
    func _onTouchCancelled(touches: Set<UITouch>,event: UIEvent?) -> Void
}

/**
    A component for adding a touch listener to the entity. Custom behavior is set by specifying the touch methods.
    
    - Requires :
        - `NodeComponent`
 
 */

class TouchableCompoment : GKComponent, InternalTouchEventDelegate{
    
    var onTouchDown : ((Set<UITouch>, UIEvent?)->Void)?
    var onTouchUp : ((Set<UITouch>, UIEvent?)->Void)?
    var onTouchMove : ((Set<UITouch>, UIEvent?)->Void)?
    var onTouchCancelled : ((Set<UITouch>, UIEvent?)->Void)?
    
    func _onTouchDown(touches: Set<UITouch>, event: UIEvent?){
        self.onTouchDown?(touches, event)
    }
    
    func _onTouchUp(touches: Set<UITouch>, event: UIEvent?){
        self.onTouchUp?(touches, event)
    }
    
    func _onTouchMove(touches: Set<UITouch>, event: UIEvent?){
        self.onTouchMove?(touches, event)
    }
    
    func _onTouchCancelled(touches: Set<UITouch>, event: UIEvent?){
        self.onTouchCancelled?(touches, event)
    }
    
    override init(){
        self.onTouchDown = {touches, event in}
        self.onTouchUp = {touches, event in}
        self.onTouchMove = {touches, event in}
        self.onTouchCancelled = {touches, event in}
        super.init()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func didAddToEntity() {
        guard let eNode = entity?.getNode() else {
            fatalError("The entity does not have a NodeComponent yet. Add this first.")
        }
        eNode.isUserInteractionEnabled = true
        eNode.touchDelegate = self
    }
    
    func reset(){
        self.onTouchUp = {touches, event in}
        self.onTouchDown = {touches, event in}
        self.onTouchMove = {touches, event in}
        self.onTouchCancelled = {touches, event in}
    }
}
