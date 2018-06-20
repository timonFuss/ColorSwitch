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
    var nextLine : CGPoint = CGPoint.zero
    var firstLine : CGPoint = CGPoint.zero
    var constant : CGFloat
    
    init(color: SKColor, radius:CGFloat, center:CGPoint, startAngle: CGFloat, endAngle: CGFloat, gapSize: CGFloat, lineWidth: CGFloat, count: Int) {
        
        self.color = color
        self.radius = radius
        self.startAngle = startAngle
        self.endAngle = endAngle
        self.center = center
        self.gapSize = gapSize
        self.lineWidth = lineWidth
        self.nextLine = CGPoint(x: 0, y: 0)
        self.firstLine = CGPoint(x: 0, y: 0)
        self.startPosition = CGPoint(x: 0, y: 0)
        self.constant = 15
        self.startPosition = CGPoint.zero
        self.firstLine = CGPoint.zero
        self.nextLine = CGPoint.zero
        
        switch count {
            case 0:
                //self.startPosition = self.rotation(outerPoint: CGPoint(x: self.center.x, y: self.center.y - self.radius), degree: CGFloat(-180))
                self.startPosition = CGPoint(x: self.center.x, y: self.center.y - self.radius)
                self.firstLine = CGPoint(x: self.startPosition.x, y: self.startPosition.y - self.constant)
                self.nextLine = CGPoint(x: self.center.x + (self.radius + self.constant), y: self.center.y)
                break
            case 1:
                self.startPosition = CGPoint(x: self.center.x + self.radius, y: self.center.y)
                self.firstLine = CGPoint(x: self.startPosition.x + self.constant, y: self.startPosition.y)
                self.nextLine = CGPoint(x: self.center.x , y: self.center.y + (self.radius + self.constant))
                break
            case 2:
                self.startPosition = CGPoint(x: self.center.x, y: self.center.y + self.radius)
                self.firstLine = CGPoint(x: self.startPosition.x, y: self.startPosition.y + self.constant)
                self.nextLine = CGPoint(x: self.center.x - (self.radius + self.constant), y: self.center.y)
                break
            case 3:
                self.startPosition = CGPoint(x: self.center.x - self.radius, y: self.center.y)
                self.firstLine = CGPoint(x: self.startPosition.x - self.constant, y: self.startPosition.y)
                self.nextLine = CGPoint(x: self.center.x, y: self.center.y - (self.radius + self.constant))
                break
        default:
            break
        }
        
        let path = UIBezierPath()
        path.move(to: self.startPosition)
        print(self.startPosition)
        path.addLine(to: self.firstLine)
        path.addArc(withCenter: self.center,
                    radius: self.radius,
                    startAngle: self.startAngle,
                    endAngle: self.endAngle,
                    clockwise: true)
        path.addLine(to: self.nextLine)
        path.addArc(withCenter: self.center,
                    radius: self.radius + self.constant,
                    startAngle: self.endAngle,
                    endAngle: self.startAngle,
                    clockwise: false)
        
        
        
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
    
    func rotation(outerPoint: CGPoint, degree: CGFloat) -> CGPoint{
        let pX = outerPoint.x - self.center.x
        let pY = outerPoint.y - self.center.y
        var x = sqrt((pX * pX) + (pY * pY)) * cos(degree)
        var y = sqrt((pX * pX) + (pY * pY)) * sin(degree)
        x = x + self.center.x
        y = y + self.center.y
        return CGPoint(x: x, y: y)
    }
    
    func create() -> SKShapeNode{
        return self.segment
    }
}
