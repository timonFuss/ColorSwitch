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

/// Class that combines CircleSegments to a whole Circle
class SeperatedCircle: Element {
    
    //ObjectVariables
    var segments: [CircleSegment] = []
    let colors = [SKColor.yellow, SKColor.red, SKColor.blue, SKColor.purple]
    var circle: SKShapeNode = SKShapeNode()
    
    //InformationVariables
    let amountSegments: Int
    var center: CGPoint
    var rotationAngle: CGFloat = CGFloat(Double.pi/2)
    var radius: CGFloat
    var firstCreation: Bool = true
    
    /// Initializes a Seperated Circle
    ///
    /// - Parameters:
    ///   - amountSegments: Integer that detemines the amount of CircleSegments
    ///   - center: of the Object where it should be placed
    ///   - radius: how big the Element should be when creating
    init(amountSegments: Int, center: CGPoint, radius: CGFloat) {
        self.amountSegments = amountSegments
        self.center = center
        self.radius = radius
    }
    
    /// Creates the SKShapeNode that can be displayed in the Gamescene
    ///
    /// - Returns: the defined SKShapeNode of the SeperatedCircle
    func create() -> SKShapeNode{
        for i in 0...(amountSegments - 1){
            let start = CGFloat(3.0 * Double.pi/2) + (CGFloat(i) * self.rotationAngle)
            let end = CGFloat(0) + (CGFloat(i) * self.rotationAngle)
            
            let circle = CircleSegment(color: colors[i], radius: self.radius, center: self.center, startAngle: start, endAngle: end)
            self.segments.append(circle)
            self.circle.addChild(self.segments[i].create())
        }
        self.firstCreation = false
        return self.circle
    }
    
    /// Defines the Animation of the Circle and updates all of its Segments
    ///
    /// - Returns: the updated SKShapeNode
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
    
    /// A Seperated Circle is active when its bigger than the PlayerFigure
    ///
    /// - Returns: if the Object is still active
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

