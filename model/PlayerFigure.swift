//
//  PlayerFigure.swift
//  ColorSwitch
//
//  Created by Anonymer Eintrag on 06.06.18.
//  Copyright © 2018 hs-rm.de. All rights reserved.
//

import Foundation
import SpriteKit

// Class that is needed to play the Game
class PlayerFigure: Element {

    //InformationVariables
    let innerCircleRadius: CGFloat = 25
    let playerBallRadius: CGFloat = 7.5

    //Objects to be held in PlayerFigure
    var innerCircle: Circle!
    var playerBallCircle: Circle!
    
    //ObjectVariables
    var player = SKNode()
    var playerBallShape = SKShapeNode()
    var innerCircleShape = SKShapeNode()
    

    /// Method to create the innerCircle and the playerBall that will orbit the innerCircle
    ///
    /// - Parameters:
    ///   - location: where the innerCircle will be placed
    ///   - ballLocation: where the playerBall will stick to the innerCircle
    /// - Returns: SKNode where all the Objects will be displayed
    func create(location: CGPoint, ballLocation: CGPoint) -> SKNode {
        
        //Creates the innerCircle
        innerCircle = Circle(location: location, fill: false, fillColor: SKColor.red, strokeColor: SKColor.red, radius: innerCircleRadius)
        
        //Creates the playerBall
        playerBallCircle = Circle(location: CGPoint(x:ballLocation.x,y:ballLocation.y + (innerCircleRadius + playerBallRadius)+3), fill: true, fillColor: SKColor.blue, strokeColor: SKColor.clear, radius: playerBallRadius)

        //Named the Shape of the innerCircle to have an access later on
        //and place it on z-axis above the other Elements
        innerCircleShape = innerCircle.create()
        innerCircleShape.name = "inner"
        playerBallCircle.ball.zPosition = 0.5
        playerBallShape = playerBallCircle.create()
        
        //Named the Shape of the innerCircle to have an access later on
        //and place it on z-axis above the other Elements
        playerBallShape.zPosition = 0.5
        playerBallShape.name = "player"
        player.addChild(innerCircleShape)
        player.addChild(playerBallShape)

        return player
    }
    
    /// Updates the PlayerFigure
    ///
    /// - Parameter locationPlayerBall: where the playerBall should be placed
    /// - Returns: the updated SKNode
    func updatePlayerFigure(locationPlayerBall: CGPoint) -> SKNode{
        self.playerBallCircle.center = locationPlayerBall
        self.playerBallShape = self.playerBallCircle.updateCirclePosition(center: locationPlayerBall)
        player.removeAllChildren()
        player.addChild(playerBallShape)
        player.addChild(innerCircleShape)
        return self.player
    }
    
    func isFirstCreation() -> Bool {
        return true
    }
    
    func updateCircle() -> SKShapeNode {
        return SKShapeNode()
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
    func getObjectType() -> String {
        return ""
    }
    
    func getActiveState() -> Bool {
        return true
    }
    
    func setObjectIsInactive() {
        
    }
}

