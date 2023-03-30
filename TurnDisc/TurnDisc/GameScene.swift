//
//  GameScene.swift
//  TurnDisc
//
//  Created by Valerie on 30.03.23.
//

import SpriteKit
import GameplayKit

var player = SKSpriteNode(imageNamed: "Planisferius")
var backgroundColorCustom = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)
var playerSize = CGSize(width: 10, height: 10)

var touchLocation = CGPoint()
var startTouch = CGPoint()
var endTouch = CGPoint()

var startingAngle:CGFloat?
var startingTime:TimeInterval?

class GameScene: SKScene {
    override func didMove(to view: SKView) {
        self.backgroundColor = backgroundColorCustom
        
        spawnPlayer()
    }
  
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
               let location = touch.location(in:self)
               let node = atPoint(location)
               if node.name == "player" {
                   let dx = location.x - node.position.x
                   let dy = location.y - node.position.y
                   // Store angle and current time
                   startingAngle = atan2(dy, dx)
                   startingTime = touch.timestamp
                   node.physicsBody?.angularVelocity = 0
               }
           }
        }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches{
            let location = touch.location(in:self)
            let node = atPoint(location)
            if node.name == "player" {
                let dx = location.x - node.position.x
                let dy = location.y - node.position.y
                
                
                let angle = atan2(dy, dx)
                // Calculate angular velocity; handle wrap at pi/-pi
                var deltaAngle = angle - startingAngle!
                if abs(deltaAngle) > CGFloat.pi {
                    if (deltaAngle > 0) {
                        deltaAngle = deltaAngle - CGFloat.pi * 2
                    }
                    else {
                        deltaAngle = deltaAngle + CGFloat.pi * 2
                    }
                }
                let dt = CGFloat(touch.timestamp - startingTime!)
                let velocity = deltaAngle / dt
                
                node.physicsBody?.angularVelocity = velocity
                
                startingAngle = angle
                startingTime = touch.timestamp
            }
        }
    }
            
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
               for touch in touches {
                   endTouch = touch.location(in: self)
               }
                startingAngle = nil
                startingTime = nil
        
                /*player.physicsBody?.applyImpulse(CGVector(dx: endTouch.x - startTouch.x, dy: endTouch.y - startTouch.y))*/
           }

    
    func spawnPlayer(){
        player.xScale = 0.5
        player.yScale = 0.5
        player.name = "player"
        player.physicsBody = SKPhysicsBody(circleOfRadius: 16)
        player.physicsBody?.affectedByGravity = false
        player.physicsBody?.isDynamic = true
           // Change this property as needed (increase it to slow faster)
        player.physicsBody!.angularDamping = 4
        player.physicsBody?.pinned = true
        player.position = CGPointMake(self.frame.midX, self.frame.midY)
        self.addChild(player)
    }
    
}
