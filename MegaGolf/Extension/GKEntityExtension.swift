//
//  GKEntityExtension.swift
//  MegaGolf
//
//  Created by Haakon Svane on 09/03/2021.
//

/**
    The contents of this file serves to extend functionallity of the `GKEntity` class since inheriting it for custom entity behaviour proves difficult.
    The functionalities provided in this file is (to be) used between components.
 */

import GameKit

extension GKEntity{
    /**
        Returns  (if any)  `SKNode` that is attached to the entity.

        - Returns: The `SKNode` that is associated with the entity or `nil` if a any node component is not found.
    */
    func getNode() -> MGNode?{
        guard let compNode = component(ofType: NodeComponent.self)?.node else {
            return nil
        }
        return compNode
    }
    
    /**
     Checks if the entity has an assigned node to it. Use `getNode()` if you want the actual node in return.
     
     - Returns: Boolean value based on the existance of a node.
    */
    func hasNode() -> Bool{
        return getNode() != nil
    }
    
    /**
     Retuns (if any) `MGSpriteNode` that is attached to the entity.
     
     - Returns: The `MGSpriteNode` that is associated with the entity or `nil` if a `SpriteComponent` is not found.
     */
    func getSpriteNode() -> SKSpriteNode? {
        guard let sprNode = component(ofType: SpriteComponent.self)?.spriteNode else{
            return nil
        }
        return sprNode
    }
    
    /**
        Returns (if any) `SKPhysicsBody` that is attached to the entity.
        
        - Returns: A `SKPhysicsBody` instance that is associated with the entity or `nil` if not found.
     */
    func getPhysicsBody() -> SKPhysicsBody? {
        guard let physNode = getNode()?.physicsBody else {
            return nil
        }
        return physNode
    }
}
