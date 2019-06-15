//
//  ViewController.swift
//  04webBrowser
//
//  Created by Vaughn on 6/4/19.
//  Copyright © 2019 Vaughn Anton. All rights reserved.
//

import UIKit
// import Webkit framework
import WebKit

// normally it's class A: B (class A builds on the funcitonality of Class B)
// class A: B, C (class A inherits from B, and promises it implements C's protocol)
class ViewController: UIViewController, WKNavigationDelegate {
    // store the web view as a property so we can reference it later
    var webView: WKWebView!
    var progressView: UIProgressView!
    // array containing websites we want user to visit
    var websites = ["apple.com", "hackingwithswift.com"]
    
    override func loadView() {
        // create instance of WKWebView and assign to webView
        webView = WKWebView()
        // a delegate is one thing acting in place of another
        // tell WKWebView that we want to be informed when something interesting happens
        // "when any web page navigation happens, please tell me - the current view controller"
        // any methods we implement will be given control over WKWebView's behavior
        webView.navigationDelegate = self
        // make our view the webView
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
        // create UIProgressView instance giving it default style
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        // create new UIBarButtonItem using customView param aka wrap our UIProgressView in UIBarButtonItem so it can go into our toolbar
        let progressButton = UIBarButtonItem(customView: progressView)
        
        // can't be tapped so doesn't need target or action
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        
        // create array and set it to viewController's toolBarItems array - progress bar first, space in center, and then refresh button on the right
        toolbarItems = [progressButton, spacer, refresh]
        // set navigation controller's property to false so the tool bar will be shown
        navigationController?.isToolbarHidden = false
        
        let url = URL(string: "https://" + websites[0])!
        // create new URL request object from the above URL and gives it to webView to load
        webView.load(URLRequest(url: url))
        // enables property that allows users to swipe left/right to go forward/back
        webView.allowsBackForwardNavigationGestures = true
        
        // Key Value Observing KVO basically says "tell me when property X of object Y gets changed by anyone at any time)
        // addObserver takes four parameters, who the ovesrever is, what we want to observe, which value we want, and a context value
        // if you provide context value, that value gets sent back to you when you get the notification the value has changed - allowing to check context to make sure it was your observer that was called
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
    }

    // calling openTapped from objectiveC so must be marked with @objc
    @objc func openTapped() {
        let ac = UIAlertController(title: "Open page...", message: nil, preferredStyle: .actionSheet)
        for website in websites {
            ac.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
        }
        // no handler which means apple will dismiss the alert controller
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        // used only on iPad, tells iOS where it should make the action sheet be anchored
        ac.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }
    
    func openPage(action: UIAlertAction) {
        let url = URL(string: "https://" + action.title!)!
        webView.load(URLRequest(url: url))
    }
    
    // update view controller's title property to the title of the web view
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    
    // method for KVO observer
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        // if the estimatedProgress value of the web view has changed, set the progress property of our progress view to new value
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    // wheether we want navigation to happen or not everytime something happens
    // @escaping means we might have the closure used later
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        // set constant url equal to URL of the navigation
        let url = navigationAction.request.url
        
        // if there is a host(website domain) url, pull it out
        if let host = url?.host {
            // loop through all sites in our safe list placing site in website variable
            for website in websites {
                // see if website exists somewhere in host name
                if host.contains(website) {
                    // if website was found, call decisionHandler and allow loading
                    decisionHandler(.allow)
                    // exit the method now
                    return
                }
            }
        }
        // if website was not found, call decisionHandler and cancel loading
        decisionHandler(.cancel)
    }

}

