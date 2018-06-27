//
//  Obstacles.swift
//  ColorSwitch
//
//  Created by Anonymer Eintrag on 11.06.18.
//  Copyright © 2018 hs-rm.de. All rights reserved.
//

import Foundation
import SpriteKit

class Obstacles: SKShapeNode {
    var obstacles: [SKNode] = []
    var center: CGPoint = CGPoint(x:0,y:0)
    
    var radius: CGFloat {
        didSet {
            self.path = Obstacles.path().cgPath
        }
    }
    let obstacleSpacing: CGFloat = 800
    let colors = [SKColor.yellow, SKColor.red, SKColor.blue, SKColor.purple]
    
    init(radius: CGFloat, center: CGPoint) {
        self.radius = radius
        self.center = center
        super.init()
        self.path = Obstacles.path().cgPath
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func create() -> [SKNode] {
        addObstacle()
        
        return obstacles
    }
    
    
    func addObstacle() {
        addCircleObstacle()
    }
    
    //returns a SKNode
    func obstacleByDuplicatingPath(_ path: CGPath, clockwise: Bool) -> SKNode {
        //let container = SizeableCircle(radius: 50, position: self.center)
        let container = SKNode()
        
        var rotationFactor = CGFloat(Double.pi/2)
        if !clockwise {
            rotationFactor *= -1
        }
        
        for i in 0...3 {
            let section = SKShapeNode(path: path)
            section.fillColor = colors[i]
            section.strokeColor = colors[i]
            section.zRotation = rotationFactor * CGFloat(i);
            
            let sectionBody = SKPhysicsBody(polygonFrom: path)
            sectionBody.categoryBitMask = PhysicsCategory.Obstacle
            sectionBody.collisionBitMask = 0
            sectionBody.contactTestBitMask = PhysicsCategory.Player
            sectionBody.affectedByGravity = false
            section.physicsBody = sectionBody
            
            container.addChild(section)
        }
        return container
    }
    
    func addCircleObstacle() {
        
        let obstacle = obstacleByDuplicatingPath(self.path!, clockwise: true)
        obstacles.append(obstacle)
        obstacle.position = self.center
        //TODO
        //addChild(obstacle)
        
        let rotateAction = SKAction.rotate(byAngle: 2.0 * CGFloat(Double.pi), duration: 8.0)
        let scaleAction = SKAction.scale(by: 0.1, duration: 5)
        obstacle.run(SKAction.repeatForever(rotateAction))
        obstacle.run(SKAction.repeatForever(scaleAction))
    }

    class func path() -> UIBezierPath {
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
        return path
    }
 
    func addSquareObstacle() {
        let path = UIBezierPath(roundedRect: CGRect(x: -200, y: -200, width: 400, height: 40), cornerRadius: 20)
        
        //SKNode zuweisen
        let obstacle = obstacleByDuplicatingPath(path.cgPath, clockwise: false)
        obstacles.append(obstacle)
        
        
        obstacle.position = CGPoint(x: 380, y: obstacleSpacing * CGFloat(obstacles.count))
        
        //TODO
        //addChild(obstacle)
        
        let rotateAction = SKAction.rotate(byAngle: -2.0 * CGFloat(Double.pi), duration: 7.0)
        obstacle.run(SKAction.repeatForever(rotateAction))
    }
}
