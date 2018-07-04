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
    var halfScreen: CGPoint
    var wall: SKShapeNode = SKShapeNode()
    var section = SKShapeNode()
    let colors = [SKColor.yellow, SKColor.red, SKColor.blue, SKColor.purple]
    var position: CGPoint = CGPoint(x: 0, y: 0)
    var firstCreation: Bool = true
    let positionBottom: Bool
    
    init(screenCenter : CGPoint, positionBottom: Bool) {
        self.halfScreen = screenCenter
        self.positionBottom = positionBottom
    }
    
    func create() -> SKShapeNode {
        
        let section = SKShapeNode(path: generatePath().cgPath)
        section.fillColor = SKColor.green
        section.strokeColor = SKColor.green
        section.zRotation = CGFloat(Double.pi / 2)
            
        self.wall.addChild(section)
        
        self.firstCreation = false
        
        return self.wall
    }
    
    func create(location: CGPoint, ballLocation: CGPoint) -> SKNode {
        return self.wall
    }
    
    private func generatePath() -> UIBezierPath {
        var path = UIBezierPath()
        if self.positionBottom{
            path = UIBezierPath(roundedRect: CGRect(x: self.position.x, y: self.position.y, width: self.halfScreen.y, height: 10), cornerRadius: 5)
        }else{
            path = UIBezierPath(roundedRect: CGRect(x: self.position.x + self.halfScreen.y, y: self.position.y, width: self.halfScreen.y, height: 10), cornerRadius: 5)
        }
        
        return path
    }
    
    func doAnimation() -> SKShapeNode {
        self.wall.removeAllChildren()
        self.position.y -= 3
        
        let section = SKShapeNode(path: generatePath().cgPath)
        section.fillColor = SKColor.green
        section.strokeColor = SKColor.green
        section.zRotation = CGFloat(Double.pi / 2)
        
        //Collosion
        let sectionBody = SKPhysicsBody(polygonFrom: generatePath().cgPath)
        sectionBody.categoryBitMask = PhysicsCategory.Obstacle
        sectionBody.collisionBitMask = 0
        sectionBody.contactTestBitMask = PhysicsCategory.Player
        sectionBody.affectedByGravity = false
        section.physicsBody = sectionBody
        
        self.wall.addChild(section)
        
        return self.wall
    }
    
    func create(location: CGPoint) -> SKNode {
        return SKNode()
    }
    
    func isActive() -> Bool {
        if self.position.y >= ((self.halfScreen.x * (-2)) - 5){
            return true
        }
        return false
    }
    
    func isFirstCreation() -> Bool {
        return self.firstCreation
    }
    
    func setObjectIsInactive() {
    }
    
    func getActiveState() -> Bool {
        return true
    }
}
