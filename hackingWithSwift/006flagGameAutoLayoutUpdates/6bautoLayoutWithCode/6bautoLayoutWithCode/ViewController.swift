//
//  ViewController.swift
//  6bautoLayoutWithCode
//
//  Created by Vaughn on 6/12/19.
//  Copyright © 2019 Vaughn Anton. All rights reserved.
//
// THIS PROJECT USES VISUAL FORMAT LANGUAGE TO CREATE VIEW CONSTRAINTS
import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let label1 = UILabel()
        // disable autolayout constraints because we're building by hand
        label1.translatesAutoresizingMaskIntoConstraints = false
        label1.backgroundColor = UIColor.red
        label1.text = "THESE"
        // sized to fit content
        label1.sizeToFit()

        let label2 = UILabel()
        label2.translatesAutoresizingMaskIntoConstraints = false
        label2.backgroundColor = UIColor.cyan
        label2.text = "ARE"
        label2.sizeToFit()

        let label3 = UILabel()
        label3.translatesAutoresizingMaskIntoConstraints = false
        label3.backgroundColor = UIColor.yellow
        label3.text = "SOME"
        label3.sizeToFit()
        
        let label4 = UILabel()
        label4.translatesAutoresizingMaskIntoConstraints = false
        label4.backgroundColor = UIColor.green
        label4.text = "AWESOME"
        label4.sizeToFit()
        
        let label5 = UILabel()
        label5.translatesAutoresizingMaskIntoConstraints = false
        label5.backgroundColor = UIColor.orange
        label5.text = "LABELS"
        label5.sizeToFit()
        
        view.addSubview(label1)
        view.addSubview(label2)
        view.addSubview(label3)
        view.addSubview(label4)
        view.addSubview(label5)
        
        let viewsDictionary = ["label1": label1, "label2": label2, "label3": label3, "label4": label4, "label5": label5]
        
        
         // THIS IS HOW WE WOULD HAND CODE
         
        /* let metrics = ["labelHeight": 88]
        
       
        for label in viewsDictionary.keys {
            // H means it's horizontal, | pipe means to edge of view
            view.addConstraints( NSLayoutConstraint.constraints(withVisualFormat: "H:|[\(label)]|", options: [], metrics: nil, views: viewsDictionary))
            // fix the vertical positioning, - is 10 points by default
            // each label is 88 points high and the last one must be at least 10 points form the view controller's bottom
            // @999 means it's high priority but not required so if autolayout needs to change to fit view, then it can - starts at 1000 and goes down  in prioriyt
            view.addConstraints( NSLayoutConstraint.constraints(withVisualFormat: "V:|[label1(labelHeight@999)]-[label2(label1)]-[label3(label1)]-[label4(label1)]-[label5(label1)]->=10-|", options: [], metrics: metrics, views: viewsDictionary))


        } */
        
        // THIS IS HOW TO CODE IT VIA ANCHORS

        // optional because could be the first label
        var previous: UILabel?
        
        for label in [label1, label2, label3, label4, label5] {
            label.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
            label.heightAnchor.constraint(equalToConstant: 88).isActive = true
            
            // previous to this code block we were saying "if we have a previous label, make the top anchor of this label equal to the bottom anchor of the previous label plus 10" but when we add the else block it pushes label away from the top of the safe area so it doesn't sit in the iphone x notch
            if let previous = previous {
                // we have a previous label – create a height constraint
                label.topAnchor.constraint(equalTo: previous.bottomAnchor, constant: 10).isActive = true
            } else {
                // this is the first label
                label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
            }
            
            // set the previous label to be the current one, for the next loop iteration
            previous = label
        }

    }
    
}
