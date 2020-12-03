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
    // TODO: Make subclass
    var superGridArray = [SKSpriteNode]() // holds outside Grids
    var subGridArray = [SKSpriteNode]() // holds the 9 little tiles
    
    //private var label : SKLabelNode?
    //private var spinnyNode : SKShapeNode?
    
    /*init(_: ) {
     <#statements#>
     }*/
    
    override func didMove(to view: SKView) {
        //setupGrid()
        
        /*let ball = SKShapeNode()
        ball.lineWidth = 1
        ball.fillColor = .blue
        ball.strokeColor = .white
        ball.glowWidth = 0.5*/
        
        
        if let grid = Grid(blockSize: 72, rows:9, cols:9) {
            grid.position = CGPoint (x:frame.midX, y:frame.midY)
            addChild(grid)

            for i in 0..<9 {
                for j in 0..<9 {
                    let tile = SKSpriteNode(imageNamed: "Demo_Sudoku_Tile")
                    tile.setScale(1)
                    tile.position = grid.gridPosition(row: i, col: j)
                    grid.addChild(tile)
                }
            }
            
        }
        
        /*let grid = GridTexture()
        , width = Int(self.frame.size.width)
        , height = Int(self.frame.size.height)
        , buttonSize = width * 3 / 32
        , borderSize = (width / 100)
        , bgSize = buttonSize * 9 + borderSize * 12
        , blankSize = (width - bgSize) / 2
        , frameSize = buttonSize * 3 + borderSize * 4
        , xCenter = self.frame.midX
        , yCenter = self.frame.midY
        , background = SKShapeNode(rectOf: CGSize(width: bgSize+1, height: bgSize+1))
        , frameColor1 = UIColor(red: 0, green: 0, blue: 1, alpha: 1)
        , frameColor2 = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
        
        background.fillColor = frameColor1
        background.strokeColor = UIColor.systemRed
        background.isAntialiased = true
        background.lineWidth = 1
        background.position = CGPoint(x: xCenter, y: yCenter + CGFloat(frameSize/2))
        background.zPosition = -1.0
        for row in 0..<3 {
            for col in 0..<3 {
                if (row+col) & 1 == 0 {
                    continue
                }
                let frame = SKShapeNode(rectOf: CGSize(width: frameSize, height: frameSize))
                frame.fillColor = frameColor2
                frame.position = CGPoint(x: (col-1) * frameSize, y: (row-1) * frameSize)
                frame.lineWidth = 0
                background.addChild(frame)
            }
        }
        self.addChild(background)*/
        
        
        
        /*for var rows in 0..<10 {
         
         for var cols in 0..<10; a++ {
         let  = SKSpriteNode()// your sprite with image name.
         sprites.position = CGPoint(x:50 * a+1 , y:50*i+1) // write your position here.
         self.addChild(sprites)
         }
         
         
         
         let spriteArray = [SKSpriteNode]() // Empty array of sprites in class property.
         for var x in 0..<; x++ {
         // write your code here
         spriteArray.append(letterSprite)
         }*/
    }
    func setupGrid() {
        let superGridIdx = 9
        let subGridIdx = 9
        let nums = 9
        
       //func setupMap() {
            let tilesWide = 10
            let tilesTall = 10

            for i in 0..<tilesWide {
                for j in 0..<tilesTall {
                    let tile = SKSpriteNode(color: SKColor.red, size: CGSize(width: 5, height: 5))
                    tile.anchorPoint = .zero

                    let x = CGFloat(i) * tile.size.width
                    let y = CGFloat(j) * tile.size.height

                    tile.position = CGPoint(x: x, y: y)
                    self.addChild(tile)
                }
            }
        //}

        
        
       // for i in 0..<superGridIdx {
            //for j in 0..<cols {
            /*let outerSquares = SKSpriteNode(color: UIColor.darkGray, size: CGSize(width: 8, height: 8))
             outerSquares.anchorPoint = CGPointZero
             
             let x = CGFloat(i) * tile.size.width
             let y = CGFloat(j) * tile.size.height
             
             outerSquares.position = CGPoint(x: x, y: y)
             self.addChild(outerSquares)*/
            /*let superGrid = SKSpriteNode(color: UIColor.yellow, size: CGSize(width: 24, height: 24)) // your sprite with image name.
            let subGrid = SKSpriteNode(color: UIColor.red, size: CGSize(width: 8, height: 8))
            //outerGrid.anchorPoint = CGPoint(x: 0, y: 0)
            
            //let x = CGFloat(i) * outerGrid.size.width
            //let y = CGFloat(j) * outerGrid.size.height
            
            //outerGrid.position = CGPoint(x: 8 * i + 1, y: 8 * i + 1)
            superGridArray[i] = superGrid
            subGridArray[i] = subGrid
            
            superGridArray[i].position = CGFloat(16 * superGridIdx + 1, y:16 * superGridIdx + 1)*/
            //self.addChild(outerGrid)
        // }
        
        
        
        /*let spriteArray = [SKSpriteNode]() // Empty array of sprites in class property.
         for var x in 0..<; x++ {
         // write your code here
         spriteArray.append(letterSprite)
         }*/
    }
    //}
    
}

class Grid:SKSpriteNode {
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
        let offset:CGFloat = 0.5
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
        bezierPath.lineWidth = 2.0
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
        return CGPoint(x:x, y:y)
    }
}





class GridTexture {
    var squares: [SKTexture]
    var frames: [SKTexture]
    
    init() {
        squares = []
        let tileFace = SKTexture(imageNamed: "demo_sudoku_tile")
        , imageWidth = tileFace.size().width
        , imageHeight = tileFace.size().height
        , tileHeight = imageHeight
        , tileWidth = tileHeight / imageWidth
        
        var x = CGFloat(0.0)
        for i in 0..<9 {
            squares.append(SKTexture(rect: CGRect(x: x, y: 0, width: tileWidth, height: 1.0), in: tileFace))
            x += tileWidth
        }
        
        let frameFace = SKTexture(imageNamed: "Sudoku_frame")
        frames = [
            SKTexture(rect: CGRect(x: 0, y: 0, width: 0.5, height: 1), in: frameFace),
            SKTexture(rect: CGRect(x: 0.5, y: 0, width: 0.5, height: 1), in: frameFace),
        ]
    }
}

/* Get label node from scene and store it for use later
 self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
 if let label = self.label {
 label.alpha = 0.0
 label.run(SKAction.fadeIn(withDuration: 2.0))
 }*/

/* Create shape node to use during mouse interaction
 let w = (self.size.width + self.size.height) * 0.05
 self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
 
 if let spinnyNode = self.spinnyNode {
 spinnyNode.lineWidth = 2.5
 
 spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
 spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
 SKAction.fadeOut(withDuration: 0.5),
 SKAction.removeFromParent()]))
 }*/



/* func touchDown(atPoint pos : CGPoint) {
 if let n = self.spinnyNode?.copy() as! SKShapeNode? {
 n.position = pos
 n.strokeColor = SKColor.green
 self.addChild(n)
 }
 }
 
 func touchMoved(toPoint pos : CGPoint) {
 if let n = self.spinnyNode?.copy() as! SKShapeNode? {
 n.position = pos
 n.strokeColor = SKColor.blue
 self.addChild(n)
 }
 }
 
 func touchUp(atPoint pos : CGPoint) {
 if let n = self.spinnyNode?.copy() as! SKShapeNode? {
 n.position = pos
 n.strokeColor = SKColor.red
 self.addChild(n)
 }
 }
 
 override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
 if let label = self.label {
 label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
 }
 
 for t in touches { self.touchDown(atPoint: t.location(in: self)) }
 }
 
 override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
 for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
 }
 
 override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
 for t in touches { self.touchUp(atPoint: t.location(in: self)) }
 }
 
 override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
 for t in touches { self.touchUp(atPoint: t.location(in: self)) }
 }
 
 
 override func update(_ currentTime: TimeInterval) {
 // Called before each frame is rendered
 }*/



