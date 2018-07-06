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

/// Class to create a CircleSegment
class CircleSegment{
    
    //constants
    var constant : CGFloat = 15
    var multifactor : CGFloat = 0.3
    
    //InformationVariables
    var color: SKColor
    var radius: CGFloat
    var center: CGPoint
    var startAngle: CGFloat
    var endAngle: CGFloat
    
    //ObjectVariables
    var segment: SKShapeNode = SKShapeNode()
    var path = UIBezierPath()
    let clockwise: Bool
    let rotationFactor: CGFloat
    
    let objectType: String = "CircleSegment"
    /// Initializes a CircleSegment
    ///
    /// - Parameters:
    ///   - color: defines the color that should be set to the segment
    ///   - radius: defines how big the segment should get
    ///   - center: defines the position of the segment
    ///   - startAngle: defines the startAngle of the segment
    ///   - endAngle: defines how big (degree/360) the segment should be in dependency of the startAngle
    init(color: SKColor, radius:CGFloat, center:CGPoint, startAngle: CGFloat, endAngle: CGFloat, rotationFactor: CGFloat, clockwise: Bool) {
        self.color = color
        self.radius = radius
        self.startAngle = startAngle
        self.endAngle = endAngle
        self.center = center
        
        self.rotationFactor = rotationFactor
        self.clockwise = clockwise
    
        let path = self.generatePath()
        self.segment = SKShapeNode(path: path.cgPath)
        
        //Collosion
        let sectionBody = SKPhysicsBody(polygonFrom: path.cgPath)
        sectionBody.categoryBitMask = PhysicsCategory.Obstacle
        sectionBody.collisionBitMask = 0
        sectionBody.contactTestBitMask = PhysicsCategory.Player
        sectionBody.affectedByGravity = false
        self.segment.physicsBody = sectionBody
        
        self.segment.strokeColor = SKColor.clear
        self.segment.fillColor = self.color
        
        

 
    }
    
    /// Creates the SKShapeNode that can be displayed in the Gamescene
    ///
    /// - Returns: the defined SKShapeNode of the CircleSegment
    func create() -> SKShapeNode{
        return self.segment
    }
    

    
    /// Calculates the paths of the segment
    ///
    /// - Returns: the paths of the segment
    private func generatePath() -> UIBezierPath{
        let path = UIBezierPath()
      
        //Inner segmentPath
        path.addArc(withCenter: self.center,
                    radius: self.radius,
                    startAngle: self.startAngle,
                    endAngle: self.endAngle,
                    clockwise: true)

        //Outer segmentPath
        path.addArc(withCenter: self.center,
                    radius: self.radius + self.constant,
                    startAngle: self.endAngle,
                    endAngle: self.startAngle,
                    clockwise: false)
        
        return path
    }
    
    /// Animates the SegmentObject, getting smaller and rotating and is triggered by its Parent (SeperatedCircle)
    ///
    /// - Parameter radius: the actual radius
    /// - Returns: the updated segment
    func animateSegment(radius: CGFloat) -> SKShapeNode{
        self.radius = radius

        if !self.clockwise{
            self.startAngle += self.rotationFactor
            self.endAngle += self.rotationFactor
        }else{
            self.startAngle -= self.rotationFactor
            self.endAngle -= self.rotationFactor
        }
        

        let path = self.generatePath()
        self.segment.path = path.cgPath
        
        //CollosionBody of the object is added by getting the same Path
        let sectionBody = SKPhysicsBody(polygonFrom: path.cgPath)
        sectionBody.categoryBitMask = PhysicsCategory.Obstacle
        sectionBody.collisionBitMask = 0
        sectionBody.contactTestBitMask = PhysicsCategory.Player
        sectionBody.affectedByGravity = false

        self.segment.physicsBody = sectionBody

        return self.segment
    }
    
    func setInactiveColor(){
        self.segment.fillColor = self.color.withAlphaComponent(0.5)
        self.segment.strokeColor = SKColor.clear
    }
    
    func getObjectType() -> String{
        return self.objectType
    }
}
