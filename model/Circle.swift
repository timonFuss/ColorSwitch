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
    
    init(node: SKNode, location: CGPoint, fill: Bool, fillColor: SKColor, strokeColor: SKColor, radius: CGFloat) {
        self.center = location
        self.fColor = fillColor
        self.sColor = strokeColor
        self.radius = radius
        self.fill = fill
        self.ball = SKShapeNode(circleOfRadius: self.radius)
    }
    
    
    func create() -> SKShapeNode{
        let bla: SKShapeNode = SKShapeNode(circleOfRadius: radius)
        
        self.ball = bla
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
}

