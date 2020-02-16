//
//  ViewController.swift
//  Concentration
//
//  Created by Vahag Antonyan on 1/3/19.
//  Copyright © 2019 Vahagn Antonyan. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    lazy var game = Concentration(numberOfPairsOfCards: (cardButtons.count + 1) / 2)
    
    @IBOutlet weak var flipCountLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet var cardButtons: [UIButton]!
    
    @IBAction func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.firstIndex(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
            flipCountLabel.text = "Flips: \(game.flipCount)"
            scoreLabel.text = "Score: \(game.score)"
        } else {
            print("chosen card was not in cardButtons")
        }
    }
    
    func updateViewFromModel() {
        
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: UIControl.State.normal)
                button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            } else {
                button.setTitle("", for: UIControl.State.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 0.921725768, green: 0.9921155877, blue: 1, alpha: 0) : #colorLiteral(red: 1, green: 0.6470884837, blue: 0.3386492052, alpha: 1)
            }
        }
    }
        
    var themes = [["😀","🙄","🥵","🤬","🥶","😨","🤢","😈"],["🐶","🦁","🐵","🐷","🦊","🐻","🐨","🐭"],["⚽️","🏀","🏈","⚾️","🥎","🏐","🎾","🎱"]]
    lazy var emojiChoices = themes.randomElement()!
    
    var emoji = [Int:String]()

    func emoji(for card: Card) -> String {
        if emoji[card.identifier] == nil, emojiChoices.count > 0 {
                let randomIndex = Int(arc4random_uniform(UInt32(emojiChoices.count)))
                emoji[card.identifier] = emojiChoices.remove(at: randomIndex)
        }
        
        /* can write the below nested if statements as above
         if emoji[card.identifier] == nil {
            if emojiChoices.count > 0 {
                let randomIndex = Int(arc4random_uniform(UInt32(emojiChoices.count)))
                emoji[card.identifier] = emojiChoices.remove(at: randomIndex)
            }
         }
        */
        
        //return first but if nil return "?"
        return emoji[card.identifier] ?? "?"
    }
    
    @IBAction func resetGame(_ sender: UIButton) {
        game.flipCount = 0
        game.score = 0
        flipCountLabel.text = "Flips: \(game.flipCount)"
        scoreLabel.text = "Score: \(game.score)"
        emojiChoices += emoji.values
        emoji = [Int:String]()
        for index in cardButtons.indices {
            let button = cardButtons[index]
            button.setTitle("", for: UIControl.State.normal)
            button.backgroundColor = #colorLiteral(red: 1, green: 0.6470884837, blue: 0.3386492052, alpha: 1)
            game.cards[index].isFaceUp = false
            game.cards[index].isMatched = false
            game.indexOfOneAndOnlyFaceUpCard = nil
        }
    }
}

