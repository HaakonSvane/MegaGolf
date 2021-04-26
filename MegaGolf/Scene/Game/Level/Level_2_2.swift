//
//  Level_2_2.swift
//  MegaGolf
//
//  Created by Haakon Svane on 19/04/2021.
//

import GameKit

class Level_2_2 : MGGameScene, MGLevelSceneProtocol{
    required init(viewSize: CGSize, onlineMatch: GKMatch?){
        let bounds = CGRect(x: -800, y: -800, width: 4000, height: 1600)
        let start = CGPoint(x: -100, y: 0)
        let end = CGPoint(x: 1900, y: 0)
        super.init(viewSize: viewSize,
                   gameBounds: bounds,
                   playerStartPos: start,
                   goalPos: end,
                   goalRadius: 70,
                   levelPar: 10,
                   onlineMatch: onlineMatch)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
