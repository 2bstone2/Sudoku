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
    var background = SKSpriteNode() // where image will be set
    var componentLayer = SKNode() // contains grid, choice tiles, timer etc
    var tileLayer = SKNode()
    let grid = Grid()
    let tileImageName = "Demo_Sudoku_Tile"
    let gameFont = "HelveticaNeue"
    var timer: Timer? = nil
    var timerLabel = SKLabelNode()
    var minutes: Int = 0
    var seconds: Int = 0 {
        didSet {
            minutes = seconds / 60 % 60
            timerLabel.text = String(format:"%02i:%02i", minutes, seconds % 60)
            //timerLabel.text = "\(seconds / 60):\(seconds % 60)"
        }
    }
    var scoreLabel = SKLabelNode()
    var score: Int = 0 {
        didSet {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .decimal
            let formattedNumber = numberFormatter.string(from: NSNumber(value: score))
            scoreLabel.text = "Score: " + formattedNumber!
        }
    }
    var sudoku = Sudoku()
    
    override func didMove(to view: SKView) {
        //self.anchorPoint = CGPoint(x: frame.midX, y: frame.midY)
        print("in gameScene")
        self.componentLayer.zPosition = 1
        self.addChild(componentLayer)
        
        // score label set up
        self.score = 0
        self.scoreLabel.position = CGPoint(x: -245,y: -365)
        self.scoreLabel.fontSize = 40
        self.scoreLabel.fontName = gameFont + "-Bold"
        self.scoreLabel.zPosition = 1
        self.componentLayer.addChild(scoreLabel)
        
        // timer set up
        startTimer()
        self.timerLabel.position = CGPoint(x: 0, y: 372)
        self.timerLabel.fontSize = 50
        self.timerLabel.fontName = gameFont + "-Bold"
        self.componentLayer.addChild(timerLabel)
        
        background = SKSpriteNode(imageNamed: "SudokuBoardBackground1.png")
        background.size = CGSize(width: self.frame.width, height: self.frame.height)
        background.zPosition = -1
        addChild(background)
        
        //"SudokuBoardBackground1.png"
        loadBoard()
        createNumberChoiceNodes()
        populateGameboard()
    }
    
    func loadBoard() {
        if let grid = Grid(blockSize: 72, rows:9, cols:9) {
            grid.position = CGPoint (x:frame.midX, y:frame.midY)
            self.componentLayer.addChild(grid)
            
            // Populate with tiles, do later, for now populate with clear spriteNodes
            for i in 0..<9 {
                
                for j in 0..<9 {
                    //let tile = SKSpriteNode(imageNamed: "tileImageName")
                    let tile = SKSpriteNode(color: .clear , size: grid.size)
                    let tileLabel = SKLabelNode()
                    tile.setScale(1)
                    tile.position = grid.gridPosition(row: i, col: j)
                    tile.name = String(i) + String(j)
                    tileLabel.text = tile.name
                    tileLabel.position = tile.position
                    tile.isUserInteractionEnabled = false
                    print(tile.name!, tileLabel.text!)
                    grid.addChild(tile)
                    grid.addChild(tileLabel)
                    self.superGridArray[i][j] = tile
                    print("tile: \(self.superGridArray[i][j].name!) position: \(self.superGridArray[i][j].position)")
                    //print(superGridArray[i][j].name!)
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
            tileLabel.fontName = gameFont + "-Bold"
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        //let touchedNode = grid.atPoint(positionInScene)
        let touch: UITouch = touches.first!
        let positionInScene = touch.location(in: self)
        let xConstraintLow = positionInScene.x - CGFloat(tileSize / 2)
        let xConstraintHigh = positionInScene.x + CGFloat(tileSize / 2)
        let yConstraintLow = positionInScene.y - CGFloat(tileSize / 2)
        let yConstraintHigh = positionInScene.y + CGFloat(tileSize / 2)
        
        for i in 0..<9 {
            for j in 0..<9 {
                if superGridArray[i][j].position.x >= xConstraintLow && superGridArray[i][j].position.x <= xConstraintHigh && superGridArray[i][j].position.y >= yConstraintLow && superGridArray[i][j].position.y <= yConstraintHigh {
                    print("tile: \(superGridArray[i][j].name ?? "") was touched")
                    let tile = SKSpriteNode(imageNamed: tileImageName)
                    // TODO: add label for selected node
                    tile.setScale(0.92)
                    tile.position = CGPoint(x: Int(superGridArray[i][j].position.x), y: Int(superGridArray[i][j].position.y) + Int(0.25))
                    print(tile.position)
                    componentLayer.zPosition = 1
                    componentLayer.addChild(tile)
                    return
                }
            }
        }
        for i in 0..<9 {
            if choiceTileArray[i].position.x >= xConstraintLow && choiceTileArray[i].position.x <= xConstraintHigh && choiceTileArray[i].position.y >= yConstraintLow && choiceTileArray[i].position.y <= yConstraintHigh {
                if let name = choiceTileArray[i].name {
                    print("tile \(name) touched, i + 1 check: \(i + 1)")
                }
            }
            
        }
        // TODO: else in background, deselect node
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
}

class Grid: SKSpriteNode {
    var rows: Int!
    var cols: Int!
    var tileSize: CGFloat!

    convenience init?(blockSize:CGFloat,rows:Int,cols:Int) {
        guard let texture = Grid.gridTexture(blockSize: blockSize,rows: rows, cols:cols) else {
            return nil
        }
        self.init(texture: texture, color:SKColor.clear, size: texture.size())
        self.tileSize = blockSize
        self.rows = rows
        self.cols = cols
    }

    class func gridTexture(blockSize:CGFloat, rows:Int, cols:Int) -> SKTexture? {
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
            print("vert outerX: \(outerX)")
            outerBezierPath.move(to: CGPoint(x: outerX, y: 0))
            outerBezierPath.addLine(to: CGPoint(x: outerX, y: size.height + 20))
        }
        // Draw horizontal lines
        for i in 0...3 {
            let outerY = (3 * CGFloat(i) * blockSize) + offset
            print("horiz outerY: \(outerY)")
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
    func drawBorder(color: UIColor, width: CGFloat) {
        let shapeNode = SKShapeNode(rect: frame)
        shapeNode.fillColor = .clear
        shapeNode.strokeColor = color
        shapeNode.lineWidth = 3
        addChild(shapeNode)
    }

    func addGlow(radius: Float = 30) {
        /*let ball = SKShapeNode()
        ball.lineWidth = 1
        ball.fillColor = .blue
        ball.strokeColor = .white
        ball.glowWidth = 0.5*/
        
        let effectNode = SKEffectNode()
        effectNode.shouldRasterize = true
        addChild(effectNode)
        effectNode.addChild(SKSpriteNode(texture: texture))
        effectNode.filter = CIFilter(name: "CIGaussianBlur", parameters: ["inputRadius":radius])
    }

}
