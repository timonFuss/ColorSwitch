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
    func getBool() -> Bool {
        return true
    }
    
    func updateCircle() -> SKShapeNode {
        return SKShapeNode()
    }
    
    let innerCircleRadius: CGFloat = 25
    let playerBallRadius: CGFloat = 7.5

    var innerCircle: Circle!
    var playerBall: Circle!
    var player = SKNode()
    
    var ballPlayer = SKShapeNode()
    var circle = SKShapeNode()
    

    func create(location: CGPoint, ballLocation: CGPoint, initialSet: Bool) -> SKNode {
        //let player = SKNode()
        innerCircle = Circle(location: location, fill: false, fillColor: SKColor.red, strokeColor: SKColor.red, radius: innerCircleRadius)
        
        if(initialSet){
            playerBall = Circle(location: CGPoint(x:ballLocation.x,y:ballLocation.y + (innerCircleRadius + playerBallRadius)+3), fill: true, fillColor: SKColor.blue, strokeColor: SKColor.blue, radius: playerBallRadius)
        }else{
            playerBall = Circle(location: CGPoint(x:ballLocation.x,y:ballLocation.y), fill: true, fillColor: SKColor.blue, strokeColor: SKColor.blue, radius: playerBallRadius)
        }
        

        circle = innerCircle.create()
        circle.name = "inner"
        
        playerBall.ball.zPosition = 0.5
        ballPlayer = playerBall.create()
        
        ballPlayer.zPosition = 0.5
        ballPlayer.name = "player"
        player.addChild(circle)
        player.addChild(ballPlayer)

        return player
    }
    
    func updatePlayerFigure(locationPlayerBall: CGPoint) -> SKNode{
        self.playerBall.center = locationPlayerBall
        self.ballPlayer = self.playerBall.updateCirclePosition(center: locationPlayerBall)
        player.removeAllChildren()
        player.addChild(ballPlayer)
        player.addChild(circle)
        return self.player
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

