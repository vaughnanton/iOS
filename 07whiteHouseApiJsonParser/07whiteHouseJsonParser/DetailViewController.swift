//
//  DetailViewController.swift
//  07whiteHouseJsonParser
//
//  Created by Vaughn on 6/19/19.
//  Copyright © 2019 Vaughn Anton. All rights reserved.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    var webView: WKWebView!
    // will contain our petition instance
    var detailItem: Petition?
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // unwrap detailItem into itself if it has a value
        // it's common to unwrap variables using the same name, rather than creating a variation
        guard let detailItem = detailItem else { return }
        
        let html = """
        <html>
        <head>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <style> body { font-size: 150%; } </style>
        </head>
        <body>
        \(detailItem.body)
        </body>
        </html>
        """
        
        webView.loadHTMLString(html, baseURL: nil)
    }
    
}
