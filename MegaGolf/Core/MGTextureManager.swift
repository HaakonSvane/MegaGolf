//
//  MGTextureManager.swift
//  MegaGolf
//
//  Created by Haakon Svane on 20/04/2021.
//

import SpriteKit

/** WORK IN PROGRESS. WILL NOT BE INTEGRATED  WITH THE PROJECT BUILD.
        This singleton instance is responsible for managing all the textures in the game.
        Most of the time, entities are created at initialization time (async work on background thread) and not while the game is active. The idea for this manager is
        to make it dynamic so that it makes a list of all the textures needed by communicating with the `GKComponent`s that need it.
        For example. Lets say that when loading the menus, only 3 out of 10 available planet images are needed. When a `SpriteComponent` requests the planet texture from the manager, the manager adds this texture to a loading queue which can be activated externally.
        Here is an example of what I think it would look like in the `MGPresenter`:
 
        ```
            let texMan = MGTextureManager.shared
            // Initialization of all the entities required for the scene
            texMan.preloadTextures()
        ```
                
 */


class MGTextureManager{
    
    var UITextures: SKTextureAtlas?
    var starTextures: SKTextureAtlas?
    var starSkyTextures: SKTextureAtlas?
    var normalTextures: [String : SKTexture]?
    
    private static var instance: MGTextureManager?
    
    static var shared: MGTextureManager{
        get{
            if let inst = MGTextureManager.instance{
                return inst
            }else{
                let inst = MGTextureManager()
                
                /**
                    TODO:
                        - Get all Textures with a normal and add them to a hash map with [textureName : SKTexture]
                        - Preload all the textures in the hash map and reference them in the singeton instance
                 */
                
                func referencePlanetTexturesWrapper(){
                    inst.referencePlanetTextures([:])
                }
                
                SKTextureAtlas.preloadTextureAtlasesNamed(["UITexture", "Stars", "StarSky"],
                                                          withCompletionHandler: {err, atlases in inst.referenceAtlases(atlases)})
                SKTexture.preload([], withCompletionHandler: {referencePlanetTexturesWrapper()})
                return inst
            }
        }
    }
    
    private func referenceAtlases(_ atlases: [SKTextureAtlas]){
        self.UITextures = atlases[0]
        self.starTextures = atlases[1]
        self.starSkyTextures = atlases[2]
    }
    
    private func referencePlanetTextures(_ textures: [String : SKTexture]){
        return
    }
    
    private init() {
        
    }
}
