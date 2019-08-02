//
//  ViewController.swift
//  07whiteHouseJsonParser
//
//  Created by Vaughn on 6/14/19.
//  Copyright © 2019 Vaughn Anton. All rights reserved.
//

// this is a copy of project 7, by downloading data in viewDidLoad() the app would lock up until all the data had been transferred - now to fix with Grand Central Dispatch (GCD) which allows to fetch the data without locking up the user interface
// previously we used Data's contentsOf to download the data, this is a blocking call - it blocks execution of further code until it has connected and fully downloaded the data ... broadly speaking, if accessing any remote source - it should be done on a background thread - GCD automatically creates threads for you and executes code in the most efficient way it can

import UIKit

class ViewController: UITableViewController {

    // make array from our Petition object
    var petitions = [Petition]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // points to where the JSON data is located
        let urlString: String
        
        // set our second ViewController tag to 1 in appDelagete so we can use if here to call the popular petitiions
        if navigationController?.tabBarItem.tag == 0 {
            // all petition list
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            // most popular petitions
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }
        
        // we use weak self to make sure there aren't any strong reference cycles
        // qos is set to userInitiated (others 3 options are .userInteractive, .utility, .background
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            // use if let to make sure URL is valid
            if let url = URL(string: urlString) {
                // create new data object using contentsOf method, we use try? because it migth throw an error ex. no internet connection
                if let data = try? Data(contentsOf: url) {
                    // because code is in a closure, method calls should be prefixed with self?
                    self?.parse(json: data)
                    return
                }
            }
            // this causes a UIAlertController to work on the background thread so we have to move it back to the main thread in showError()
            self?.showError()
        }
        
    }
    
    func parse(json: Data) {
        // create an instance of JSONDecoder
        let decoder = JSONDecoder()
        
        // use decode method on decoder to convert json data into Petitions object, use try? to see if it worked
        // Petitions.self is referring to the type itself and not the instance, so that the decoder knows what to convert the JSON to
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            // if the json was converted successfully, assign the results array to our petitions property and then...
            petitions = jsonPetitions.results
            // ...reload the table view
            DispatchQueue.main.async { [weak self] in
                self?.tableView.reloadData()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = petitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }
    
    // in this project detailViewController isn't in the storyboard, just a free floating class so we can load didSelectRowAt directly rather than loading it from a storyboard
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // add alert/error message if json fails to load
    func showError() {
        // push this code back to the main thread
        DispatchQueue.main.async { [weak self] in
            let ac = UIAlertController(title: "Loading Error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            self?.present(ac, animated: true)
        }
    }
    
}

/*
 - we could also refactor the entire program by using performSelector() which we can run inBackground or onMainThread
 - don't have to worry about how it's organized as GCD will take care of it all
 - could refactor the above GCD code as...
 
 override func viewDidLoad() {
 super.viewDidLoad()
 
 performSelector(inBackground: #selector(fetchJSON), with: nil)
 }
 
 @objc func fetchJSON() {
 let urlString: String
 
 if navigationController?.tabBarItem.tag == 0 {
 urlString = "https://api.whitehouse.gov/v1/petitions.json?limit=100"
 } else {
 urlString = "https://api.whitehouse.gov/v1/petitions.json?signatureCountFloor=10000&limit=100"
 }
 
 if let url = URL(string: urlString) {
 if let data = try? Data(contentsOf: url) {
 parse(json: data)
 return
 }
 }
 
 performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
 }
 
 func parse(json: Data) {
 let decoder = JSONDecoder()
 
 if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
 petitions = jsonPetitions.results
 tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
 }
 }
 
 @objc func showError() {
 let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
 ac.addAction(UIAlertAction(title: "OK", style: .default))
 present(ac, animated: true)
 }

 if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
 petitions = jsonPetitions.results
 tableView.performSelector(onMainThread: #selector(UITableView.reloadData), with: nil, waitUntilDone: false)
 } else {
 performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
 }
 
 */
