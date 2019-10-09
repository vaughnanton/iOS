//
//  ActionViewController.swift
//  Extension
//
//  Created by Vaughn on 9/3/19.
//  Copyright © 2019 Vaughn Anton. All rights reserved.
//

import UIKit
import MobileCoreServices

class ActionViewController: UIViewController {

    var pageTitle = ""
    var pageURL = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create a UIBarButtonItem and make it call done()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
    
        // when extension is created, extensionContext lets us control how it interacts with parent app
        // inputItems will be array of data the parent app is sending to our extension to use
        // since it might not exist we typecast with if let and as?
        if let inputItem = extensionContext?.inputItems.first as? NSExtensionItem {
            // inputItem contains array of attachments, which is given wrapped up as NSItemProvider
            if let itemProvider = inputItem.attachments?.first {
                // use loadItem(forTypeofIdentifier: ) to provid us with the item, uses a closure so this executes asynchronously which means the method will carry on executing while the item provider is busy loading and sending data
                // inside the closure  we use the usual [weak self] to avoid strong reference cycles, and we also need two parameters, the dictionary that was given by the provider, and any error that occured
                itemProvider.loadItem(forTypeIdentifier: kUTTypePropertyList as String) { [weak self] (dict, error) in
                    // dictionary is sent from Action.js
                    // NSDictionary works like a Swift dictionary except you don't need to declare or know what type of data it holds
                    guard let itemDictionary = dict as? NSDictionary else { return }
                    guard let javaScriptValues = itemDictionary[NSExtensionJavaScriptPreprocessingResultsKey] as? NSDictionary else { return }
                    
                    // sets two properties from javaScriptValues dictionary typecasting them as strings
                    self?.pageTitle = javaScriptValues["title"] as? String ?? ""
                    self?.pageURL = javaScriptValues["URL"] as? String ?? ""
                    
                    DispatchQueue.main.async {
                        // set the view controllers title property on the main queue
                        // necessary because the closure being executed from loadItem(forTypeIdentifier:) could be called on any thread, and we don't want to change UI unless we're on the main thread
                        self?.title = self?.pageTitle
                    }
                }
            }
        }
    }

    @IBOutlet weak var script: UITextView!
    
    @IBAction func done() {
        // Return any edited content to the host app.
        // in safari extension, the data we return here will be passed into the finalize() function in Action.js, so we modify done() to pass back the text the user entered into our text view
        // create new NSExtensionItem that will host our items
        let item = NSExtensionItem()
        // create dictionary containing the value of our script
        let arguement: NSDictionary = ["customJavaScript": script.text]
        // put above dictionary into another dictionary with key NSExtensionJavaScriptFinalizeArguementKey
        let webDictionary: NSDictionary = [NSExtensionJavaScriptFinalizeArgumentKey: arguement]
        // wrap the big dictionary inside NSItemProvider object with the type identifier kUTTypePropertyList
        let customJavaScript = NSItemProvider(item: webDictionary, typeIdentifier: kUTTypePropertyList as String)
        // place above into NSExtensionItem as its attachments
        item.attachments = [customJavaScript]
        
        // call completeRequest returning our NSExtensionItem
        extensionContext?.completeRequest(returningItems: [item])
    }

}
