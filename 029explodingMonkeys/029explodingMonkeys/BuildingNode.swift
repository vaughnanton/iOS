//
//  BuildingNode.swift
//  029explodingMonkeys
//
//  Created by Vaughn on 11/20/19.
//  Copyright © 2019 Vaughn Anton. All rights reserved.
//

import SpriteKit
import UIKit

class BuildingNode: SKSpriteNode {

    var currentImage: UIImage!
    
    func setup() {
        name = "building"
        
        currentImage = drawBuilding(size: size)
        texture = SKTexture(image: currentImage)
        
        configurePhysics()
    }
    
    func configurePhysics() {
        physicsBody = SKPhysicsBody(texture: texture!, size: size)
        physicsBody?.isDynamic = false
        physicsBody?.categoryBitMask = CollisionTypes.building.rawValue
        physicsBody?.contactTestBitMask = CollisionTypes.banana.rawValue
    }
    
    func hit(at point: CGPoint) {
        // abs will always return a positive number
        let convertedPoint = CGPoint(x: point.x + size.width / 2, y: abs(point.y - (size.height / 2)))
        
        let renderer = UIGraphicsImageRenderer(size: size)
        let img = renderer.image { ctx in
            currentImage.draw(at: .zero)
            
            ctx.cgContext.addEllipse(in: CGRect(x: convertedPoint.x - 32, y: convertedPoint.y - 32, width: 64, height: 64))
            ctx.cgContext.setBlendMode(.clear)
            ctx.cgContext.drawPath(using: .fill)
        }
        
        texture = SKTexture(image: img)
        currentImage = img

        configurePhysics()
    }
    
    func drawBuilding(size: CGSize) -> UIImage {
        // create new core graphics context the size of building
        let renderer = UIGraphicsImageRenderer(size: size)
        let img = renderer.image { ctx in
            // fill with rectangle in one of three colors
            let rectangle = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            let color: UIColor
            
            switch Int.random(in: 0...2) {
            case 0:
                color = UIColor(hue: 0.502, saturation: 0.98, brightness: 0.67, alpha: 1)
            case 1:
                color = UIColor(hue: 0.999, saturation: 0.99, brightness: 0.67, alpha: 1)
            default:
                color = UIColor(hue: 0, saturation: 0, brightness: 0.67, alpha: 1)
            }
            
            color.setFill()
            ctx.cgContext.addRect(rectangle)
            ctx.cgContext.drawPath(using: .fill)
            
            // draw windows with two colors
            let lightOnColor = UIColor(hue: 0.190, saturation: 0.67, brightness: 0.99, alpha: 1)
            let lightOffColor = UIColor(hue: 0, saturation: 0, brightness: 0.34, alpha: 1)
            
            for row in stride(from: 10, to: Int(size.height - 10), by: 40) {
                for col in stride(from: 10, to: Int(size.width - 10), by: 40) {
                if Bool.random() {
                    lightOnColor.setFill()
                } else {
                    lightOffColor.setFill()
                }
                ctx.cgContext.fill(CGRect(x: col, y: row, width: 15, height: 20))
                }
            }
        // pull out the result as a UIImage and return for use elsewhere
        }
    return img
    }
}
