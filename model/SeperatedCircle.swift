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
    var rotationAngle: CGFloat = CGFloat(Double.pi/2)
    var radius: CGFloat
    var segments: [CircleSegment] = []
    let colors = [SKColor.yellow, SKColor.red, SKColor.blue, SKColor.purple]
    var circle: SKShapeNode = SKShapeNode()
    var firstCreation: Bool = true
    
    init(amountSegments: Int, center: CGPoint, radius: CGFloat, gapSize: CGFloat, lineWidth: CGFloat) {
        self.amountSegments = amountSegments
        self.center = center
        self.radius = radius
        self.gapSize = gapSize
        self.lineWidth = lineWidth
    }
    
    func create() -> SKShapeNode{
        //let angle = CGFloat(Double.pi/2)
        
        for i in 0...3{
            let start = CGFloat(3.0 * Double.pi/2) + (CGFloat(i) * self.rotationAngle)
            let end = CGFloat(0) + (CGFloat(i) * self.rotationAngle)
            
            let circle = CircleSegment(color: colors[i], radius: self.radius, center: self.center, startAngle: start, endAngle: end, gapSize: 10, lineWidth: self.lineWidth)
            
            self.segments.append(circle)
            self.circle.addChild(self.segments[i].create())
        }
        self.firstCreation = false
        return self.circle
    }
    
    func doAnimation() -> SKShapeNode {        
        self.radius -= 2
        self.circle.removeAllChildren()

        for segment in self.segments{
            self.circle.addChild(segment.animateSegment(radius: self.radius))
        }
        return self.circle
    }
    
    func create(location: CGPoint, ballLocation: CGPoint) -> SKNode {
        return SKNode()
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
    
    func isFirstCreation() -> Bool{
        return self.firstCreation
    }
}

