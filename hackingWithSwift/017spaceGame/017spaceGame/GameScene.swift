//
//  GameScene.swift
//  017spaceGame
//
//  Created by Vaughn on 9/3/19.
//  Copyright © 2019 Vaughn Anton. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var starfield: SKEmitterNode!
    var player: SKSpriteNode!
    
    var scoreLabel: SKLabelNode!
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    let possibleEnemies = ["ball", "hammer", "tv"]
    var isGameOver = false
    // five parameterrs, seconds to delay, what object should be told when timer fires, what method should be called on the object when fires, any context to provide, and whether should repeat
    var gameTimer: Timer?
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    override func didMove(to view: SKView) {
        
        // create about 3 enemies per second
        gameTimer = Timer.scheduledTimer(timeInterval: 0.35, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
        backgroundColor = .black
        
        starfield = SKEmitterNode(fileNamed: "starfield")!
        starfield.position = CGPoint(x: 1024, y: 384)
        // lag the simulation 10 seconds so the whole field is lit up with stars, instead of coming in from the right
        starfield.advanceSimulationTime(10)
        addChild(starfield)
        starfield.zPosition = -1
        
        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: 100, y: 384)
        // make per pixel detection work by passing in player's current texture and size
        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.size)
        player.physicsBody?.contactTestBitMask = 1
        addChild(player)
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.horizontalAlignmentMode = .left
        addChild(scoreLabel)
        
        score = 0
        
        physicsWorld.gravity = CGVector(dx: 0, dy: 0)
        // sets current game scene to be the contact delegate of the physics world
        physicsWorld.contactDelegate = self
        
    }
    
    @objc func createEnemy() {
        // shuffle array
        guard let enemy = possibleEnemies.randomElement() else { return }
        // choose enemy
        let sprite = SKSpriteNode(imageNamed: enemy)
        // place it at a random vertical position from the right side of screen
        sprite.position = CGPoint(x: 1200, y: Int.random(in: 50...736))
        addChild(sprite)
        
        // create the debris physics body for per pixel collision
        sprite.physicsBody = SKPhysicsBody(texture: sprite.texture!, size: sprite.size)
        // set the z index to same as player
        sprite.physicsBody?.categoryBitMask = 1
        // move to left at fast speed
        sprite.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
        // give it angular speed as well
        sprite.physicsBody?.angularVelocity = 5
        // these two lines will make movement/rotation not slow down over time
        sprite.physicsBody?.linearDamping = 0
        sprite.physicsBody?.angularDamping = 0
    }
    
    override func update(_ currentTime: TimeInterval) {
        // remove the debris nodes from the scene once they have passed the player
        for node in children {
            // anything beyond x position -300 will be considered dead
            if node.position.x < -300 {
                node.removeFromParent()
            }
        }
        // add to score if the game is still going
        if !isGameOver {
            score += 1
        }
    }
    
    // method to move player
    override func touchesMoved(_ touches: Set<UITouch>, with even: UIEvent?) {
        guard let touch = touches.first else { return }
        var location = touch.location(in: self)
        
        // keep the player in a channel that is symettrical (won't go over score label)
        if location.y < 100 {
            location.y = 100
        } else if location.y > 668 {
            location.y = 668
        }
        
        player.position = location
    }
    
    // method to end game if collision happens, create a particle emitter and use an explosion while removing the player
    func didBegin(_ contact: SKPhysicsContact) {
        let explosion = SKEmitterNode(fileNamed: "explosion")!
        explosion.position = player.position
        addChild(explosion)
        
        player.removeFromParent()
        // end the game
        isGameOver = true
    }
    
}
