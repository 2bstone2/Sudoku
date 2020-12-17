//
//  GameViewController.swift
//  Sudoku
//
//  Created by Bailey Stone on 12/1/20.
//  Copyright © 2020 Bailey Stone. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    
    var sudoku = Sudoku()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(touchedScreen(touch:)))
            view.addGestureRecognizer(tap)

        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            if let scene = SKScene(fileNamed: "GameScene") {
                // Set the scale mode to scale to fit the window
                scene.scaleMode = .aspectFill
                    
                // Present the scene
                view.presentScene(scene)
                view.ignoresSiblingOrder = true
                
                view.showsFPS = true
                view.showsNodeCount = true
                
                //self.sudoku.populateArrays()
            }
        }
    }
    
    @objc func touchedScreen(touch: UITapGestureRecognizer) {
        let touchPoint = touch.location(in: self.view)
        print(touchPoint)
    }

    /*override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }*/
}
