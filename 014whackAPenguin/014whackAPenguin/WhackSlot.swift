//
//  WhackSlot.swift
//  014whackAPenguin
//
//  Created by Vaughn on 8/21/19.
//  Copyright © 2019 Vaughn Anton. All rights reserved.
//

// this subclass of SKNode will hold all hole related functionality

import SpriteKit
import UIKit

class WhackSlot: SKNode {
    
    // am I currently visible, avoids players tapping slots that are supposed to be invisible
    var isVisible = false
    // have I already been hit, so players can't wahack a penguin more than once
    var isHit = false

    // where we store the penguin picture node
    var charNode: SKSpriteNode!
    
    func configure(at position: CGPoint) {
        self.position = position
        
        let sprite = SKSpriteNode(imageNamed: "whackHole")
        addChild(sprite)
        
        // create a new SKCropNode (uses an image as cropping mask, anything in colored part is visible and anything in transparent part is invisible) and place it above the slot
        let cropNode = SKCropNode()
        cropNode.position = CGPoint(x: 0, y: 15)
        // z position puts it in front of other nodes
        cropNode.zPosition = 1
        // everything with color is visible and the transparent is invisible
        cropNode.maskNode = SKSpriteNode(imageNamed: "whackMask")
            
        // create character node with penguinGood graphic
        charNode = SKSpriteNode(imageNamed: "penguinGood")
        // placed at -90 which makes it seem like its hiding
        charNode.position = CGPoint(x: 0, y: -90)
        charNode.name = "character"
        // charNode addded to crop node
        cropNode.addChild(charNode)
        // cropNode added to the slot
        addChild(cropNode)
    }
    
    func show(hideTime: Double) {
        // if it is visible, then exit
        if isVisible { return }
        
        // reset the scales to 1 for when it's been hit before 
        charNode.xScale = 1
        charNode.yScale = 1
        
        // slide penguin out
        charNode.run(SKAction.moveBy(x: 0, y: 80, duration: 0.05))
        isVisible = true
        isHit = false
        
        if Int.random(in: 0...2) == 0 {
            // use SKTexture to change the image color so we're not replacing full nodes
            charNode.texture = SKTexture(imageNamed: "penguinGood")
            charNode.name = "charFriend"
        } else {
            charNode.texture = SKTexture(imageNamed: "penguinEvil")
            charNode.name = "charEnemy"
        }
        
        // hide after 3.5x of the popupTime)
        DispatchQueue.main.asyncAfter(deadline: .now() + (hideTime * 3.5)) { [weak self] in
            self?.hide()
        }
    }
    
    func hide() {
        // if it's already hidden, exit
        if !isVisible { return }
        // penguin hides
        charNode.run(SKAction.moveBy(x: 0, y: -80, duration: 0.05))
        // isVisible is set to false
        isVisible = false
    }
    
    func hit() {
        isHit = true
        // wait for duration before creating action
        let delay = SKAction.wait(forDuration: 0.25)
        // move the penguins
        let hide = SKAction.moveBy(x: 0, y: -80, duration: 0.5)
        // set it to invisible again
        let notVisible = SKAction.run { [unowned self] in self.isVisible = false }
        // pass the array of action above so they run in order
        charNode.run(SKAction.sequence([delay, hide, notVisible]))
    }
    
}
