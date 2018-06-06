//
//  PlayerFigure.swift
//  ColorSwitch
//
//  Created by Anonymer Eintrag on 06.06.18.
//  Copyright © 2018 hs-rm.de. All rights reserved.
//

import Foundation
import SpriteKit

class PlayerFigure: SKNode {
    
    let innerCircleRadius: CGFloat = 15
    let playerBallRadius: CGFloat = 5
    
    var innerCircleX: CGFloat = 0
    var innerCircleY: CGFloat = 0
    
    
    
    var innerCircle: Circle!
    var playerBall: Circle!
    
    func create(location: CGPoint) -> SKNode {
        let player = SKNode()
        innerCircle = Circle(node: self, location: location, fill: false, fillColor: SKColor.red, strokeColor: SKColor.red, radius: innerCircleRadius)
        playerBall = Circle(node: self, location: CGPoint(x:location.x,y:location.y + (innerCircleRadius + playerBallRadius)), fill: true, fillColor: SKColor.blue, strokeColor: SKColor.blue, radius: playerBallRadius)
        let circle = innerCircle.create()
        circle.name = "inner"
        let ballPlayer = playerBall.create()
        ballPlayer.name = "player"
        player.addChild(circle)
        player.addChild(ballPlayer)
        return player
    }
}

