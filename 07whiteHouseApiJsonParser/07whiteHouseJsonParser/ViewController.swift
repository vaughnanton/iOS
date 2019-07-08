//
//  ViewController.swift
//  07whiteHouseJsonParser
//
//  Created by Vaughn on 6/14/19.
//  Copyright © 2019 Vaughn Anton. All rights reserved.
//

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
        
        // use if let to make sure URL is valid
        if let url = URL(string: urlString) {
            // create new data object using contentsOf method, we use try? because it might throw an error if for example the internet is down
            if let data = try? Data(contentsOf: url) {
                parse(json: data)
            } else {
                showError()
            }
        } else {
            showError()
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
            tableView.reloadData()
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
        let ac = UIAlertController(title: "Loading Error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
}

