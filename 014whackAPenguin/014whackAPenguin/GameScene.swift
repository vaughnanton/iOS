//
//  GameScene.swift
//  014whackAPenguin
//
//  Created by Vaughn on 8/15/19.
//  Copyright © 2019 Vaughn Anton. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var slots = [WhackSlot]()
    var gameScore: SKLabelNode!
    var score = 0 {
        didSet {
            gameScore.text = "Score: \(score)"
        }
    }
    var popupTime = 0.85
    var numRounds = 0
    
    // function accepts a position
    func createSlot(at position: CGPoint) {
        // creates WhackSlot object
        let slot = WhackSlot()
        slot.configure(at: position)
        // adds to scene and array
        addChild(slot)
        slots.append(slot)
    }
    
    override func didMove(to view: SKView) {
        
        let background = SKSpriteNode(imageNamed: "whackBackground")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
        
        gameScore = SKLabelNode(fontNamed: "Chalkduster")
        gameScore.text = "Score: 0"
        gameScore.position = CGPoint(x: 8,y: 8)
        gameScore.horizontalAlignmentMode = .left
        gameScore.fontSize = 48
        addChild(gameScore)
        
        // for loops for the position of the slots
        for i in 0 ..< 5 { createSlot(at: CGPoint(x: 100 + (i * 170), y: 410)) }
        for i in 0 ..< 4 { createSlot(at: CGPoint(x: 180 + (i * 170), y: 320)) }
        for i in 0 ..< 5 { createSlot(at: CGPoint(x: 100 + (i * 170), y: 230)) }
        for i in 0 ..< 4 { createSlot(at: CGPoint(x: 180 + (i * 170), y: 140)) }
        
        // call createEnemy when game starts after 1 second delay because the method itself keeps calling itself
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
            self?.createEnemy()
        }
    }
    
    func createEnemy() {
        numRounds += 1
        
        // if rounds is > 30, end the game, hid slots, show sprite, and exit method
        if numRounds >= 30 {
            for slot in slots {
                slot.hide()
            }
            
            let gameOver = SKSpriteNode(imageNamed: "gameOver")
            gameOver.position = CGPoint(x: 512, y: 384)
            gameOver.zPosition = 1
            addChild(gameOver)
            
            return
        }
        // decrease pop up time each time its called
        popupTime *= 0.991
        
        // shuffle the list of available slots
        slots.shuffle()
        // show the slot passing in current value of popupTime
        slots[0].show(hideTime: popupTime)
        
        // generate four random numbers to see if more slots should be shown (up to five at once)
        if Int.random(in: 0...12) > 4 { slots[1].show(hideTime: popupTime) }
        if Int.random(in: 0...12) > 8 {  slots[2].show(hideTime: popupTime) }
        if Int.random(in: 0...12) > 10 { slots[3].show(hideTime: popupTime) }
        if Int.random(in: 0...12) > 11 { slots[4].show(hideTime: popupTime)  }
        
        let minDelay = popupTime / 2.0
        let maxDelay = popupTime * 2
        let delay = Double.random(in: minDelay...maxDelay)
        
        // call itself again after a random delay between pop up time halfed and doubled from above (ex. if popuptime = 2 the delay will be between 1 and 4)
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) { [weak self] in
            self?.createEnemy()
        }
    }
    
    // fiugre out what was tapped with nodes at, find out where it was tapped, get a node array of alll  nodes in that point, loop through lists, see if they have charfriend or charenemy and take appropriate action
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)
        
        for node in tappedNodes {
            // get the parent of the penguin (crop node), and the parent of the crop (the WhackSlot     object) node, typecast as WhackSlot
            guard let whackSlot = node.parent?.parent as? WhackSlot else { continue }
            if !whackSlot.isVisible { continue }
            if whackSlot.isHit { continue }
            whackSlot.hit()

            // they tapped the wrong prenguin
            if node.name == "charFriend" {
                // subtract 5 from their score
                score -= 5
                
                // plays sound, don't wait for soudn to finish
                run(SKAction.playSoundFileNamed("whackBad.caf", waitForCompletion: false))
                // they tapped the right penguin
            } else if node.name == "charEnemy" {
                    guard let whackSlot = node.parent?.parent as? WhackSlot else { continue }
                    if !whackSlot.isVisible { continue }
                    if whackSlot.isHit { continue }
                
                    // scale the penguin so it looks like it got hit
                    whackSlot.charNode.xScale = 0.85
                    whackSlot.charNode.yScale = 0.85
                
                    whackSlot.hit()
                    // add 1 to score
                    score += 1
                
                    // plays sound
                    run(SKAction.playSoundFileNamed("whack.caf", waitForCompletion: false))
            }
        }
        }
}
