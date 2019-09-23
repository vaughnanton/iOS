//
//  ViewController.swift
//  018debugging
//
//  Created by Vaughn on 9/3/19.
//  Copyright © 2019 Vaughn Anton. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // DEBUGGING WITH PRINT (prints to cnosole)
        // with print statements
        // print("I'm inside the viewDidLoad() method")
        // you can pass in values to print
        // print(1, 2, 3, 4, 5)
        // can split up using separator param ex. 1-2-3-4-5
        // print(1, 2, 3, 4, 5, separator: "-")
        // another optional param is terminator
        // "" will prevent the default linebreak from happening
        // print("Some message", terminator: "")
        
        // DEBUGGING WITH ASSERT (will force app to crash if a specific condition isn't true)
        // assert(1 == 1, "Maths failure!")
        // assert(1 == 2, "Maths failure!")
        // assert is never executed in a live app, they are disabled in release builds so you can do complex checks
        // assert(boolMethod() == true, "The slow method returned false, which is a bad thing!")
        
        // DEBUGGING WITH BREAKPOINTS
        for i in 1 ... 100 {
            // if we want to see program state when we call print function
            // when we click on the line number of the print function, a breakpoint is placed - execution will stop at this line and you can inspect app's internal state to see what values everything has
            // if you click blue arrow again, blue becomes lighter to mean the breakpoint is disabled
            // 1. can carry on execution "step over" by using Fn+F6
            // 2. if you want to go until next breakpoint you use Ctrl+Cmd+Y
            // 3. the lldb window is wehre you can type commands to query values and run mehtods
            // 4. can add condition to breakpoint by right clicking and editing (ex. i % 10 == 0, will pause execution every 10 times)
            print("Got number \(i)")
        }
        
        // VIEW DEBUGGING
        
        // Debug > View Debugging > Capture View Hierarchy
        // if you click and drag in the snapshot provided, you'll see a 3D representation of the view which menns you can look behind the layers to see what else is ther
        // good for when you can't see something you placed in the view, or placed something behind another
    }
    
    

}

