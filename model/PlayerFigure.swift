//
//  PlayerFigure.swift
//  ColorSwitch
//
//  Created by Anonymer Eintrag on 06.06.18.
//  Copyright © 2018 hs-rm.de. All rights reserved.
//

import Foundation
import SpriteKit

class PlayerFigure: Element {

    
    let innerCircleRadius: CGFloat = 25
    let playerBallRadius: CGFloat = 7.5

    var innerCircle: Circle!
    var playerBallCircle: Circle!
    
    var player = SKNode()
    var playerBallShape = SKShapeNode()
    var innerCircleShape = SKShapeNode()
    

    func create(location: CGPoint, ballLocation: CGPoint) -> SKNode {
        innerCircle = Circle(location: location, fill: false, fillColor: SKColor.red, strokeColor: SKColor.red, radius: innerCircleRadius)
        
        playerBallCircle = Circle(location: CGPoint(x:ballLocation.x,y:ballLocation.y + (innerCircleRadius + playerBallRadius)+3), fill: true, fillColor: SKColor.blue, strokeColor: SKColor.blue, radius: playerBallRadius)


        innerCircleShape = innerCircle.create()
        innerCircleShape.name = "inner"
        
        playerBallCircle.ball.zPosition = 0.5
        playerBallShape = playerBallCircle.create()
        
        playerBallShape.zPosition = 0.5
        playerBallShape.name = "player"
        player.addChild(innerCircleShape)
        player.addChild(playerBallShape)

        return player
    }
    
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
}

