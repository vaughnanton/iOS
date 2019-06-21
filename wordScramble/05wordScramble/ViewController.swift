//
//  ViewController.swift
//  05wordScramble
//
//  Created by Vaughn on 6/10/19.
//  Copyright © 2019 Vaughn Anton. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    // hold words of input file
    var allWords = [String]()
    // hold words the player has used
    var usedWords = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promptForAnswer))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(startGame))

        // Bundle takes the name/file extension - returns a String? ie you get either a path or nil if it doesn't exist
        // this is why we need to use if let to check and unwrap the optional
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            // try? call this code and if it throws an error just send back nil instead
            if let startWords = try? String(contentsOf: startWordsURL) {
            // split single string into array of strings based on \n
            allWords = startWords.components(separatedBy: "\n")
            }
        }
        
        // returns true if allWords is empty aka allWords.count == 0
        if allWords.isEmpty {
            allWords = ["silkworm"]
        }
        
        startGame()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        cell.textLabel?.text = usedWords[indexPath.row]
        return cell
    }
    
    // since being called from UIBarButtonItem, need to mark it with @objc
    @objc func promptForAnswer() {
        // create a new UIAlertController
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        // adds editable text input to UIAlertController
        ac.addTextField()
        
        // closure, chunk of code that can be treated like a variable, can send it somewhere where it gets stored and executed later
        // read what was inserted in UIAlertController text field
        // give UIAlertAction some code to execute when tapped and it wants to know that code accepts a parameter of type UIAlertAction
        // everything before 'in' describes the closure, so action in means it accepts a parameter action
        // swift captures any constants and variables used in a closure, and sincce you don't want strong referencing (endless cycle) you can
        // declare some variables that aren't held on to so tightly
        // [weak self, weak ac] declares the current view controller and ac (our UIAlertController) to be captures as weak references inside the closure
        // aka the closure can use them, but won't create a strong reference cyle bc the closure doesn't own either of them
        let submitAction = UIAlertAction(title: "Submit", style: .default) { [weak self, weak ac] action in
            // unwraps the array of text fields, optionsal because might not be any
            guard let answer = ac?.textFields?[0].text else {return}
            // submit is external to the closure, so it implicitly requires that self be captured by the closure so must be prefixed with 'self?'
            // pulls the text from the text field and passes it to submit() method
            /*self?.*/submit(answer)
        }
        // summary of above
        // we use trailing closure syntax to provide some code to run when the alert action is selected
        // that code will use self and ac so we declare them as being weak so Swift won't create a strong reference cycle
        // the closure expects to receive a UIAlertAction as its parameter, so we wirte that inside the opening brace
        // everything after 'in' is the actual code of the closure
        // inside teh clsoure we need to reference methods on view controller using self so we're clearly saying there is possiblity of a strong reference cycle
        
        func submit(_ answer: String) {
            let lowerAnswer = answer.lowercased()
            
            let errorTitle: String
            let errorMessage: String
            
            if isPossible(word: lowerAnswer) {
                if isOriginal(word: lowerAnswer) {
                    if isReal(word: lowerAnswer) {
                        // once the word passes the if statements, we insert into usedWords at index 0
                        usedWords.insert(answer, at: 0)
                        
                        // insert a new row into table view
                        let indexPath = IndexPath(row: 0, section: 0)
                        // insertRows lets us tell table view that new row has been placed at specific place in array so it can animate the new cell appearing
                        // with parameter lets you specifiy how the row hsould be added in
                        tableView.insertRows(at: [indexPath], with: .automatic)
                        
                        return
                    } else {
                        errorTitle = "Word not recognised"
                        errorMessage = "Must contain more than 3 letters and can't be the original word!"
                    }
                } else {
                    errorTitle = "Word used already"
                    errorMessage = "Be more original!"
                }
            } else {
                guard let title = title?.lowercased() else { return }
                errorTitle = "Word not possible"
                errorMessage = "You can't spell that word from \(title)"
            }
            
            let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
        
        func isPossible(word: String) -> Bool {
            guard var tempWord = title?.lowercased() else { return false }
            
            for letter in word {
                if let position = tempWord.firstIndex(of: letter) {
                    // if letter is found in string remove it
                    tempWord.remove(at: position)
                } else {
                    return false
                }
            }
            // return true if every letter in the user's word is found in the start word no more than once
            return true
        }
        
        func isOriginal(word: String) -> Bool {
            return !usedWords.contains(word)
        }
        
        func isReal(word: String) -> Bool {
            if word.count > 3 && word != title {
                // ios class to spot spelling errors, creating an instance of it and putting into checker constant for later use
                let checker = UITextChecker()
                // NSRange is used to store a string range, which holds length and start position
                let range = NSRange(location: 0, length: word.utf16.count)
                // call method of UITextChecker, first param is our string, second is the range to scan
                let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
                // NSNotFound means there was no mispelling, so this line tells us word is valid or not
                // == returns true or false depending on whether mispelledRange.location is or is not equal to NSNotFound
                return misspelledRange.location == NSNotFound
            }
            return false
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    @objc func startGame() {
        // set view controller's title to random word in array
        title = allWords.randomElement()
        // removes all values from the usedWords array, will be used to stroe player's answers
        usedWords.removeAll(keepingCapacity: true)
        // reloadData forces to call numberofRowsInSection as well as calling cellForRowAt repeatedly
        tableView.reloadData()
    }

}

