//
//  SeperatedCircle.swift
//  ColorSwitch
//
//  Created by Anonymer Eintrag on 13.06.18.
//  Copyright © 2018 hs-rm.de. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class SeperatedCircle: Element {
    let amountSegments: Int
    var center: CGPoint
    let gapSize: CGFloat
    let lineWidth: CGFloat
    var rotationAngle: CGFloat = 0.0
    var radius: CGFloat
    var segments: [CircleSegment] = []
    let colors = [SKColor.yellow, SKColor.red, SKColor.blue, SKColor.purple]
    var circle: SKShapeNode = SKShapeNode()
    
    init(amountSegments: Int, center: CGPoint, radius: CGFloat, gapSize: CGFloat, lineWidth: CGFloat) {
        self.amountSegments = amountSegments
        self.center = center
        self.radius = radius
        self.gapSize = gapSize
        self.lineWidth = lineWidth
    }
    
    func create() -> SKShapeNode{
        let angle = CGFloat(Double.pi/2)
        
        for i in 0...0{
            let start = CGFloat(3.0 * Double.pi/2) + (CGFloat(i) * angle)
            let end = CGFloat(0) + (CGFloat(i) * angle)
            
            let circle = CircleSegment(color: colors[i], radius: self.radius, center: self.center, startAngle: start, endAngle: end, gapSize: 10, lineWidth: self.lineWidth, count: i)
            
            self.segments.append(circle)
            self.circle.addChild(self.segments[i].create())
        }
        return self.circle
    }
    
    func doAnimation(oldAngle: CGFloat) -> SKShapeNode {
        self.rotationAngle = oldAngle
        if self.rotationAngle <= CGFloat(360.0){
            self.rotationAngle += 0.5
        }else{
            self.rotationAngle = 0
        }
        self.radius -= 0.25
        self.segments.removeAll()
        self.circle.removeAllChildren()
        let test: SKShapeNode = self.create()
        return test
    }
    
    func create(location: CGPoint) -> SKNode {
        return SKNode()
    }
    
    func isActive() -> Bool {
        if self.radius > 15 {
            return true
        }
        return false
    }
}

