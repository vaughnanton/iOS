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
