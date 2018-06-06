//
//  GameScene.swift
//  ColorSwitch
//
//  Created by Anonymer Eintrag on 06.06.18.
//  Copyright © 2018 hs-rm.de. All rights reserved.
//

import SpriteKit
import GameplayKit

struct PhysicsCategory {
    static let Player: UInt32 = 1
    static let Obstacle: UInt32 = 2
    static let Edge: UInt32 = 4
}

class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    let colors = [SKColor.yellow, SKColor.red, SKColor.blue, SKColor.purple]
    let obstacleSpacing: CGFloat = 800
    var angle: CGFloat = CGFloat(Double.pi * 1/2)
    var location: CGPoint = CGPoint.zero
    var touched: Bool = false
    var playerFigure = PlayerFigure()
    var obstacles: [SKNode] = []
    var center: CGPoint = CGPoint(x:0,y:0)
    var playerFigureNode: SKNode = SKNode()
    
    let scoreLabel = SKLabelNode()
    var score = 0
    
    override func didMove(to view: SKView) {
        center = CGPoint(x: view.frame.width/2, y: view.frame.height/2)
        
        setupPlayerAndObstacles()
        
        let playerBody = SKPhysicsBody(circleOfRadius: 5)
        playerBody.mass = 1.5
        playerBody.categoryBitMask = PhysicsCategory.Player
        playerBody.collisionBitMask = 4
        playerFigureNode.childNode(withName: "player")?.physicsBody = playerBody
        
        
        let ledge = SKNode()
        ledge.position = CGPoint(x: size.width/2, y: 160)
        
        let ledgeBody = SKPhysicsBody(rectangleOf: CGSize(width: 200, height: 10))
        ledgeBody.isDynamic = false
        ledgeBody.categoryBitMask = PhysicsCategory.Edge
        ledge.physicsBody = ledgeBody
        addChild(ledge)
        
        physicsWorld.contactDelegate = self
        
    
        scoreLabel.position = CGPoint(x: -200, y: -200)
        scoreLabel.fontColor = .white
        scoreLabel.fontSize = 150
        scoreLabel.text = String(score)
        //addChild(scoreLabel)
        print(self.children.count)
        print(self.children)
    }
    
    func setupPlayerAndObstacles() {
        addPlayer()
        addObstacle()
    }
    
    func addPlayer () {
        playerFigureNode = playerFigure.create(location: center)
        addChild(playerFigureNode)
    }
    
    func addObstacle() {
        addCircleObstacle()
    }
    
    func addCircleObstacle() {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: -200))
        path.addLine(to: CGPoint(x: 0, y: -180))
        path.addArc(withCenter: CGPoint.zero,
                    radius: 180,
                    startAngle: CGFloat(3.0 * Double.pi/2),
                    endAngle: CGFloat(0),
                    clockwise: true)
        path.addLine(to: CGPoint(x: 200, y: 0))
        path.addArc(withCenter: CGPoint.zero,
                    radius: 200,
                    startAngle: CGFloat(0.0),
                    endAngle: CGFloat(3.0 * Double.pi/2),
                    clockwise: false)
        
        let obstacle = obstacleByDuplicatingPath(path, clockwise: true)
        obstacles.append(obstacle)
        obstacle.position = self.center
        addChild(obstacle)
        
        let rotateAction = SKAction.rotate(byAngle: 2.0 * CGFloat(Double.pi), duration: 8.0)
        let scaleAction = SKAction.scale(by: 0.1, duration: 5)
        obstacle.run(SKAction.repeatForever(rotateAction))
        obstacle.run(SKAction.repeatForever(scaleAction))
    }
    
    func addSquareObstacle() {
        let path = UIBezierPath(roundedRect: CGRect(x: -200, y: -200,
                                                    width: 400, height: 40),
                                cornerRadius: 20)
        
        let obstacle = obstacleByDuplicatingPath(path, clockwise: false)
        obstacles.append(obstacle)
        obstacle.position = CGPoint(x: size.width/2, y: obstacleSpacing * CGFloat(obstacles.count))
        addChild(obstacle)
        
        let rotateAction = SKAction.rotate(byAngle: -2.0 * CGFloat(Double.pi), duration: 7.0)
        obstacle.run(SKAction.repeatForever(rotateAction))
    }
    
    func obstacleByDuplicatingPath(_ path: UIBezierPath, clockwise: Bool) -> SKNode {
        let container = SKNode()
        
        var rotationFactor = CGFloat(Double.pi/2)
        if !clockwise {
            rotationFactor *= -1
        }
        
        for i in 0...3 {
            let section = SKShapeNode(path: path.cgPath)
            section.fillColor = colors[i]
            section.strokeColor = colors[i]
            section.zRotation = rotationFactor * CGFloat(i);
            
            let sectionBody = SKPhysicsBody(polygonFrom: path.cgPath)
            sectionBody.categoryBitMask = PhysicsCategory.Obstacle
            sectionBody.collisionBitMask = 0
            sectionBody.contactTestBitMask = PhysicsCategory.Player
            sectionBody.affectedByGravity = false
            section.physicsBody = sectionBody
            
            container.addChild(section)
        }
        print("Container",container.children)
        return container
    }
    
    func dieAndRestart() {
        print("boom")
        playerFigure.removeFromParent()
        
        for node in obstacles {
            node.removeFromParent()
        }
        
        obstacles.removeAll()
        
        score = 0
        scoreLabel.text = String(score)
        
        setupPlayerAndObstacles()
    }
    
    private func doAnimation(degree: CGFloat){
        let pX = playerFigure.playerBall.ball.position.x - playerFigure.innerCircle.ball.position.x
        let pY = playerFigure.playerBall.ball.position.y - playerFigure.innerCircle.ball.position.y
        var x = sqrt((pX * pX) + (pY * pY)) * cos(degree)
        var y = sqrt((pX * pX) + (pY * pY)) * sin(degree)
        x = x + playerFigure.innerCircle.ball.position.x
        y = y + playerFigure.innerCircle.ball.position.y
        playerFigure.playerBall.ball.position = CGPoint(x: x, y: y)
    }
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
    }
    
    func touchUp(atPoint pos : CGPoint) {
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touched = true
        for touch in touches{
            location = touch.location(in: self)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            location = touch.location(in: self)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        touched = false
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        if (touched){
            print("Vorher:", playerFigure.playerBall.center)
            doAnimation(degree: self.angle)
            self.angle += 0.05
            print("Nachher", playerFigure.playerBall.center)
        }
    }
}

extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        if let nodeA = contact.bodyA.node as? SKShapeNode, let nodeB = contact.bodyB.node as? SKShapeNode {
            if nodeA.fillColor != nodeB.fillColor {
                dieAndRestart()
            }
        }
    }
}

