//
//  ViewController.swift
//  StormViewer
//
//  Created by Vaughn on 5/21/19.
//  Copyright © 2019 Vaughn Anton. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var pictures = [String]()
    
    override func viewDidLoad() {
        
        // enables large titles across the app
        navigationController?.navigationBar.prefersLargeTitles = true
        // make the initial title big ^ but not the rest, below
        navigationItem.largeTitleDisplayMode = .never
        
        super.viewDidLoad()
        title = "Storm Viewer"
        
        // declare constant and assign to data type that allows us to work with a filesystem
        let fm = FileManager.default
        
        // declare constant and set to the resource path of our app's bundle
        let path = Bundle.main.resourcePath!
        
        // declare constant and set to the contents of directory at a path - the path specified on on line 21)
        let items = try! fm.contentsOfDirectory(atPath: path)
        
        for item in items {
            if item.hasPrefix("nssl") {
                pictures.append(item)
            }
        }
        
        print(pictures)
    }
    
    // overrride means the method has been defined already and we want to override existing behavior
    // func starts function/mehtod
    // the method's name is tableView
    // tableView is the name to reference the tableView inside the method UITableView is the datatype
    // numberOfRowsInSection section: Int describes what the method does, shows rows that can be sectioned off and will contain a whole number
    // _ is basically a parameter without a name
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    // what each row should look like method
    // _ means it will pass in a table view as teh first parameter, doesn't need to have name sent externally because same as method name
    // method is called cellForRowAt and will be called when you need to provide a row
    // the row to show is specified in the parameter: indexPath which is of type IndexPath
    // -> UITableViewCell means this method must return a table view cell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // allows scrolling replacement of contents to save CPU/RAM
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        // cell has a property called textLabel, but it's optional
        cell.textLabel?.text = pictures[indexPath.row]
        // since this method expects a table view cell to be returned, we ned to send back the one we created
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // try loading the "detail" view controller and typecasting it to be DetailViewController
        // storyboard property might be nil (?) so will stop executing if so
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            // success! set its selectedImage property
            vc.selectedImage = pictures[indexPath.row]
            
            // now push it onto the navigation controller
            navigationController?.pushViewController(vc, animated: true)
        }
    }

}

