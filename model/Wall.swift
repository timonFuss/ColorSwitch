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
    
    init(center : CGPoint) {
        self.center = center
    }
    
    func create(location: CGPoint, ballLocation: CGPoint) -> SKNode {
        self.section = SKShapeNode(path: generatePath().cgPath)
        self.section.fillColor = SKColor.green
        self.section.strokeColor = SKColor.green
        
        self.wall.addChild(section)
        
        return self.wall
    }
    
    private func generatePath() -> UIBezierPath {
        let path = UIBezierPath(roundedRect: CGRect(x: self.center.x, y: self.center.y, width: 200, height: 20), cornerRadius: 5)
        return path
    }
    
    func doAnimation() -> SKShapeNode {
        return SKShapeNode()
    }
    
    func create() -> SKShapeNode {
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
