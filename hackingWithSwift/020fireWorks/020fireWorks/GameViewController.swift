//
//  GameViewController.swift
//  020fireWorks
//
//  Created by Vaughn on 9/5/19.
//  Copyright © 2019 Vaughn Anton. All rights reserved.
//


import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                
                // Present the scene
                view.presentScene(scene)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    // if the device is shaken, blow up all fireworks
    // default view controller doesn't know it has a SpriteKit view or what scene it is showing, so we typecast so we have a reference to our gameScene then we explode the fireworks
    override func motionBegan(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        guard let skView = view as? SKView else { return }
        guard let gameScene = skView.scene as? GameScene else { return }
        gameScene.explodeFireworks()
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
