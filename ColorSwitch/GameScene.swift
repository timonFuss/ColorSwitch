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
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    let colors = [SKColor.yellow, SKColor.red, SKColor.blue, SKColor.purple]
    let obstacleSpacing: CGFloat = 800
    
    var angle: CGFloat = CGFloat(Double.pi * 1/2)
    var location: CGPoint = CGPoint.zero
    var touched: Bool = false
    var playerFigure = PlayerFigure()
    var obstacles: [SKNode] = []
    var elementList: [SKNode] = []
     var circleList: [Element] = []
     var circleShapeNodeList: [SKShapeNode] = []
     
     
    var center: CGPoint = CGPoint(x:0,y:0)
    var playerFigureNode: SKNode = SKNode()
    var factory: ElementFactory?
    
    //var sepCircle: Element? = nil
    //var sepCircleNode: SKShapeNode? = nil
    var i: CGFloat = CGFloat(0)
    
    let scoreLabel = SKLabelNode()
    var score = 0
    
    var motionManager: CMMotionManager!
    var stopLocation: CGPoint = CGPoint.zero
    var newLocation: CGPoint = CGPoint.zero
    var touchStartLocation: CGPoint = CGPoint.zero
    var touchEndLocation: CGPoint = CGPoint.zero
    var isJumping: Bool = false
    var lastY: Double = 0.0
    var lastX: Double = 0.0
    var initialSet: Bool = true
    var jumpEndPosition: CGPoint = CGPoint.zero
     var jumpanimationStarted: Bool = false
     
     var listIndex = 0
     
    enum Environment {
        case development
        case production
    }
    
    let environment: Environment = .production
 
    override func didMove(to view: SKView) {
        self.center = CGPoint(x: view.frame.size.width/2, y: view.frame.size.height/2)
        factory = ElementFactory.getInstance()
     
        //addChild(playerFigure.create(location: self.center, ballLocation: self.center, initialSet: self.initialSet))
     
        //self.initialSet = !self.initialSet
        setupPlayerAndObstacles()
     
        
        physicsWorld.contactDelegate = self
    
        addPointLabel()
        self.stopLocation = self.center
        motionManager = CMMotionManager()
        motionManager.startAccelerometerUpdates()
        backgroundColor = SKColor.black
    }
     
     

    
    func setupPlayerAndObstacles() {
        addPlayer(factory: self.factory!)
        
        //adds every second Elements

     run(SKAction.repeatForever(
          SKAction.sequence([
               SKAction.run(addElements),
               SKAction.wait(forDuration: 0.5)
               ])
     ), withKey: "Creator")
    }
    
    func addPlayer (factory: ElementFactory) {
     playerFigure = factory.getElement(sort: Sort.PLAYER, center: self.center) as! PlayerFigure
        playerFigureNode = playerFigure.create(location: self.center, ballLocation: self.center, initialSet: self.initialSet)
        setUpPhysicsBody()
        elementList.append(playerFigureNode)
        addChild(playerFigureNode)
    }
    
    func addElements(){
     let sepCircle = self.factory?.getElement(sort: Sort.SEPERATEDCIRCLE, center: self.center)
        //var sepCircleNode = sepCircle?.create()
          circleList.append(sepCircle!)
        //addChild(sepCircleNode!)
    }
    
    func setUpPhysicsBody(){
        let playerBody = SKPhysicsBody(circleOfRadius: self.playerFigure.playerBall.radius)
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
        //sepCircleNode?.removeAllChildren()
        
        for node in obstacles {
            node.removeFromParent()
        }
        
        obstacles.removeAll()
        
        score = 0
        scoreLabel.text = String(score)
     
     
        setupPlayerAndObstacles()
    }
    
    private func doAnimation(degree: CGFloat, position: CGPoint) -> CGPoint{
        var x = sqrt((position.x * position.x) + (position.y * position.y)) * cos(degree)
        var y = sqrt((position.x * position.x) + (position.y * position.y)) * sin(degree)
        x = x + playerFigure.innerCircle.ball.position.x
        y = y + playerFigure.innerCircle.ball.position.y
        return CGPoint(x: x, y: y)
    }
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
    }
    
    func touchUp(atPoint pos : CGPoint) {
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        touched = true
        for touch in touches{
            location = touch.location(in: self)
            self.touchStartLocation = touch.location(in: self)
        }
     
          //self.angle += 5
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            location = touch.location(in: self)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            self.touchEndLocation = touch.location(in: self)
        }
        
        let swipeDistance = sqrt(((self.touchEndLocation.x-self.touchStartLocation.x) * (self.touchEndLocation.x-self.touchStartLocation.x)) + ((self.touchEndLocation.y-self.touchStartLocation.y) * (self.touchEndLocation.y-self.touchStartLocation.y)))
        
        if swipeDistance > 20 && !self.isJumping{
            self.isJumping = !self.isJumping
        }
        
        touched = false
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func update(_ currentTime: TimeInterval) {

        removeAllChildren()
     
     
     
     
     
        playerFigureAnimations()
     
     
     
     
     
     
        //TODO UM ROTATION KÜMMERN
        //for schleife und alle elemente kleiner machen
     
     for element in circleList{
          if element.isActive(){
               var shapeNode = SKShapeNode()
               if element.getBool() {
                    shapeNode = element.create()
                    circleShapeNodeList.append(shapeNode)
                    addChild(shapeNode)
               }else{
                    shapeNode = element.doAnimation()
                    addChild(shapeNode)
               }
               
          }
     }
     
     
     
        /*if sepCircle!.isActive() {
            sepCircleNode?.removeFromParent()
            //sepCircleNode = SKShapeNode()
            sepCircleNode = sepCircle?.doAnimation()
            addChild(sepCircleNode!)
        }*/
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
        scoreLabel.position = CGPoint(x: 50, y: 25)
        scoreLabel.fontColor = .white
        scoreLabel.fontSize = 30
        scoreLabel.text = String(score)
        addChild(scoreLabel)
    }
    
    private func playerFigureAnimations(){
                let pos: CGPoint = CGPoint(x: playerFigure.playerBall.ball.position.x - playerFigure.innerCircle.ball.position.x, y: playerFigure.playerBall.ball.position.y - playerFigure.innerCircle.ball.position.y)
     

     
        //addChild(playerFigure.create(location: CGPoint(x: (view?.frame.size.width)! / 2.0, y: (view?.frame.size.height)! / 2.0), ballLocation: self.stopLocation, initialSet: self.initialSet))
          //addChild(playerFigure.updatePlayerFigure(locationPlayerBall: doAnimation(degree: self.angle, position: pos))) //KANN VERMUTLICH RAUS
            if let accelerometerData = motionManager.accelerometerData {
                if self.lastY > 0.1{
                    if self.lastY < 0.4{
                        self.angle += 0.05
                    }else {
                        self.angle += 0.08
                    }
                }else if self.lastY < -0.1{
                    if self.lastY > -0.4{
                        self.angle -= 0.05
                    }else{
                        self.angle -= 0.08
                    }
                }
               
                //initialSet = false

               
                if !isJumping{
                    
                    self.jumpEndPosition = doAnimation(degree: self.angle, position: CGPoint(x: pos.x * 3, y: pos.y * 3))
                    self.newLocation = doAnimation(degree: self.angle, position: pos )
                    
                    removeChildren(in: [self.playerFigureNode])
                    //addChild(playerFigure.create(location: self.center, ballLocation: self.newLocation, initialSet: self.initialSet))
                    self.playerFigureNode = playerFigure.updatePlayerFigure(locationPlayerBall: self.newLocation)
                    addChild(self.playerFigureNode)
                }else{
                    if(!jumpanimationStarted){
                         
                         var i: CGFloat = 1.1
                         
                         while(i <= 3.0){
                              for ele in elementList{
                                   ele.removeFromParent()
                              }
                              let newPosition = self.doAnimation(degree: self.angle, position: CGPoint(x: pos.x * i, y: pos.y*i))
                              i += 0.001
                              
                              let obj = playerFigure.create(location: self.center, ballLocation: newPosition, initialSet: self.initialSet)
                              elementList.append(obj)
                              addChild(obj)
                         }
                         jumpanimationStarted = !jumpanimationStarted
                         
                         let animation = SKAction.move(to: self.jumpEndPosition, duration: 0.1)
                         let kp = SKAction.scale(by: 2, duration: 5)
                         let sequence = SKAction.sequence([animation, kp])
                         
                         //sepCircleNode?.run(sequence)
                         playerFigure.playerBall.ball.run(sequence)
                         self.isJumping = true
                         
                         //addChild(playerFigure.create(location: CGPoint(x: (view?.frame.size.width)! / 2.0, y: (view?.frame.size.height)! / 2.0), ballLocation: self.jumpEndPosition, initialSet: self.initialSet))
                    }else {
                         print("animation läuft")
                    }
                    
                }
                stopLocation = newLocation
                
                self.lastY = accelerometerData.acceleration.y
            }

    }
     
     private func doJumpAnimation(){
          let animation = SKAction.move(to: CGPoint.zero, duration: 10)
          let kp = SKAction.scale(by: 2, duration: 5)
          let sequence = SKAction.sequence([animation, kp])
          
          //sepCircleNode?.run(sequence)
          
          self.isJumping = !self.isJumping
     }
}

extension GameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        if let nodeA = contact.bodyA.node as? SKShapeNode, let nodeB = contact.bodyB.node as? SKShapeNode {
            if nodeA.fillColor != nodeB.fillColor {
                dieAndRestart()
            }
        }
    }
}


