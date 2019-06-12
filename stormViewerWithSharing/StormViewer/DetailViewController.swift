//
//  DetailViewController.swift
//  StormViewer
//
//  Created by Vaughn on 5/24/19.
//  Copyright © 2019 Vaughn Anton. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    
    // property that will hold the name of image to load
    var selectedImage: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = selectedImage
        
        // on the left creating an instance of UIBarButtonItem, set it up with item, target (self means it belongs to the current view controller), and action (when tapped will call shareTapped)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))


        // select and unwrap the option in selectedImage, if nil the rest won't be executed, if has value it will be placed into imageToLead then passed to UIImage 
        if let imageToLoad = selectedImage {
            imageView.image = UIImage(named: imageToLoad)
        }
    }
    
    // super means "tell my parent data type that these methods were called" aka pass it to UIViewController which may do its own processing
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.hidesBarsOnTap = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.hidesBarsOnTap = false
    }
    
    // objc will get called by underlyign obj c oeprating system (UIBarButtonItem), when calling a method using #selector you'll always need @objc too
    // UIActivityViewController is the iOS method of sharing content with other apps and services, and we tell it where it should be anchored and appear from
    @objc func shareTapped() {
        guard let image = imageView.image?.jpegData(compressionQuality: 0.8) else {
            print("No image found")
            return
        }
        
        let vc = UIActivityViewController(activityItems: [image], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(vc, animated: true)
    }
    
    // the home and bars will disappear after a couple seconds and reappear when the user touches the screen
    // ?? means if the navigation controller doesn't exist, sned back false rather than trying to read hideBarsOnTap property
    override var prefersHomeIndicatorAutoHidden: Bool {
        return navigationController?.hidesBarsOnTap ?? false
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
