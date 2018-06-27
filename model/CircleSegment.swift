//
//  CircleSegment.swift
//  ColorSwitch
//
//  Created by Anonymer Eintrag on 13.06.18.
//  Copyright © 2018 hs-rm.de. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class CircleSegment{
    var radius: CGFloat
    var center: CGPoint
    var startAngle: CGFloat
    var endAngle: CGFloat
    var color: SKColor
    var segment: SKShapeNode = SKShapeNode()
    let lineWidth: CGFloat
    let gapSize: CGFloat
    var startPosition : CGPoint = CGPoint.zero
    var lastPoint : CGPoint = CGPoint.zero
    var firstPoint : CGPoint = CGPoint.zero
    var constant : CGFloat
    var multifactor : CGFloat = 0.3
    var firstSet: Bool = false
    var path = UIBezierPath()
    
    
    init(color: SKColor, radius:CGFloat, center:CGPoint, startAngle: CGFloat, endAngle: CGFloat, gapSize: CGFloat, lineWidth: CGFloat) {
     
        self.color = color
        self.radius = radius
        self.startAngle = startAngle
        self.endAngle = endAngle
        self.center = center
        self.gapSize = gapSize
        self.lineWidth = lineWidth
        self.startPosition = CGPoint(x: 0, y: 0)
        self.constant = 15
        self.startPosition = CGPoint.zero
        
        let path = self.generatePath()
        self.segment = SKShapeNode(path: path.cgPath)
        
        //Collosion
        let sectionBody = SKPhysicsBody(polygonFrom: path.cgPath)
        sectionBody.categoryBitMask = PhysicsCategory.Obstacle
        sectionBody.collisionBitMask = 0
        sectionBody.contactTestBitMask = PhysicsCategory.Player
        sectionBody.affectedByGravity = false
        self.segment.physicsBody = sectionBody
        
        self.segment.strokeColor = self.color
        self.segment.fillColor = self.color
 
    }
    
    func create() -> SKShapeNode{
        return self.segment
    }
    
    func calculatePoint(position: CGPoint, degree: CGFloat) -> CGPoint{
        var x = sqrt((position.x * position.x) + (position.y * position.y)) * cos(degree)
        var y = sqrt((position.x * position.x) + (position.y * position.y)) * sin(degree)
        x = x + self.center.x
        y = y + self.center.y
        return CGPoint(x: x, y: y)
    }
    
    private func generatePath() -> UIBezierPath{
        let path = UIBezierPath()
      
        path.addArc(withCenter: self.center,
                    radius: self.radius,
                    startAngle: self.startAngle,
                    endAngle: self.endAngle,
                    clockwise: true)

        path.addArc(withCenter: self.center,
                    radius: self.radius + self.constant,
                    startAngle: self.endAngle,
                    endAngle: self.startAngle,
                    clockwise: false)
        
        
        return path
    }
    
    
    func animateSegment(radius: CGFloat) -> SKShapeNode{
        self.radius = radius

        if self.startAngle < 360.0{
            self.startAngle += 0.05
        }else{
           self.startAngle = 0.0
        }
        
        if self.endAngle < 360.0{
            self.endAngle += 0.05
        }else{
            self.endAngle = 0.0
        }

        
        let path = self.generatePath()

        self.segment.path = path.cgPath
        
        //Collosion
        let sectionBody = SKPhysicsBody(polygonFrom: path.cgPath)
        sectionBody.categoryBitMask = PhysicsCategory.Obstacle
        sectionBody.collisionBitMask = 0
        sectionBody.contactTestBitMask = PhysicsCategory.Player
        sectionBody.affectedByGravity = false

        self.segment.physicsBody = sectionBody

        return self.segment
    }
}
