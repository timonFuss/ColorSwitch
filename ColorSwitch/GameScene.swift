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
import UIKit
import CoreData
struct PhysicsCategory {
     static let Player: UInt32 = 1
     static let Obstacle: UInt32 = 2
     static let Edge: UInt32 = 4
}

class GameScene: SKScene {
     
     var collisionFlag: Bool = true
     
     var changedDuration: Bool = false
     
     //Objectvariables
     let colors = [SKColor.blue, SKColor.red, SKColor.yellow, SKColor.purple]
     var colorIdx: Int = 0
     var playerFigure = PlayerFigure()
     var obstacles: [SKNode] = []
     var elementList: [SKNode] = []
     var objectList: [Element] = []
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
     var creationTime = 2.5
     var creationCounter = 1
     
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
     
     var viewController: GameViewController?
     
     override func didMove(to view: SKView) {
          self.screenCenter = CGPoint(x: view.frame.size.width/2, y: view.frame.size.height/2)
          self.newLocation = self.screenCenter
          factory = ElementFactory.getInstance()

          setupPlayerAndObstacles()
          
          physicsWorld.contactDelegate = self
          
          addPointLabel()
          motionManager = CMMotionManager()
          motionManager.startAccelerometerUpdates()
          backgroundColor = SKColor.gray
     }
     
     /// Initial creation of the PlayerFigure and start of the SKAction for
     /// the objectcreation
     func setupPlayerAndObstacles() {
          addPlayer(factory: self.factory!)
          startCreationProcess()
     }
     /// adds every second Elements
     func startCreationProcess() {
          run(SKAction.repeatForever(
               SKAction.sequence([
                    SKAction.run(addElements),
                    SKAction.wait(forDuration: self.creationTime),
                    ])
          ), withKey: "Creator")
     }
     
     /// Creates the PlayerFigure and adds it to the view
     ///
     /// - Parameter factory: Factor to create different kind of objects
     func addPlayer (factory: ElementFactory) {
          playerFigure = factory.getElement(sort: Sort.PLAYER, center: self.screenCenter, positionBottom: true) as! PlayerFigure
          playerFigureNode = playerFigure.create(location: self.screenCenter, ballLocation: self.screenCenter)
          setUpPhysicsBody()
          elementList.append(playerFigureNode)
          addChild(playerFigureNode)
     }
     /// Creates and appends a new Object to our view and objectList
     func addElements(){
          let random = arc4random_uniform(20)
          switch(random){
          case 0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16:
               let sepCircle = self.factory?.getElement(sort: Sort.SEPERATEDCIRCLE, center: self.screenCenter, positionBottom: true)
               objectList.append(sepCircle!)
               creationCounter += 1
               break
          case 17,18,19:
               let randomPos = arc4random_uniform(2)
               var posBottom = true
               if randomPos == 0{
                    posBottom = false
               }
               let wall = self.factory?.getElement(sort: Sort.WALL, center: self.screenCenter, positionBottom: posBottom)
               objectList.append(wall!)
               break
          default:
               let sepCircle = self.factory?.getElement(sort: Sort.SEPERATEDCIRCLE, center: self.screenCenter, positionBottom: true)
               objectList.append(sepCircle!)
               creationCounter += 1
               break
          }
     }
     /// Creates physicsbody for our PlayerFigure
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
          self.objectList.removeAll()
          playerFigureNode.removeAllChildren()
          
          for node in obstacles {
               node.removeFromParent()
          }
          
          obstacles.removeAll()
          
          //save data
          if self.viewController?.playerName != ""{
               let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
               let entity = NSEntityDescription.entity(forEntityName: "PlayerScore", in: context)
               let newScore = NSManagedObject(entity: entity!, insertInto: context)
               newScore.setValue(self.viewController?.playerName, forKey: "name")
               newScore.setValue(self.score, forKey: "score")
               
               do {
                    try context.save()
               } catch {
                    print("Failed to save data")
               }
          }          
          
          score = 0
          //scoreLabel.text = String(score)
          
          self.viewController?.performSegue(withIdentifier: "endGame", sender: Int(scoreLabel.text!))
          //setupPlayerAndObstacles()
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
          var removeIdx = 0
          for element in objectList{
               if element.isActive(){
                    var shapeNode = SKShapeNode()
                    if element.isFirstCreation() {
                         shapeNode = element.create()
                         addChild(shapeNode)
                    }else{
                         shapeNode = element.doAnimation()
                         addChild(shapeNode)
                    }
                    
               }else{
                    self.objectList.remove(at: removeIdx)
               }
               removeIdx += 1
          }
          
          // After every 6th created Circleobject -> reduce the creationTime by 0.1 seconds
          if(self.creationCounter % 6 == 0){
               /*To avoid the startCreationProcess call on every update-tick after we create our sixth Circleobject, there is a boolean to check if we already called the Method.
                 If its the first call for this Tick, we change the creationTime, call our startCreationProcess and set changedDirection to true.
                 When we create a new Circleobject, we set changedDirection back to false.
                */
               if !changedDuration{
                    var removeCircleIdx : Int = 0
                    var tmpIdx = 0
                    
                    /*When the SKAction from startCreationProcess get started, it produes a Circle directly -> there are 2 Circle very close to each other,
                         so we delete the last Circle from Screen and from our internal circleList*/
                    
                    if self.objectList.last?.getObjectType() == "Circle"{
                         self.objectList.removeLast()
                    }else{
                         for ele in self.objectList{
                              if ele.getObjectType() == "Circle"{
                                   removeCircleIdx = tmpIdx
                              }
                              tmpIdx += 1
                         }
                         self.objectList.remove(at: removeCircleIdx)
                    }
                    
                    removeAction(forKey: "Creator")
                    self.creationTime -= 0.1
                    
                    //Never go unter 1 Second -> to difficult and Game could crash
                    if self.creationTime <= 0.9 {
                         self.creationTime = 1.0
                    }
                    
                    startCreationProcess()
                    self.changedDuration = true
               }
          }else{
               self.changedDuration = false
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

/// Adds the Point label to the Screen
     func addPointLabel() {
          scoreLabel.position = CGPoint(x: self.screenCenter.x, y: self.screenCenter.y - 10)
          scoreLabel.fontColor = .white
          scoreLabel.fontSize = 30
          scoreLabel.text = String(score)
     }
     
/// Calculates every Animation for our Playerfigure (new Position, jumpanimation)
     private func playerFigureAnimations(){
          let pos: CGPoint = CGPoint(x: playerFigure.playerBallCircle.ball.position.x - playerFigure.innerCircle.ball.position.x, y: playerFigure.playerBallCircle.ball.position.y - playerFigure.innerCircle.ball.position.y)

          if let accelerometerData = motionManager.accelerometerData {
               // Deable the left-, right-movement from the PlayerFigre while its jumping
               if !isJumping{
                    self.setRotationAngle()
                    
                    self.jumpEndPosition = calculatePoint(degree: self.angle, position: CGPoint(x: pos.x * 2.5, y: pos.y * 2.5))
                    self.newLocation = calculatePoint(degree: self.angle, position: pos )
                    
                    removeChildren(in: [self.playerFigureNode])

                    self.playerFigureNode = playerFigure.updatePlayerFigure(locationPlayerBall: self.newLocation)
                    addChild(self.playerFigureNode)
               }else{
                    //Calculate the Points for the jumpanimation, and add the calculated Points to the jumpPositions-array
                    if self.preJumpPosition == CGPoint.zero{
                         self.preJumpPosition = self.playerFigure.playerBallShape.position
                         self.jumpPositions.append(self.preJumpPosition)
                         self.actualJumpLocation = self.preJumpPosition
                         self.jumpAmountMax = self.calculateAmount(firstPoint: self.preJumpPosition, secondPoint: self.jumpEndPosition)
                         self.jumpAmountActual = self.jumpAmountMax
                    }
                    
                    removeChildren(in: [self.playerFigureNode])
                    //If the amountdistance is > 5, we are still on the way to our jumplimit, if not -> jumpReachedMax = true
                    if self.jumpAmountActual > 5 && !self.jumpReachedMax{
                         self.actualJumpLocation = calculatePoint(degree: self.angle, position: CGPoint(x: pos.x * 1.1, y: pos.y * 1.1))
                         
                         self.jumpPositions.append(self.actualJumpLocation)
                         self.jumpAmountActual = calculateAmount(firstPoint: self.actualJumpLocation, secondPoint: self.jumpEndPosition)
                         self.jumpBackIdx += 1
                    }else{
                         self.jumpReachedMax = true
                    }
                    
                    //When we reach the peak of  our jump, walk the exact same positions back to to preJumpPosition (iterate backwards trough our jumpPositions-array)
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
     
/// Calculate the next Angle on the Circle for our Playfigure by the degree of the y-axis the device is tilted
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
// Calculates a new Point on the Circle dependent of the Playfigures angle
     /// Calculates a new Point on the Circle
     ///
     /// - Parameters:
     ///   - degree: for the next Position on the Circle
     ///   - position: position
     /// - Returns: the new calculated Point
     private func calculatePoint(degree: CGFloat, position: CGPoint) -> CGPoint{
          var x = sqrt((position.x * position.x) + (position.y * position.y)) * cos(degree)
          var y = sqrt((position.x * position.x) + (position.y * position.y)) * sin(degree)
          x = x + playerFigure.innerCircle.ball.position.x
          y = y + playerFigure.innerCircle.ball.position.y
          return CGPoint(x: x, y: y)
     }
     
     /// Calculates the amount between two points
     ///
     /// - Parameters:
     ///   - firstPoint: point from
     ///   - secondPoint: point to
     /// - Returns: calculated amount between these two points
     private func calculateAmount(firstPoint: CGPoint, secondPoint: CGPoint) -> CGFloat{
          return sqrt(((secondPoint.x - firstPoint.x) * (secondPoint.x - firstPoint.x)) + ((secondPoint.y - firstPoint.y) * (secondPoint.y - firstPoint.y)))
     }

     /// Updates our scoreLabel after a collision
     ///
     /// - Parameter score: score to add/reduce
     private func updateScore(score: Int){
          self.score += score
          self.scoreLabel.text = String(self.score)
     }
}

extension GameScene: SKPhysicsContactDelegate {
     
     func didBegin(_ contact: SKPhysicsContact) {
          // The boolean collisionFlag avoids a multiply call of this method. No Idea why i happens
          if collisionFlag{
               if !self.isJumping{
                    if let nodeA = contact.bodyA.node as? SKShapeNode, let nodeB = contact.bodyB.node as? SKShapeNode {
                         if nodeA.fillColor != nodeB.fillColor {
                              //If the colors from nodeA and nodeB are different, stop the game
                              self.colorIdx = 0
                              self.creationTime = 2.0
                              self.creationCounter = 1
                              dieAndRestart()
                         }else{
                              //If the colors from nodeA and nodeB are equal, remove the Circle and udate the scorelabel
                              //Get the index of the first Circle
                              var removeCircleIdx: Int = 0
                              for ele in self.objectList{
                                   if ele.getObjectType() == "Circle"{
                                        break
                                   }else{
                                        removeCircleIdx += 1
                                   }
                              }
                              updateScore(score: 1)
                              self.objectList.remove(at: removeCircleIdx)
                         }
                    }
               }else{
                    updateScore(score: -1)
                    self.objectList[0].setObjectIsInactive()
                    self.objectList.removeFirst()
               }
               self.collisionFlag = false
          }else{
               self.collisionFlag = true
          }
     }
}


