//
//  SpriteComponent.swift
//  MegaGolf
//
//  Created by Haakon Svane on 02/03/2021.
//

import GameplayKit

/**
    A component for adding a sprite to the entity. Can be initialized with either a texture atlas or straight from file with a specified filename.
    
    - Requires :
        - `NodeComponent`
 
 */

class SpriteComponent : GKComponent{
    
    static let nMap_extension : String = "_nMap"
    let spriteNode : SKSpriteNode
    private var atlasName: String?
    private(set) var isAnimated : Bool
    private var animationFrames : [SKTexture]
    
    init(textureName: String, addNormalMap: Bool = false){
        self.isAnimated = false
        let tex = MGTextureManager.shared.getRawTexture(named: textureName)
        self.spriteNode = SKSpriteNode(texture: tex, color: .clear, size: tex.size())
        
        if addNormalMap {
            let nTex = SKTexture(imageNamed: textureName + SpriteComponent.nMap_extension)
            spriteNode.normalTexture = nTex
        }
        self.animationFrames = []
        super.init()
    }
    
    init(atlasName: String, initTextureName: String, isAnimated: Bool = false, genericName: String? = nil){
        self.atlasName = atlasName
        let atl = MGTextureManager.shared.getAtlas(named: atlasName)
        let tex = atl.textureNamed(initTextureName)
        self.spriteNode = SKSpriteNode(texture: tex, color: .clear, size: tex.size())
        self.isAnimated = isAnimated
        self.animationFrames = []
        super.init()
        
        if isAnimated {
            guard let name = genericName else {
                fatalError("When animating a sprite from an atlas, make sure to supply its generic name (atlas name)")
            }
            let filteredNames = atl.textureNames.filter{$0.contains(name)}
            for i in 1...filteredNames.count{
                animationFrames.append(atl.textureNamed("\(name)\(i)"))
            }
            // This loop is here to make the animation loop back and forth. I could have added this step in the previous loop, but thinking was not on the agenda when writing this.
            for i in (2...filteredNames.count-1).reversed(){
                animationFrames.append(atl.textureNamed("\(name)\(i)"))
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didAddToEntity() {
        guard let eNode = entity?.getNode() else{
            fatalError("The entity does not have a NodeComponent attached to it. Add this before adding a SpriteComponent")
        }
        eNode.addChild(self.spriteNode)
    }
    
    func setTexture(textureName: String){
        if let atlName = atlasName{
            let atl = SKTextureAtlas(named: atlName)
            self.spriteNode.run(SKAction.setTexture(atl.textureNamed(textureName), resize: false))
        }else{
            self.spriteNode.run(SKAction.setTexture(SKTexture(imageNamed: textureName), resize: false))
        }
    }
    
    func runAnimation(){
        guard let node = entity?.getNode() else{
            print("Tried to animate an entity without a NodeComponent. Add this first.")
            return
        }
        guard isAnimated else{
            print("Tried to animate entity named " + (node.name ?? "[NONE]") + ", but isAnimated was never set to true upon SpriteComponent initialization.")
            return
        }
        let animAction = SKAction.animate(with: self.animationFrames, timePerFrame: 0.05, resize: false, restore: true)
        spriteNode.run(SKAction.repeatForever(animAction), withKey: "spriteAnimation")

    }
    
    func stopAnimation(){
        guard let node = entity?.getNode() else{
            print("Tried to stop animation for an entity without a NodeComponent. Add this first.")
            return
        }
        guard isAnimated else{
            print("Tried to stop animation for entity named " + (node.name ?? "[NONE]") + ", but isAnimated was never set to true upon SpriteComponent initialization.")
            return
        }
        spriteNode.removeAction(forKey: "spriteAnimation")
    }
}
