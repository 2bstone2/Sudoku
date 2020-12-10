//
//  MenuScene.swift
//  Sudoku
//
//  Created by Bailey Stone on 12/3/20.
//  Copyright © 2020 Bailey Stone. All rights reserved.
//

import SpriteKit
import GameplayKit

class MenuScene: SKScene {
    var background = SKNode() //Assign later with background image
    var componentLayer = SKNode()
    var playButton = SKSpriteNode()
    var playButtonLabel = SKLabelNode()
    let gameFont = "HelveticaNeue"
    
    override func didMove(to view: SKView) {
        print("in menu")
        self.addChild(componentLayer)
        self.playButton.position = CGPoint(x: 0, y: 0)
        self.playButton = SKSpriteNode(color: UIColor.systemRed, size: CGSize(width: 50, height: 25))
        self.playButton.isUserInteractionEnabled = false
        
        self.playButtonLabel.text = "Play"
        self.playButtonLabel.fontSize = 32
        self.playButtonLabel.fontName = gameFont + "-Bold"
        self.playButtonLabel.position = playButton.position
        //self.componentLayer.addChild(playButton)
        self.componentLayer.addChild(playButtonLabel)
        
    }
    
    func transition() {
        //run(buttonPressAnimation)
        let reveal = SKTransition.reveal(with: .down, duration: 1)
        let newScene = GameScene()
        newScene.scaleMode = .aspectFill
        print("in transition")
        scene?.view?.presentScene(newScene, transition: reveal)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            if touch == touches.first {
                print("Segue to gameboard")
                transition()
            }
        }
    }
}
