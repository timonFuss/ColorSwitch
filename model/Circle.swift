//
//  Circle.swift
//  ColorSwitch
//
//  Created by Anonymer Eintrag on 06.06.18.
//  Copyright © 2018 hs-rm.de. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class Circle{
    
    var fill: Bool
    var radius: CGFloat
    var center: CGPoint
    var fColor: SKColor
    var sColor: SKColor
    var ball: SKShapeNode
    
    /// Initializes a Circle that is needed to create a PlayerFigure
    ///
    /// - Parameters:
    ///   - location: where it should be placed
    ///   - fill:
    ///   - fillColor: Color to fill the Circle
    ///   - strokeColor: Color to ink the border
    ///   - radius: how big the Circle should be
    init(location: CGPoint, fill: Bool, fillColor: SKColor, strokeColor: SKColor, radius: CGFloat) {
        self.center = location
        self.fColor = fillColor
        self.sColor = strokeColor
        self.radius = radius
        self.fill = fill
        self.ball = SKShapeNode(circleOfRadius: self.radius)
    }
    
    /// Creates the fitting SKShapeNode for the CircleElement
    ///
    /// - Returns: ShapeObject
    func create() -> SKShapeNode{
        let circleShape: SKShapeNode = SKShapeNode(circleOfRadius: radius)
        
        self.ball = circleShape
        self.ball.position = CGPoint(x:self.center.x , y:self.center.y)
        self.ball.strokeColor = self.sColor
        self.ball.glowWidth = 1.0
        if(fill){
            self.ball.fillColor = self.fColor
        }else{
            self.ball.fillColor = SKColor.clear
        }
        
        return self.ball
    }
    
    func doAnimation(oldAngle: CGFloat) -> SKShapeNode {
        return SKShapeNode()
    }
    
    /// Updates the position of the Circle when changed
    ///
    /// - Parameter center: of the Circle
    /// - Returns: the updated SKShapeNode
    func updateCirclePosition(center: CGPoint) -> SKShapeNode{
        self.center = center
        self.ball.position = center
        return self.ball
    }
}

