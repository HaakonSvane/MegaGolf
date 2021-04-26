//
//  ActionAnimationComponent.swift
//  MegaGolf
//
//  Created by Haakon Svane on 05/04/2021.
//

import GameKit


enum ActionAnimationOrderType{
    case parallel
    case sequence(delayBetween: TimeInterval)
}

/**
    A component for adding animations to an entity.
    
    - Requires:
        - `NodeComponent`
 */
class ActionAnimationComponent : GKComponent {
    private var commandBank : [String : [SKAction]]
    override init() {
        commandBank = [:]
        super.init()
    }
    /**
        Adds a list of `SKAction`s to the command bank with the specified name. If an animation is played in sequence, it follows the same order that the SKActions where added in (the order of the list).
     
        - Parameters:
            - actions: A list of `SKAction`s to add. See `MGAnimation` for easy creation of SKActions.
            - withName: Name of the animation.
     */
    func addAnimation(actions: [SKAction], withName: String){
        actions.forEach{addAnimation(action: $0, withName: withName)}
    }
    
    /**
        Adds a single `SKAction` to the command bank with the specified name. If an animation is played in sequence, it follows the same order that the SKActions where added in.
     
        - Parameters:
            - action: The SKAction to add. See `MGAnimation` for easy creation of SKActions.
            - withName: Name of the animation.
     */
    func addAnimation(action: SKAction, withName: String){
        if commandBank[withName] != nil{
            commandBank[withName]!.append(action)
        }else{
            commandBank[withName] = [action]
        }
    }
    
    /**
        Runs an animation from the animation command bank with a specified name. The `orderType` of the animation refers to how it should be played out;
        either in parallel (all actions are run at the same time) or in sequence (actions are run sequentially with a specified time delay). Use `onCompletion` to run a closure afterwards.
     
        - Parameters:
            - withName: The name of the animation set to run. The set must be added before calling this function using the `addAnimation` method.
            - orderType: The type of order to run the animation in; either in parallel or in sequence (with a specified time delay).
            - onCompletion: Empty closure to be run after the animation completes. Defaults to nothing.
     */
    func runAnimation(withName: String, orderType: ActionAnimationOrderType, target: SKNode? = nil,  onCompletion: @escaping () -> Void = {}){
        guard let anims = commandBank[withName] else {
            print("No animation set with name \(withName) was found in the animation bank for entity named \(String(describing: entity?.getNode()?.name)).")
            return
        }
        let animTarget: SKNode
        if let trgt = target {
            animTarget = trgt
        }else{
            animTarget = entity!.getNode()!
        }
        switch orderType{
        case .parallel:
            animTarget.run(SKAction.group(anims), completion: onCompletion)
        case .sequence(let dt):
            let newAnims = Array(anims.map { [$0] }.joined(separator: [SKAction.wait(forDuration: dt)]))
            animTarget.run(SKAction.sequence(newAnims), completion: onCompletion)
        }
    }
    
    /**
        Returns all the names of currently stored animations in the component,
        - Returns: An array of strings containing the names of the animations stored in the component.
     */
    func getAnimationNames() -> [String] {
        return Array(commandBank.keys)
    }
    
    /**
        Pairs two currently stored animations to make a new. Each of the two animations may be run in parallel or in sequence. The ordering of the pairing follows first -> second.
     
        - Parameters:
            - nameOfFirst: Name of the first currently stored animation for pairing.
            - nameOfSecond: Name of the second currently stored animation for pairing.
            - orderOfFirst: The `AnimationOrderType` to merge the first animation into.
            - orderOfSecond: The `AnimationOrderType` to merge the second animation into.
            - nameOfResult: The name of the new created animation.
     
        - Returns: A boolean value indicating the sucess of the pairing.
     */
    func pairAnimations(nameOfFirst: String,
                        nameOfSecond: String,
                        orderOfFirst: ActionAnimationOrderType,
                        orderOfSecond: ActionAnimationOrderType,
                        nameOfResult: String) -> Bool{
        
        guard let anim1 = commandBank[nameOfFirst], let anim2 = commandBank[nameOfSecond] else {
            return false
        }
        let newAnim1: SKAction
        let newAnim2: SKAction
        
        switch orderOfFirst{
        case .parallel:
            newAnim1 = SKAction.group(anim1)
            
        case .sequence(let dt):
            let tempArr = Array(anim1.map { [$0] }.joined(separator: [SKAction.wait(forDuration: dt)]))
            newAnim1 = SKAction.sequence(tempArr)
        }
        
        switch orderOfSecond{
        case .parallel:
            newAnim2 = SKAction.group(anim2)
            
        case .sequence(let dt):
            let tempArr = Array(anim2.map { [$0] }.joined(separator: [SKAction.wait(forDuration: dt)]))
            newAnim2 = SKAction.sequence(tempArr)
        }
        
        self.addAnimation(actions: [newAnim1, newAnim2], withName: nameOfResult)
        return true
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
