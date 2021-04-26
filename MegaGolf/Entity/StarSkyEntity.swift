//
//  StarSkyEntity.swift
//  MegaGolf
//
//  Created by Haakon Svane on 10/04/2021.
//

import GameKit

class StarSkyEntity : GKEntity {
    init(size: CGSize, camera: MGCameraNode){
        super.init()
        
        let nodeComp = NodeComponent()
        let tileComp = TileMapComponent(tileSetName: "SkyTileSet", size: size)
        let scaleComp = ScaleComponent(x: 1.7, y: 1.7)
        let parallComp = ParallaxComponent(strength: 0.90, camera: camera)
    
        tileComp.fill(withTileGroupName: "stars")
        
        self.addComponent(nodeComp)
        self.addComponent(tileComp)
        self.addComponent(scaleComp)
        self.addComponent(parallComp)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
