//
//  Wall.swift
//  ColorSwitch
//
//  Created by Anonymer Eintrag on 02.07.18.
//  Copyright © 2018 hs-rm.de. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class Wall: Element {
    var center: CGPoint
    var wall: SKShapeNode = SKShapeNode()
    var section = SKShapeNode()
    let colors = [SKColor.yellow, SKColor.red, SKColor.blue, SKColor.purple]
    var spacing = CGFloat(10)

    
    init(center : CGPoint) {
        self.center = center
    }
    
    func create() -> SKShapeNode {
        let rotationFactor = CGFloat(Double.pi / 2)
        
        for i in 0...3 {
            let section = SKShapeNode(path: generatePath().cgPath)
            section.position = CGPoint(x: self.center.x, y: spacing * CGFloat(i))
            section.fillColor = colors[i]
            section.strokeColor = colors[i]
            section.zRotation = rotationFactor * CGFloat(i)
            
            self.wall.addChild(section)
        }
        
        return self.wall
    }
    
    func create(location: CGPoint, ballLocation: CGPoint) -> SKNode {
        return self.wall
    }
    
    private func generatePath() -> UIBezierPath {
        let path = UIBezierPath(roundedRect: CGRect(x: self.center.x, y: self.center.y, width: 100, height: 10), cornerRadius: 5)
        return path
    }
    
    func doAnimation() -> SKShapeNode {
        return SKShapeNode()
    }
    
    func create(location: CGPoint) -> SKNode {
        return SKNode()
    }
    
    func isActive() -> Bool {
        return true
    }
    
    func isFirstCreation() -> Bool {
        return true
    }
    
    func setObjectIsInactive() {
    }
    
    func getActiveState() -> Bool {
        return true
    }
}
