//
//  ViewController.swift
//  015animation
//
//  Created by Vaughn on 8/23/19.
//  Copyright © 2019 Vaughn Anton. All rights reserved.
//

// by default UIKit has ease in/ease out curve
import UIKit

class ViewController: UIViewController {

    var imageView: UIImageView!
    var currentAnimation = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView = UIImageView(image: UIImage(named: "penguin"))
        imageView.center = CGPoint(x: 200, y: 384)
        view.addSubview(imageView)
    }


    @IBAction func tapped(_ sender: UIButton) {
        // hide the button
        sender.isHidden = true
        
        // change the default easein/easeout behavior from...
        // UIView.animate(withDuration: 1, delay: 0, options: [], animations: {
        // to...
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: [], animations: {
            switch self.currentAnimation {
                case 0:
                    self.imageView.transform = CGAffineTransform(scaleX: 2, y: 2)
                case 1:
                    // clear out any pre-defined transforms
                    self.imageView.transform = .identity
                case 2:
                    self.imageView.transform = CGAffineTransform(translationX: -200, y: -200)
                case 3:
                    self.imageView.transform = .identity
                case 4:
                    // using radians
                    self.imageView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
                case 5:
                    self.imageView.transform = .identity
                case 6:
                    // transparency, 0 is invisible
                    self.imageView.alpha = 0.1
                    self.imageView.backgroundColor = UIColor.green
                case 7:
                    self.imageView.alpha = 1
                    self.imageView.backgroundColor = UIColor.clear
                default:
                    break
            }
        }) { finished in
            // show the button if there was an animation
            sender.isHidden = false
        }
        
        // cycle through animations
        currentAnimation += 1
        
        // once we get to the seventh animation, reset to 0
        if currentAnimation > 7 {
            currentAnimation = 0
        }
    }
}

