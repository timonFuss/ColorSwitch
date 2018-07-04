//
//  GameScene.swift
//  ColorSwitch
//
//  Created by Anonymer Eintrag on 06.06.18.
//  Copyright © 2018 hs-rm.de. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreMotion

struct PhysicsCategory {
     static let Player: UInt32 = 1
     static let Obstacle: UInt32 = 2
     static let Edge: UInt32 = 4
}

class GameScene: SKScene {
     
     var collisionFlag: Bool = true
     
     //Objectvariables
     let colors = [SKColor.blue, SKColor.red, SKColor.yellow, SKColor.purple]
     var colorIdx: Int = 0
     var playerFigure = PlayerFigure()
     var obstacles: [SKNode] = []
     var elementList: [SKNode] = []
     var circleList: [Element] = []
     var playerFigureNode: SKNode = SKNode()
     var factory: ElementFactory?
     
     //MotionVariables
     var motionManager: CMMotionManager!
     var touchLocation: CGPoint = CGPoint.zero
     var touched: Bool = false
     var touchStartLocation: CGPoint = CGPoint.zero
     var touchEndLocation: CGPoint = CGPoint.zero
     var phoneTendInYAxis: Double = 0.0
     
     //InformationVariables
     var angle: CGFloat = CGFloat(Double.pi * 1/2)
     var screenCenter: CGPoint = CGPoint.zero
     let scoreLabel = SKLabelNode()
     var score = 0
     var newLocation: CGPoint = CGPoint.zero
     
     //Jumpvariables
     var actualJumpLocation: CGPoint = CGPoint.zero
     var preJumpPosition: CGPoint = CGPoint.zero
     var jumpAmountMax: CGFloat = 0
     var jumpAmountActual: CGFloat = 0
     var jumpEndPosition: CGPoint = CGPoint.zero
     var jumpanimationStarted: Bool = false
     var isJumping: Bool = false
     var jumpPositions: [CGPoint] = []
     var jumpBackIdx: Int = 0
     var jumpReachedMax: Bool = false
     
     override func didMove(to view: SKView) {
          self.screenCenter = CGPoint(x: view.frame.size.width/2, y: view.frame.size.height/2)
          self.newLocation = self.screenCenter
          factory = ElementFactory.getInstance()

          setupPlayerAndObstacles()
          
          physicsWorld.contactDelegate = self
          
          addPointLabel()
          motionManager = CMMotionManager()
          motionManager.startAccelerometerUpdates()
          backgroundColor = SKColor.black
          view.showsPhysics = true
     }
     
     func setupPlayerAndObstacles() {
          addPlayer(factory: self.factory!)
          
          //adds every second Elements
          run(SKAction.repeatForever(
               SKAction.sequence([
                    SKAction.run(addElements),
                    SKAction.wait(forDuration: 2.5)
                    ])
          ), withKey: "Creator")
     }
     
     func addPlayer (factory: ElementFactory) {
          playerFigure = factory.getElement(sort: Sort.PLAYER, center: self.screenCenter, positionBottom: true) as! PlayerFigure
          playerFigureNode = playerFigure.create(location: self.screenCenter, ballLocation: self.screenCenter)
          setUpPhysicsBody()
          elementList.append(playerFigureNode)
          addChild(playerFigureNode)
     }
     
     func addElements(){
          let random = arc4random_uniform(20)
          switch(random){
          case 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16:
               let sepCircle = self.factory?.getElement(sort: Sort.SEPERATEDCIRCLE, center: self.screenCenter, positionBottom: true)
               circleList.append(sepCircle!)
               break
          case 17,18,19:
               let randomPos = arc4random_uniform(2)
               var posBottom = true
               if randomPos == 0{
                    posBottom = false
               }
               let wall = self.factory?.getElement(sort: Sort.WALL, center: self.screenCenter, positionBottom: posBottom)
               circleList.append(wall!)
               break
          default:
               let sepCircle = self.factory?.getElement(sort: Sort.SEPERATEDCIRCLE, center: self.screenCenter, positionBottom: true)
               circleList.append(sepCircle!)
               break
          }
     }
     
     func setUpPhysicsBody(){
          let playerBody = SKPhysicsBody(circleOfRadius: self.playerFigure.playerBallCircle.radius - 4)
          playerBody.categoryBitMask = PhysicsCategory.Player
          playerBody.collisionBitMask = 4
          playerBody.affectedByGravity = false
          playerFigureNode.childNode(withName: "player")?.physicsBody = playerBody
          
     }
     
     func dieAndRestart() {
          //Removes all Elements from elementList and from Gamescene
          deleteElementList()
          removeAllChildren()
          removeAction(forKey: "Creator")
          self.circleList.removeAll()
          playerFigureNode.removeAllChildren()
          
          for node in obstacles {
               node.removeFromParent()
          }
          
          obstacles.removeAll()
          
          score = 0
          scoreLabel.text = String(score)
          
          
          setupPlayerAndObstacles()
     }
     
     override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
          touched = true
          for touch in touches{
               touchLocation = touch.location(in: self)
               self.touchStartLocation = touch.location(in: self)
          }
     }
     
     override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
          for touch in touches{
               touchLocation = touch.location(in: self)
          }
     }
     
     override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
          for touch in touches{
               self.touchEndLocation = touch.location(in: self)
          }
          print(self.touchEndLocation)
          
          
          let swipeDistance = calculateAmount(firstPoint: self.touchStartLocation, secondPoint: self.touchEndLocation)
          
          if swipeDistance > 20 && !self.isJumping{
               
               self.isJumping = true
          }else{
               self.colorIdx += 1
               if self.colorIdx > 3{
                    self.colorIdx = 0
               }
               playerFigure.playerBallCircle.ball.fillColor = colors[self.colorIdx]
               
               //Changes the color of the innerCircle to the next color when pushed
               var idx = colorIdx + 1
               if idx == 4{
                    idx = 0
               }
               playerFigure.innerCircleShape.strokeColor = colors[idx]
          }
          
          touched = false
     }

     override func update(_ currentTime: TimeInterval) {
          removeAllChildren()
          addChild(scoreLabel)
          self.playerFigureAnimations()
          
          for element in circleList{
               if element.isActive(){
                    var shapeNode = SKShapeNode()
                    if element.isFirstCreation() {
                         shapeNode = element.create()
                         addChild(shapeNode)
                    }else{
                         shapeNode = element.doAnimation()
                         addChild(shapeNode)
                    }
                    
               }
          }
     }
     
     func stop(){
          for obstacle in obstacles {
               obstacle.removeAllActions()
          }
     }
     
     func deleteElementList() {
          for element in elementList {
               element.removeFromParent()
          }
          elementList.removeAll()
     }
     
     func addPointLabel() {
          scoreLabel.position = self.screenCenter
          scoreLabel.fontColor = .white
          scoreLabel.fontSize = 30
          scoreLabel.text = String(score)
     }
     
     private func playerFigureAnimations(){
          let pos: CGPoint = CGPoint(x: playerFigure.playerBallCircle.ball.position.x - playerFigure.innerCircle.ball.position.x, y: playerFigure.playerBallCircle.ball.position.y - playerFigure.innerCircle.ball.position.y)

          if let accelerometerData = motionManager.accelerometerData {
               if !isJumping{
                    self.setRotationAngle()
                    
                    self.jumpEndPosition = calculatePoint(degree: self.angle, position: CGPoint(x: pos.x * 2.5, y: pos.y * 2.5))
                    self.newLocation = calculatePoint(degree: self.angle, position: pos )
                    
                    removeChildren(in: [self.playerFigureNode])

                    self.playerFigureNode = playerFigure.updatePlayerFigure(locationPlayerBall: self.newLocation)
                    addChild(self.playerFigureNode)
               }else{
                    
                    
                    if self.preJumpPosition == CGPoint.zero{
                         self.preJumpPosition = self.playerFigure.playerBallShape.position
                         self.jumpPositions.append(self.preJumpPosition)
                         self.actualJumpLocation = self.preJumpPosition
                         self.jumpAmountMax = self.calculateAmount(firstPoint: self.preJumpPosition, secondPoint: self.jumpEndPosition)
                         self.jumpAmountActual = self.jumpAmountMax
                    }
                    
                    removeChildren(in: [self.playerFigureNode])
                    if self.jumpAmountActual > 5 && !self.jumpReachedMax{
                         self.actualJumpLocation = calculatePoint(degree: self.angle, position: CGPoint(x: pos.x * 1.1, y: pos.y * 1.1))
                         
                         self.jumpPositions.append(self.actualJumpLocation)
                         self.jumpAmountActual = calculateAmount(firstPoint: self.actualJumpLocation, secondPoint: self.jumpEndPosition)
                         self.jumpBackIdx += 1
                    }else{
                         self.jumpReachedMax = true
                    }
                    
                    if self.jumpReachedMax{
                         self.actualJumpLocation = self.jumpPositions[self.jumpBackIdx]

                         if self.jumpBackIdx > 0{
                              self.jumpBackIdx -= 1
                         }else{
                              self.isJumping = false
                              self.jumpReachedMax = false
                              self.jumpPositions.removeAll()
                              self.actualJumpLocation = self.preJumpPosition
                              self.preJumpPosition = CGPoint.zero
                         }
                    }
                    
                    self.playerFigureNode = playerFigure.updatePlayerFigure(locationPlayerBall: self.actualJumpLocation)
                    addChild(self.playerFigureNode)
               }
               self.phoneTendInYAxis = accelerometerData.acceleration.y
          }
          
     }
     
     private func setRotationAngle(){
          if self.phoneTendInYAxis >= 0.05{
               
               if self.phoneTendInYAxis < 0.1{
                    self.angle += 0.03
               }else if self.phoneTendInYAxis >= 0.1 && self.phoneTendInYAxis < 0.2{
                    self.angle += 0.04
               }else if self.phoneTendInYAxis >= 0.2 && self.phoneTendInYAxis < 0.3{
                    self.angle += 0.07
               }else if self.phoneTendInYAxis >= 0.3 && self.phoneTendInYAxis < 0.4{
                    self.angle += 0.08
               }else if self.phoneTendInYAxis >= 0.4 && self.phoneTendInYAxis < 0.5{
                    self.angle += 0.1
               }else if self.phoneTendInYAxis >= 0.5{
                    self.angle += 0.12
               }
               
          }else if self.phoneTendInYAxis <= -0.1{
               
               if self.phoneTendInYAxis > -0.1{
                    self.angle -= 0.03
               }else if self.phoneTendInYAxis <= -0.1 && self.phoneTendInYAxis > -0.2{
                    self.angle -= 0.04
               }else if self.phoneTendInYAxis <= -0.2 && self.phoneTendInYAxis > -0.3{
                    self.angle -= 0.07
               }else if self.phoneTendInYAxis <= -0.3 && self.phoneTendInYAxis > -0.4{
                    self.angle -= 0.08
               }else if self.phoneTendInYAxis <= -0.4 && self.phoneTendInYAxis > -0.5{
                    self.angle -= 0.1
               }else if self.phoneTendInYAxis <= -0.5{
                    self.angle -= 0.12
               }
          }
     }
     
     private func calculatePoint(degree: CGFloat, position: CGPoint) -> CGPoint{
          var x = sqrt((position.x * position.x) + (position.y * position.y)) * cos(degree)
          var y = sqrt((position.x * position.x) + (position.y * position.y)) * sin(degree)
          x = x + playerFigure.innerCircle.ball.position.x
          y = y + playerFigure.innerCircle.ball.position.y
          return CGPoint(x: x, y: y)
     }
     
     private func calculateAmount(firstPoint: CGPoint, secondPoint: CGPoint) -> CGFloat{
          return sqrt(((secondPoint.x - firstPoint.x) * (secondPoint.x - firstPoint.x)) + ((secondPoint.y - firstPoint.y) * (secondPoint.y - firstPoint.y)))
     }

     
     private func updateScore(score: Int){
          self.score += score
          self.scoreLabel.text = String(self.score)
     }
}

extension GameScene: SKPhysicsContactDelegate {
     
     func didBegin(_ contact: SKPhysicsContact) {
          //contact.bodyA = Kreiselement
          if collisionFlag{
             
               if !self.isJumping{
                    if let nodeA = contact.bodyA.node as? SKShapeNode, let nodeB = contact.bodyB.node as? SKShapeNode {
                         if nodeA.fillColor != nodeB.fillColor {
                              self.colorIdx = 0
                              dieAndRestart()
                         }else{
                              //Wenn farbe gleich -> Kreis zernichten!
                              updateScore(score: 10)
                              self.circleList.removeFirst()
                         }
                    }
               }else{
                    updateScore(score: -10)
                    self.circleList[0].setObjectIsInactive()
                    self.circleList.removeFirst()
               }
               self.collisionFlag = false
          }else{
               self.collisionFlag = true
          }
          
     }
}


