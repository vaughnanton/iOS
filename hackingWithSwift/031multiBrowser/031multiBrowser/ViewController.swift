//
//  ViewController.swift
//  031multiBrowser
//
//  Created by Vaughn on 12/5/19.
//  Copyright © 2019 Vaughn Anton. All rights reserved.
//
// playing with UIStackViews, this gives us a flexible, auto layout-powered view container that makes it easy to build complex UIs
// UIStackView fixes fitment issues by placing items side by side when there is lots of space or vertically when space is restricted, can even have views within views
// this app will have a full UIStackView with multiple web views inside it

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate, UITextFieldDelegate, UIGestureRecognizerDelegate {

    weak var activeWebView: WKWebView?
    @IBOutlet weak var addressBar: UITextField!
    @IBOutlet weak var stackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDefaultTitle()
        
        let add = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addWebView))
        let delete = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(deleteWebView))
        navigationItem.rightBarButtonItems = [delete,add]
    }
    
    func setDefaultTitle() {
        title = "Multibrowser"
    }
    
    func selectWebView(_ webView: WKWebView) {
        for view in stackView.arrangedSubviews {
            view.layer.borderWidth = 0
            updateUI(for: webView)
        }
        
        activeWebView = webView
        webView.layer.borderWidth = 3
    }
    
    @objc func webViewTapped(_ recognizer: UITapGestureRecognizer) {
        if let selectedWebView = recognizer.view as? WKWebView {
            selectWebView(selectedWebView)
        }
    }
    
    // detect when user enters new URL to address bar
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // if active web view
        if let webView = activeWebView, let address = addressBar.text {
            // and a URL...then neavigate
            if let url = URL(string: address) {
                webView.load(URLRequest(url: url))
            }
        }
        
        // hide the keyboard
        textField.resignFirstResponder()
        return true
    }
    
    
    // tell iOS we want gesture recognizers to trigger alongside the recognizers built into WKWebview
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    @objc func addWebView() {
        let webView = WKWebView()
        webView.navigationDelegate = self
        
        stackView.addArrangedSubview(webView)
        
        let url = URL(string: "https://www.hackingwithswift.com")!
        webView.load(URLRequest(url: url))
        
        webView.layer.borderColor = UIColor.blue.cgColor
        selectWebView(webView)
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(webViewTapped))
        recognizer.delegate = self
        webView.addGestureRecognizer(recognizer)
    }
    
    // delete and update the UI accordingly
    @objc func deleteWebView() {
        // safely unwrap our webview
        if let webView = activeWebView {
            if let index = stackView.arrangedSubviews.firstIndex(of: webView) {
                // we found the webview - remove it from the stack view and destroy from memory
                webView.removeFromSuperview()
                
                if stackView.arrangedSubviews.count == 0 {
                    // go back to default UI
                    setDefaultTitle()
                } else {
                    // convert index value into an integer
                    var currentIndex = Int(index)
                    
                    // if that was the last view in the stack, go back one
                    if currentIndex == stackView.arrangedSubviews.count {
                        currentIndex = stackView.arrangedSubviews.count - 1
                    }
                    
                    // find the web view at the new index and select it
                    if let newSelectedWebView = stackView.arrangedSubviews[currentIndex] as? WKWebView {
                        selectWebView(newSelectedWebView)
                    }
                }
            }
        }
    }
    
    // arrange web views horizontally when we have lots of space and vertically when we don't
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        if traitCollection.horizontalSizeClass == .compact {
            stackView.axis = .vertical
        } else {
            stackView.axis = .horizontal
        }
    }
    
    // read the property of the web view and set to view controller's title and place current URL in address bar
    func updateUI(for webView: WKWebView) {
        title = webView.title
        addressBar.text = webView.url?.absoluteString ?? ""
    }
    
    // whenever a web view changes page, update the UI - can do didfinish because view controller is the delegate of the web views
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if webView == activeWebView {
            updateUI(for: webView)
        }
    }
}

