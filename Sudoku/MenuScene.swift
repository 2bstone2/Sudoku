//
//  MenuScene.swift
//  Sudoku
//
//  Created by Bailey Stone on 12/3/20.
//  Copyright © 2020 Bailey Stone. All rights reserved.
//

import SpriteKit
import GameplayKit

class Menu: SKScene {
    
    override func didMove(to view: SKView) {
        print("in menu")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if touch == touches.first {
                print("Segue to gameboard")
            }
        }
    }
}
