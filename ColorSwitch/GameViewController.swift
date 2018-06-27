//
//  GameViewController.swift
//  ColorSwitch
//
//  Created by Anonymer Eintrag on 06.06.18.
//  Copyright © 2018 hs-rm.de. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let value = UIInterfaceOrientation.landscapeRight.rawValue
        UIDevice.current.setValue(value, forKey: "orientation")
        
        if let view = self.view as! SKView? {
            let scene = GameScene(size: view.bounds.size)
            view.showsFPS = true
            view.showsNodeCount = true
            view.ignoresSiblingOrder = true
            scene.scaleMode = .resizeFill
            view.presentScene(scene)
        }
    }
    
    
    
    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        /*if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }*/
        return .landscapeRight
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
