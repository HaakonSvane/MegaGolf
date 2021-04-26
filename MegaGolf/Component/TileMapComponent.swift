//
//  TileMapComponent.swift
//  MegaGolf
//
//  Created by Haakon Svane on 10/04/2021.
//

import GameKit


/**
    A component for adding a tile map to the entity.
    
    - Requires :
        - `NodeComponent`
 
 */

class TileMapComponent : GKComponent {
    private let tileMap : SKTileMapNode
    
    convenience init(tileSetName: String, size: CGSize){
        guard let tileSet = SKTileSet(named: tileSetName) else {
            fatalError("The tile set with name \(tileSetName) could not be found!")
        }
        let rows = ceil(size.width/tileSet.defaultTileSize.width)
        let cols = ceil(size.height/tileSet.defaultTileSize.height)
        self.init(tileSetName: tileSetName, columns: Int(cols), rows: Int(rows))
    }
    
    init(tileSetName: String, columns: Int, rows: Int){
        guard let tileSet = SKTileSet(named: tileSetName) else {
            fatalError("The tile set with name \(tileSetName) could not be found!")
        }
        self.tileMap = SKTileMapNode(tileSet: tileSet, columns: columns, rows: rows, tileSize: tileSet.defaultTileSize)
        super.init()
        
    }
    
    override func didAddToEntity() {
        guard let eNode = entity?.getNode() else {
            fatalError("The entity does not have a NodeComponent yet. Add this before adding the TileMapComponent.")
        }
        eNode.addChild(tileMap)
    }
    
    func fill(withTileGroupName: String){
        guard let group = tileMap.tileSet.tileGroups.first(where: {$0.name == withTileGroupName}) else {
            print("Found no tile group with name \(withTileGroupName)")
            return
        }
        tileMap.fill(with: group)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
