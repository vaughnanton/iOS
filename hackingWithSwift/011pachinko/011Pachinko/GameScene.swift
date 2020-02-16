//
//  GameScene.swift
//  011Pachinko
//
//  Created by Vaughn on 7/15/19.
//  Copyright © 2019 Vaughn Anton. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var scoreLabel: SKLabelNode!
    var editLabel: SKLabelNode!
    
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    var editingMode: Bool = false {
        didSet {
            if editingMode {
                editLabel.text = "Done"
            } else {
                editLabel.text = "Edit"
            }
        }
    }
    
    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "background.jpg")
        background.position = CGPoint(x:512, y:384)
        // replace means, just draw it ignoring any alpha values
        background.blendMode = .replace
        background.zPosition = -1
        // add node to the scene as part of the node tree
        addChild(background)
        
        // adds a physics body to the whole scene at the edges (acts like a container for the whole scene)
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        // assign current scene to be the physics world's contact delegate
        physicsWorld.contactDelegate = self
        
        makeSlot(at: CGPoint(x: 128, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 384, y: 0), isGood: false)
        makeSlot(at: CGPoint(x: 640, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 896, y: 0), isGood: false)
        
        makeBouncer(at: CGPoint(x: 0, y: 0))
        makeBouncer(at: CGPoint(x: 256, y: 0))
        makeBouncer(at: CGPoint(x: 512, y: 0))
        makeBouncer(at: CGPoint(x: 768, y: 0))
        makeBouncer(at: CGPoint(x: 1024, y: 0))
        
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: 0"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: 980, y: 700)
        addChild(scoreLabel)
        
        editLabel = SKLabelNode(fontNamed: "Chalkduster")
        editLabel.text = "Edit"
        editLabel.position = CGPoint(x: 80, y: 700)
        addChild(editLabel)
        
    }
    
    func makeBouncer(at position: CGPoint) {
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2.0)
        // when true the object will be moved by the physics simulator based on gravity and collisions
        // when it's false the object will collide with other things but won't move as a result
        bouncer.physicsBody?.isDynamic = false
        addChild(bouncer)
    }
    
    // second parameter is whether the slot is good or not, loads image
    func makeSlot(at position: CGPoint, isGood: Bool) {
        var slotBase: SKSpriteNode
        var slotGlow: SKSpriteNode
        
        if isGood {
            slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
            slotGlow = SKSpriteNode(imageNamed: "slowGlowGood")
            slotBase.name = "good"
        } else {
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
            slotBase.name = "bad"
        }
        
        slotBase.position = position
        slotGlow.position = position
        
        // add physics to the slots
        slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)
        // we don't want the slot base to move when a ball hits it
        slotBase.physicsBody?.isDynamic = false
        
        addChild(slotBase)
        addChild(slotGlow)
        
        // spin the slots, in radians - pi is equal to 180 degrees - over 10 seconds
        let spin = SKAction.rotate(byAngle: .pi, duration: 10)
        let spinForever = SKAction.repeatForever(spin)
        // will do this action endlessly
        slotGlow.run(spinForever)
    }
    
    // senses touch, get a data set of touches like an array except each object can appear only once (ie multiple touches at same time)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first {
            // where it was touched in relation to self
            let location = touch.location(in: self)
            
            let objects = nodes(at: location)
            
            if objects.contains(editLabel) {
                editingMode.toggle()
            } else {
                if editingMode {
                    // create a box
                    let size = CGSize(width: Int.random(in: 16...128), height: 16)
                    let box = SKSpriteNode(color: UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1), size: size)
                    box.zRotation = CGFloat.random(in: 0...3)
                    box.position = location
                    box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
                    box.physicsBody?.isDynamic = false
                    addChild(box)
                } else {
                    // create a ball
                    let ball = SKSpriteNode(imageNamed: "ballRed")
                    // adds a physics body to the ball
                    ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
                    // contactBitMask "Which collisions do you want to know about" default is nothing / collisionBitMask "Which nodes should I bump into?" default is everything
                    ball.physicsBody!.contactTestBitMask = ball.physicsBody!.collisionBitMask
                    // restitution is a 'bounciness', node of physics body is optional because it might not exist
                    ball.physicsBody?.restitution = 0.4
                    // set the position where it is tapped
                    ball.position.x = CGFloat(location.x)
                    ball.position.y = 768
                    // name it
                    ball.name = "ball"
                    // add it to the scene
                    addChild(ball)
                }
            }
        }
    }
    
    func collisionBetween(ball: SKNode, object: SKNode) {
        if object.name == "good" {
            destroy(ball: ball)
            score += 1
        } else if object.name == "bad" {
            destroy(ball: ball)
            score -= 1
        }
    }
    
    func destroy(ball: SKNode) {
        if let fireParticles = SKEmitterNode(fileNamed: "FireParticles") {
            fireParticles.position = ball.position
            addChild(fireParticles)
        }
        // removes a node from the node tree (game)
        ball.removeFromParent()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        // use guard to ensure both bodyA and bodyB have nodes attached, so if ghost collision we don't crash the program
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        if nodeA.name == "ball" {
            collisionBetween(ball: nodeA, object: nodeB)
        } else if nodeB.name == "ball" {
            collisionBetween(ball: nodeB, object: nodeA)
        }
    }
    
}

