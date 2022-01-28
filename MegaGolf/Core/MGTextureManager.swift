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
    private var loadedDataNames: [String]
    var dispatchGroup: DispatchGroup?
    
    static var shared: MGTextureManager{
        get{
            if let inst = MGTextureManager.instance{
                return inst
            }else{
                let inst = MGTextureManager()
                MGTextureManager.instance = inst

                return inst
            }
        }
    }
    
    private init() {
        self.loadedDataNames = []
    }
    
    func flush() {
        self.loadedDataNames.removeAll()
    }
    
    func getAtlas(named: String) -> SKTextureAtlas {
        var atl = SKTextureAtlas()
        if self.loadedDataNames.contains(named) {
            return SKTextureAtlas(named: named)
        }
        if let q = self.dispatchGroup {
            q.enter()
            atl = SKTextureAtlas(named: named)
            atl.preload {
                print("Finished preloading " + named + " atlas...")
                q.leave()
            }
        }else{
            atl = SKTextureAtlas(named: named)
            atl.preload {}
        }
        self.loadedDataNames.append(named)
        return atl
    }
    
    func getRawTexture(named: String) -> SKTexture {
        var tex = SKTexture()
        if self.loadedDataNames.contains(named) {
            return SKTexture(imageNamed: named)
        }
        if let q = self.dispatchGroup {
            q.enter()
            tex = SKTexture(imageNamed: named)
            tex.preload {
                print("Finished preloading " + named + " texture...")
                q.leave()
            }
        }else{
            tex = SKTexture(imageNamed:  named)
            tex.preload {}
        }
        self.loadedDataNames.append(named)
        return tex
    }
}
