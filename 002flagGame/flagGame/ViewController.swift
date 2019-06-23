//
//  ViewController.swift
//  flagGame
//
//  Created by Vaughn on 5/28/19.
//  Copyright © 2019 Vaughn Anton. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    // IBOutlet connects code to storyboard layouts
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    
    // will hold array of strings
    var countries = [String]()
    // track whether flag 0,1 or 2 is correct
    var correctAnswer = 0
    var score = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        // add a small border around the flags, default is black
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        // change border color
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        askQuestion(action: nil)
    }

    // .setImage assigns UIImage to the button
    // for: .normal takes a second parameter that describes which state
    // of the button should be changed, .normal means "the standard state of the button"
    func askQuestion(action: UIAlertAction!) {
        // shuffle the countries array
        countries.shuffle()
        
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        correctAnswer = Int.random(in: 0...2)
        
        title = countries[correctAnswer].uppercased()
    }
    
    // IBAction makes storyboard layouts trigger code
    @IBAction func buttonTapped(_ sender: UIButton) {
    // we set the button's Tag attribute to 0,1,2 so we'll know which is tapped
        var title: String
        
        if sender.tag == correctAnswer {
            title = "Correct"
            score += 1
        } else {
            title = "Wrong"
            score -= 1
        }
        
        let ac = UIAlertController(title: title, message: "Your score is \(score).", preferredStyle: .alert)
        // handler is looking for a closure (code block in variable), so we pass in askQuestion
        ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
        // a view controller to present and true to animate
        present(ac, animated: true)
    }
    
}

