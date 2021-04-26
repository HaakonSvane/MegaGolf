//
//  MGLightNodeContainer.swift
//  MegaGolf
//
//  Created by Haakon Svane on 09/03/2021.
//

import SpriteKit

class SKLightNodeContainer : SKNode{
    private var numLights : Int = 0
    private var lights : [SKLightNode]
    
    
    var lightColor : UIColor {
        didSet{
            for light in lights{
                light.lightColor = lightColor
            }
        }
    }
    
    var ambientColor : UIColor {
        didSet{
            for light in lights{
                light.ambientColor = ambientColor
            }
        }
    }
    
    var shadowColor : UIColor {
        didSet{
            for light in lights{
                light.shadowColor = shadowColor
            }
        }
    }
    
    var falloff : CGFloat {
        didSet{
            for light in lights{
                light.falloff = falloff
            }
        }
    }
    
    var categoryBitMask : UInt32 {
        didSet{
            for light in lights{
                light.categoryBitMask = categoryBitMask
            }
        }
    }
    
    var isEnabled : Bool {
        didSet{
            for light in lights{
                light.isEnabled = isEnabled
            }
        }
    }
    
    /**
        Adds a new `SKLightNode` to this instance. Each node added is assigned as a child node to this instance node.
     
        - Parameters:
            - name: The name of the `SKLightNode`. If none is provided, the name of the node defaults to "light{`num`}" .
     
     */
    func addLight(name: String? = nil) -> Void {
        let lNode = SKLightNode()
        lNode.name = name ?? "light\(numLights+1)"
        self.addChild(lNode)
        lights.append(lNode)
        numLights += 1
        
    }
    
    override init(){
        lights = [SKLightNode]()
        lightColor = .white
        ambientColor = .black
        shadowColor = .black
        categoryBitMask = 0b00000
        falloff = 1
        isEnabled = true
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
