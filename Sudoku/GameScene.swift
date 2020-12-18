//
//  GameScene.swift
//  Sudoku
//
//  Created by Bailey Stone on 12/1/20.
//  Copyright © 2020 Bailey Stone. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    // TODO: Make a subclass
    //var arr = [[Int]](repeating: [Int](repeating: 0, count: 5), count: 5)
    var tileSize = 72.0
    var superGridArray = [[SKSpriteNode]](repeating: [SKSpriteNode](repeating: SKSpriteNode() , count: 9), count: 9) // holds outside Grids
    var choiceTileArray = [SKSpriteNode](repeating: SKSpriteNode(), count: 9)
    var choiceLabelArray = [SKLabelNode](repeating: SKLabelNode(), count: 9)
    var spikeArray = [SKSpriteNode](repeating: SKSpriteNode(), count: 3)
    var background = SKSpriteNode() // where image will be set
    var componentLayer = SKNode() // contains grid, choice tiles, timer etc
    var tileLayer = SKNode()
    let grid = Grid()
    let glowColor = "red"
    let tileImageName = "Demo_Sudoku_Tile"
    let tileFontSize: CGFloat = 40
    let gameFont = "Glypha 75 Black"//"HelveticaNeue"
    var timer: Timer? = nil
    var timerLabel = SKLabelNode()
    var multiplierLabel = SKLabelNode()
    var minutes: Int = 0
    var seconds: Int = 0 {
        didSet {
            minutes = seconds / 60 % 60
            timerLabel.text = String(format:"%02i:%02i", minutes, seconds % 60)
            //timerLabel.text = "\(seconds / 60):\(seconds % 60)"
            // change multiplier here
            if seconds % 20 == 0 && multiplier > 1 { //decrements every 20 seconds and doesnt drop below 1
                multiplier-=1
            }
        }
    }
    var scoreLabel = SKLabelNode()
    var score: Int = 0 {
        didSet {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            let formattedNumber = numberFormatter.string(from: NSNumber(value: score))
            scoreLabel.text = "score: " + formattedNumber!
        }
    }
    var multiplier: Int = 20 {
        didSet {
            multiplierLabel.text = "x" + String(multiplier)
        }
    }

    var sudoku = Sudoku()
    var choiceEffectArray = [SKEffectNode](repeating: SKEffectNode(), count: 9)
    var boardEffectArray = [[SKEffectNode]](repeating: [SKEffectNode](repeating: SKEffectNode() , count: 9), count: 9)
    var choiceBorderArray = [SKShapeNode](repeating: SKShapeNode(), count: 9)
    var boardBorderArray = [[SKShapeNode]](repeating: [SKShapeNode](repeating: SKShapeNode() , count: 9), count: 9)
    let glow: Float = 50
    let unglow: Float = 0
    var numSpikes = 0
    var pauseLabel = SKLabelNode()
    var pauseNode = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        //self.anchorPoint = CGPoint(x: frame.midX, y: frame.midY)
        print("in gameScene")
        self.componentLayer.zPosition = 1
        self.addChild(componentLayer)
        
        // pause label set up
        self.pauseLabel.text = "pause"
        self.pauseLabel.position = CGPoint(x: -255,y: 335)
        self.pauseNode = SKSpriteNode(color: .clear, size: CGSize(width: 170, height: 50))
        self.pauseLabel.fontSize = 40
        self.pauseNode.position = pauseLabel.position
        self.pauseLabel.fontName = gameFont
        self.pauseLabel.zPosition = 1
        self.pauseNode.name = "pause"
        //self.componentLayer.addChild(pauseLabel)
        self.componentLayer.addChild(pauseNode)
        
        // score label set up
        self.score = 0
        self.scoreLabel.position = CGPoint(x: -230,y: -365)
        self.scoreLabel.fontSize = 40
        self.scoreLabel.fontName = gameFont
        self.scoreLabel.zPosition = 1
        self.componentLayer.addChild(scoreLabel)
        
        // multiplier label set up
        self.multiplier = 20
        self.multiplierLabel.position = CGPoint(x: 275, y: -365)
        self.multiplierLabel.fontSize = 40
        self.multiplierLabel.fontName = gameFont
        self.multiplierLabel.zPosition = 1
        self.componentLayer.addChild(multiplierLabel)
        
        
        // timer set up
        startTimer()
        self.timerLabel.position = CGPoint(x: 0, y: 372)
        self.timerLabel.fontSize = 60
        self.timerLabel.fontName = gameFont
        self.componentLayer.addChild(timerLabel)
        
        background = SKSpriteNode(imageNamed: "SudokuBoardBackground1.png")
        background.size = CGSize(width: self.frame.width, height: self.frame.height)
        background.zPosition = -1
        background.isUserInteractionEnabled = true
        addChild(background)
        
        var xPosition = -150
        for i in 0..<3 {
            let spikeSprite = SKSpriteNode(imageNamed: "FullBulldog.png")
            spikeSprite.position = CGPoint(x: xPosition, y: -435)
            spikeSprite.setScale(0.125)
            spikeArray[i] = spikeSprite
            //self.componentLayer.addChild(spikeSprite)
            xPosition+=150
        }
    
        //"SudokuBoardBackground1.png"
        loadBoard()
        createNumberChoiceNodes()
        populateGameboard()
        initializeGlowEffectNodes()
        
    }
    
    func loadBoard() {
        if let grid = Grid(blockSize: 72, rows:9, cols:9) {
            grid.position = CGPoint (x:frame.midX, y:frame.midY)
            self.componentLayer.addChild(grid)
            
            // Populate with tiles, do later, for now populate with clear spriteNodes
            for i in 0..<9 {
                
                for j in 0..<9 {

                    let tile = SKSpriteNode(color: .clear , size: grid.size)
                    tile.setScale(1)
                    tile.position = grid.gridPosition(row: i, col: j)
                    tile.name = String(i) + String(j)
                    //tileLabel.text = tile.name
                    //tileLabel.position = tile.position
                    tile.isUserInteractionEnabled = false
                    //print(tile.name!, tileLabel.text!)
                    grid.addChild(tile)
                    self.superGridArray[i][j] = tile
                    print("tile: \(self.superGridArray[i][j].name!) position: \(self.superGridArray[i][j].position)")
                    let borderNode = SKShapeNode(rectOf: CGSize(width: 70, height: 70))
                    borderNode.position = tile.position
                    self.boardBorderArray[i][j] = borderNode
                    addChild(borderNode)
                }
            }
        }
    }
    
    func createNumberChoiceNodes() {
        //let tileSize = 72.0
        let offset = tileSize / 2.0 + 0.5
        
        // TODO: maybe add a clear tile over label and node so it can glow and this is the one that picks up on the touch
        
        for i in 1..<10 {
            let tile = SKSpriteNode(imageNamed: tileImageName)
            let tileLabel = SKLabelNode()
            tile.setScale(1)
            tileLabel.text = String(i)
            tileLabel.fontName = gameFont
            tileLabel.fontSize = 40
            tile.name = String(i)
            //let x = CGFloat(i) * tileSize - (tileSize * CGFloat(9)) / 2.0 + offset
            let x1 = CGFloat(i) * CGFloat(tileSize)
            let x2 = CGFloat(tileSize * 9 / 2.0 + offset)
            let x = (x1 - x2)
            let y = CGFloat(-550)
            tile.position = CGPoint(x: x, y: y)
            tileLabel.position = CGPoint(x: x, y: y - 12)
            tile.isUserInteractionEnabled = false
            tile.zPosition = 0
            tileLabel.zPosition = 1
            let borderNode = SKShapeNode(rectOf: CGSize(width: 70, height: 70))
            borderNode.position = tile.position
            self.choiceBorderArray[i - 1] = borderNode
            self.choiceLabelArray[i - 1] = tileLabel
            addChild(borderNode)
            self.choiceTileArray[i - 1] = tile
            self.componentLayer.addChild(tile)
            self.componentLayer.addChild(tileLabel)
        }
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (timer) in
            self.seconds += 1
        })
    }
    
    func stopTimer() {
        timer?.invalidate() //optional chaining
        timer = nil
    }
    
    func pausePressed(_ sender: UIButton) {
        print("hello from pause")
        stopTimer()
    }
    
    func initializeGlowEffectNodes() {
        for i in 0..<9 {
            let effectNode = SKEffectNode()
            self.choiceEffectArray[i] = effectNode
            self.choiceTileArray[i].initializeGlowEffectNodes(effectNode: self.choiceEffectArray[i])
            
            for j in 0..<9 {
                let effectNode1 = SKEffectNode()
                //effectNode1.
                self.boardEffectArray[i][j] = effectNode1
                self.superGridArray[i][j].initializeGlowEffectNodes(effectNode: self.boardEffectArray[i][j])
                //self.superGridArray[i][j].texture
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        //let touchedNode = grid.atPoint(positionInScene)
        let touch: UITouch = touches.first!
        let positionInScene = touch.location(in: self)
        let touchedNode = background.atPoint(positionInScene)
        let xConstraintLow = positionInScene.x - CGFloat(tileSize / 2)
        let xConstraintHigh = positionInScene.x + CGFloat(tileSize / 2)
        let yConstraintLow = positionInScene.y - CGFloat(tileSize / 2)
        let yConstraintHigh = positionInScene.y + CGFloat(tileSize / 2)
        

        for i in 0..<9 {
            choiceTileArray[i].drawBorder(color: .clear, width: 5, borderNode: choiceBorderArray[i])
           
            if choiceTileArray[i].position.x >= xConstraintLow && choiceTileArray[i].position.x <= xConstraintHigh && choiceTileArray[i].position.y >= yConstraintLow && choiceTileArray[i].position.y <= yConstraintHigh {
                //choiceTileArray[i].drawBorder(color: .clear, width: 5, borderNode: choiceBorderArray[i])
                if let name = choiceTileArray[i].name {
                    sudoku.selectedChoiceTile = Int(name)
                    // deselect and unglow previous selected
                    //choiceTileArray[i].addGlow(radius: glow, effectNode: choiceEffectArray[i])
                    choiceTileArray[i].drawBorder(color: .red, width: 5, borderNode: choiceBorderArray[i])
                    // maybe return, but probably not bc will affect unglowing
                }
            }
            else {
                if Int(choiceTileArray[i].name!) == sudoku.selectedChoiceTile {
                    choiceTileArray[i].drawBorder(color: .red, width: 5, borderNode: choiceBorderArray[i])
                }
                /*else {
                    choiceTileArray[i].drawBorder(color: .clear, width: 5, borderNode: choiceBorderArray[i])
                }*/
            }
        }
        
        
        
        
        // TODO: add glow to selected tile
        for i in 0..<9 {
            for j in 0..<9 {
               // if background.contains(positionInScene) {
                    superGridArray[i][j].drawBorder(color: UIColor.clear, width: 5, borderNode: boardBorderArray[i][j])
                //}
                if sudoku.gamePuzzle[i][j] == sudoku.selectedChoiceTile && !grid.contains(positionInScene) {
                    superGridArray[i][j].drawBorder(color: UIColor.red, width: 5, borderNode: boardBorderArray[i][j])
                    //superGridArray[i][j].addGlow(radius: glow, effectNode: boardEffectArray[i][j])
                    print("adding glow to \(superGridArray[i][j].name!)")
                }
                if superGridArray[i][j].position.x >= xConstraintLow && superGridArray[i][j].position.x <= xConstraintHigh && superGridArray[i][j].position.y >= yConstraintLow && superGridArray[i][j].position.y <= yConstraintHigh {
                    //superGridArray[i][j].addGlow(radius: glow, effectNode: boardEffectArray[i][j])
                    superGridArray[i][j].drawBorder(color: .red, width: 5, borderNode: boardBorderArray[i][j])
                    print("tile: \(superGridArray[i][j].name ?? "") was touched")
                    
                    // TODO: check if correct here
                    if sudoku.gamePuzzle[i][j] == 0 && sudoku.selectedChoiceTile == sudoku.solution[i][j] {
                        sudoku.gamePuzzle[i][j] = sudoku.selectedChoiceTile
                        let tile = SKSpriteNode(imageNamed: tileImageName)
                        let tileLabel = SKLabelNode()
                        // TODO: add label for selected node
                        tile.setScale(0.92)
                        tile.position = CGPoint(x: Int(superGridArray[i][j].position.x), y: Int(superGridArray[i][j].position.y) + Int(0.25))
                        tileLabel.position = CGPoint(x: tile.position.x, y: tile.position.y - 15)
                        tileLabel.text = String(sudoku.solution[i][j]!)
                        tileLabel.fontName = gameFont
                        tileLabel.fontSize = tileFontSize
                        tileLabel.zPosition = 1
                        componentLayer.addChild(tile)
                        componentLayer.addChild(tileLabel)
                        
                        // TODO: Call update score
                        updateScore()
                        checkIfGameWon()
                        checkIfAllTilesFound(numberToCheck: sudoku.selectedChoiceTile!)
                        //break
                    }
                   // else if {
                        //
                   // }
                    else {
                        addSpike()
                    }
                    //return
                }
            }
        }
        /* clear all highlights:
        for i in 0..<9 {
            choiceTileArray[i].drawBorder(color: .clear, width: 5, borderNode: choiceBorderArray[i])

            for j in 0..<9 {
                superGridArray[i][j].drawBorder(color: UIColor.clear, width: 5, borderNode: boardBorderArray[i][j])
            //}
            if sudoku.gamePuzzle[i][j] == sudoku.selectedChoiceTile && !grid.contains(positionInScene) {
                superGridArray[i][j].drawBorder(color: UIColor.red, width: 5, borderNode: boardBorderArray[i][j])
                //superGridArray[i][j].addGlow(radius: glow, effectNode: boardEffectArray[i][j])
                print("adding glow to \(superGridArray[i][j].name!)")
            }
            }
        }*/
        // TODO: else in background, deselect node and unglow
        //maybe a function to unglow everything
    }
    
    func populateGameboard() {
        self.sudoku.populateArrays()
        
        for i in 0..<9 {
            for j in 0..<9 {
                if sudoku.ogPuzzle[i][j] != 0 {
                    let tile = SKSpriteNode(imageNamed: tileImageName)
                    let tileLabel = SKLabelNode()
                    tileLabel.setScale(0.92)
                    tileLabel.text = String(sudoku.ogPuzzle[i][j]!)
                    tileLabel.fontName = gameFont
                    tileLabel.fontSize = 40
                    tileLabel.zPosition = 1
                    tile.name = String(i) + String(j)
                    // TODO: add label for selected node
                    tile.setScale(0.92)
                    tile.position = CGPoint(x: Int(superGridArray[i][j].position.x), y: Int(superGridArray[i][j].position.y) + Int(0.25))
                    tileLabel.position = CGPoint(x: Int(superGridArray[i][j].position.x), y: Int(superGridArray[i][j].position.y - 15) + Int(0.25))
                    print(tile.position)
                    componentLayer.zPosition = 1
                    componentLayer.addChild(tile)
                    componentLayer.addChild(tileLabel)
                }
            }
        }
    }
    
    func updateScore() {
        score += multiplier * 5
    }
    
    func checkIfAllTilesFound(numberToCheck: Int) {
        var numCount: Int = 0
        for i in 0..<9 {
            for j in 0..<9 {
                if sudoku.gamePuzzle[i][j] == numberToCheck {
                    numCount += 1
                }
            }
        }
        if numCount == 9 {
            for i in 0..<9 {
                if choiceTileArray[i].name == String(numberToCheck) {
                    choiceTileArray[i].isUserInteractionEnabled = true
                    choiceTileArray[i].removeFromParent()
                    choiceEffectArray[i].removeFromParent()
                    choiceBorderArray[i].removeFromParent()
                    choiceLabelArray[i].removeFromParent()
                }
            }
        }
    }
    
    func addSpike() {
        spikeArray[numSpikes].addGlow(radius: 50)
        spikeArray[numSpikes].isUserInteractionEnabled = true
        self.componentLayer.addChild(spikeArray[numSpikes])
        numSpikes+=1
        
        print("num spikes: \(numSpikes)")
        if numSpikes == 3 {
            gameOver()
        }
    }
    
    func checkIfGameWon() {
        for i in 0..<9 {
            for j in 0..<9 {
                if sudoku.gamePuzzle[i][j]! == 0 {
                    return
                }
            }
        }
        stopTimer()
        print("GAME WON")
        gameOver()
        //TODO: game won
    }
    
    func gameOver() {
        //stop timer
        print("num spikes: \(self.numSpikes)")
        print("GAME OVER")
        stopTimer()
        score = 0
        seconds = 0
        transition()
        //display score
    }
    
    func transition() {
        if let view = self.view {
            // Load the SKScene from 'GameScene.sks'
            if let menuScene = MenuScene(fileNamed: "MenuScene") {
                // Set the scale mode to scale to fit the window
                //self.menuScene = menuScene
                menuScene.scaleMode = .aspectFill
                //menuScene.playButtonLabel.text = "play again"
                    // Present the scene
                print("hit1")
                self.view?.presentScene(menuScene)
                self.view?.ignoresSiblingOrder = true
                print("hit1.5")
                self.view?.showsFPS = true
                view.showsNodeCount = true
                //self.isPaused = true
                print("hit2")
            }
        }
        print("hit3")
        //newScene.playButtonLabel.text = "play again"
        let reveal = SKTransition.reveal(with: .down, duration: 6)
        let newScene = MenuScene()
        newScene.playButtonLabel.text = "play again"
        //self.newScene.scaleMode = .aspectFill
        
        print("in transition in game scene")
        scene?.view?.presentScene(newScene, transition: reveal)
    }
    
}
// MARK: - Grid
class Grid: SKSpriteNode {
    var rows: Int!
    var cols: Int!
    var tileSize: CGFloat!

    convenience init?(blockSize: CGFloat,rows: Int, cols: Int) {
        guard let texture = Grid.gridTexture(blockSize: blockSize,rows: rows, cols:cols) else {
            return nil
        }
        self.init(texture: texture, color:SKColor.clear, size: texture.size())
        self.tileSize = blockSize
        self.rows = rows
        self.cols = cols
    }

    class func gridTexture(blockSize: CGFloat, rows: Int, cols: Int) -> SKTexture? {
        // Add 1 to the height and width to ensure the borders are within the sprite
        let size = CGSize(width: CGFloat(cols) * blockSize + 1.0, height: CGFloat(rows) * blockSize + 2.0)
        UIGraphicsBeginImageContext(size)

        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        let outerBezierPath = UIBezierPath()
        let bezierPath = UIBezierPath()
        let offset: CGFloat = 0.5
        
        // Draw outer grid
        // Draw vertical lines
        for i in 0...3 {
            let outerX = (3 * CGFloat(i) * blockSize) + offset
            outerBezierPath.move(to: CGPoint(x: outerX, y: 0))
            outerBezierPath.addLine(to: CGPoint(x: outerX, y: size.height + 20))
        }
        // Draw horizontal lines
        for i in 0...3 {
            let outerY = (3 * CGFloat(i) * blockSize) + offset
            outerBezierPath.move(to: CGPoint(x: 0, y: outerY))
            outerBezierPath.addLine(to: CGPoint(x: size.width + 20, y: outerY))
        }
        
        
        // Draw vertical lines
        for i in 0...cols {
            let x = CGFloat(i) * blockSize + offset
            bezierPath.move(to: CGPoint(x: x, y: 0))
            bezierPath.addLine(to: CGPoint(x: x, y: size.height))
        }
        // Draw horizontal lines
        for i in 0...rows {
            let y = CGFloat(i) * blockSize + offset
            bezierPath.move(to: CGPoint(x: 0, y: y))
            bezierPath.addLine(to: CGPoint(x: size.width, y: y))
        }
        SKColor.white.setStroke()
        outerBezierPath.lineWidth = 12.0
        bezierPath.lineWidth = 3.0
        
        outerBezierPath.stroke()
        bezierPath.stroke()
        
        context.addPath(bezierPath.cgPath)
        context.addPath(outerBezierPath.cgPath)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return SKTexture(image: image!)
    }

    func gridPosition(row:Int, col:Int) -> CGPoint {
        let offset = tileSize / 2.0 + 0.5
        let x = CGFloat(col) * tileSize - (tileSize * CGFloat(cols)) / 2.0 + offset
        let y = CGFloat(rows - row - 1) * tileSize - (tileSize * CGFloat(rows)) / 2.0 + offset
        return CGPoint(x: x, y: y)
    }
}

extension SKSpriteNode {
    func drawBorder(color: UIColor, width: CGFloat, borderNode: SKShapeNode ) {
        borderNode.fillColor = .clear
        borderNode.strokeColor = color
        borderNode.alpha = 0.65
        borderNode.lineWidth = width
        borderNode.glowWidth = 10
        borderNode.zPosition = 2
    }
    func initializeGlowEffectNodes(effectNode: SKEffectNode) {
        self.addChild(effectNode)
        effectNode.addChild(SKSpriteNode(texture: texture))
        effectNode.zPosition = 1
    }

    func addGlow(radius: Float) {

        let effectNode = SKEffectNode()
        effectNode.shouldRasterize = true
        //addChild(effectNode)
        effectNode.addChild(SKSpriteNode(texture: texture))
        effectNode.filter = CIFilter(name: "CIGaussianBlur", parameters: ["inputRadius": radius])
}

    
}
