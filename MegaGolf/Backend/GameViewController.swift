//
//  GameViewController.swift
//  MegaGolf
//
//  Created by Haakon Svane on 02/03/2021.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNeedsStatusBarAppearanceUpdate()
        self.setNeedsUpdateOfScreenEdgesDeferringSystemGestures()
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .landscape
        } else {
            return .landscape
        }
    }
    
    override var preferredScreenEdgesDeferringSystemGestures: UIRectEdge {
        return [.bottom,.top]
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
