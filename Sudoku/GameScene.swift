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
    var superGridArray = [[SKSpriteNode]]() // holds outside Grids
    var background = SKNode() // where image will be set
    var componentLayer = SKNode() // contains grid, choice tiles, timer etc
    var tileImageName = "Demo_Sudoku_Tile"
    var timer: Timer? = nil
    var timerLabel = SKLabelNode()
    var seconds: Int = 0 {
        didSet {
            timerLabel.text = "\(seconds / 60):\(seconds % 60)"
        }
    }
    
    override func didMove(to view: SKView) {
        self.addChild(componentLayer)
        startTimer()
        self.timerLabel.position = CGPoint(x: 0, y: 525)
        self.timerLabel.fontSize = 40
        self.timerLabel.fontName = "HelveticaNeue-Bold"
        self.componentLayer.addChild(timerLabel)
        
        // TODO: Load GU theme image later
        self.backgroundColor = UIColor.systemGray2
        
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
                    //self.superGridArray[i][j] = tile
                    //print(superGridArray[i][j].name!)
                }
            }
        }
        createNumberChoiceNodes()

    }
    
    func createNumberChoiceNodes() {
        let tileSize = 72.0
        let offset = tileSize / 2.0 + 0.5
        
        for i in 1..<10 {
            let tile = SKSpriteNode(imageNamed: tileImageName)
            let tileLabel = SKLabelNode()
            tile.setScale(1)
            tileLabel.text = String(i)
            tileLabel.fontName = tileLabel.fontName! + "-Bold"
            tile.name = String(i)
            //let x = CGFloat(i) * tileSize - (tileSize * CGFloat(9)) / 2.0 + offset
            let x1 = CGFloat(i) * CGFloat(tileSize)
            let x2 = CGFloat(tileSize * 9 / 2.0 + offset)
            let x = (x1 - x2)
            let y = CGFloat(-550)
            tile.position = CGPoint(x: x, y: y)
            tileLabel.position = CGPoint(x: x, y: y - 8)
            tile.isUserInteractionEnabled = false
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
        let touch:UITouch = touches.first!
        let positionInScene = touch.location(in: self)
        let touchedNode = self.atPoint(positionInScene)
        print("positionInScene: \(positionInScene)")
        
        if let name = touchedNode.name
        {
            // a tile node was touched
            if name.count == 2 {
                for i in 0..<9 {
                    for j in 0..<9 {
                        if name == String(i)+String(j) {
                            print("tile \(name) touched, i check: \(i) j: check \(j)")
                        }
                    }
                }
            }
            // a choice node was touched
            else if name.count == 1 {
                for i in 0..<9 {
                    if name == String(i + 1) {
                        print("tile \(name) touched, i + 1 check: \(i + 1)")
                        //touchedNode.addGlow() as! SKSpriteNode
                    }
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

    class func gridTexture(blockSize:CGFloat,rows:Int,cols:Int) -> SKTexture? {
        // Add 1 to the height and width to ensure the borders are within the sprite
        let size = CGSize(width: CGFloat(cols)*blockSize+1.0, height: CGFloat(rows)*blockSize+1.0)
        UIGraphicsBeginImageContext(size)

        guard let context = UIGraphicsGetCurrentContext() else {
            return nil
        }
        let bezierPath = UIBezierPath()
        let offset: CGFloat = 0.5
        // Draw vertical lines
        for i in 0...cols {
            let x = CGFloat(i)*blockSize + offset
            bezierPath.move(to: CGPoint(x: x, y: 0))
            bezierPath.addLine(to: CGPoint(x: x, y: size.height))
        }
        // Draw horizontal lines
        for i in 0...rows {
            let y = CGFloat(i)*blockSize + offset
            bezierPath.move(to: CGPoint(x: 0, y: y))
            bezierPath.addLine(to: CGPoint(x: size.width, y: y))
        }
        SKColor.white.setStroke()
        bezierPath.lineWidth = 3.0
        bezierPath.stroke()
        context.addPath(bezierPath.cgPath)
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
