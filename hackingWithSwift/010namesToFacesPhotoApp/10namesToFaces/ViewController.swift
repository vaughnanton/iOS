//
//  ViewController.swift
//  10namesToFaces
//
//  Created by Vaughn on 7/10/19.
//  Copyright © 2019 Vaughn Anton. All rights reserved.
//

import UIKit

// this says we promise our class supports all the functionality required by the two delegates
class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // array of Person objects
    var people = [Person]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
        
    }

    // must return an int, tells collection view how many items you want to show in its grid
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return people.count
    }
    
    // delegate method didSelectItemAt when user taps cell
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let person = people[indexPath.item]
        
        // create UIAlertController
        let ac = UIAlertController(title: "Rename Person", message: nil, preferredStyle: .alert)
        ac.addTextField()
        // cancel the alert
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        // save the rename
        ac.addAction(UIAlertAction(title: "OK", style: .default) { [weak self, weak ac] _ in
            guard let newName = ac?.textFields?[0].text else { return }
            person.name = newName
            // reload collectionView to reflect the change
            self?.collectionView.reloadData()
        })
        
        present(ac, animated: true)
    }
    
    // must return object type of UICollectionViewCell
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // creates a collection view cell using the reuse identified we specified, "Person"
        // as soon as a cell scrolls out of view, it can be reused so we don't have to keep creating new ones
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Person", for: indexPath) as? PersonCell else {
            // we failed to get a PersonCell
            fatalError("Unable to dequeue PersonCell.")
        }
        
        // pull out person from the people array at the correct position
        let person = people[indexPath.item]
        
        // set the label to the person's name
        cell.name.text = person.name
        
        // create a UIImage of the person's image filename, adding it to value from getDocumentsDirectory for the correct path
        let path = getDocumentsDirectory().appendingPathComponent(person.image)
        cell.imageView.image = UIImage(contentsOfFile: path.path)
        
        // style it up
        cell.imageView.layer.borderColor = UIColor(white:0, alpha: 0.3).cgColor
        cell.imageView.layer.borderWidth = 2
        cell.imageView.layer.cornerRadius = 3
        cell.layer.cornerRadius = 7
        
        // if we're still here it means we got a PersonCell, so we can return it
        return cell
    }
    
    // because we're using #selector, we need to call @objc
    @objc func addNewPerson() {
        // allows user to pick an image from their camera roll
        let picker = UIImagePickerController()
        // allows user to crop the image the choose
        picker.allowsEditing = true
        // when setting self as delegate, need to conform to both UIImagePickerControllerDelegate and UINavigationControllerDelegate protocol
        picker.delegate = self
        present(picker, animated: true)
    }
    
    // this function saves the image to disk
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // guard pulls out and typecasts the image from image picker, because if it fails we want to exit the method immediately
        guard let image = info[.editedImage] as? UIImage else {return}
        // create UUID and use its uuidString property to give it a unique identifier
        // need this because we create a copy of the image for our app
        let imageName = UUID().uuidString
        // add a path to current path called imageName
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)
        
        // convert image with jpegData() to Data object so we can save it
        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            // once we have the data, unwrap it safely then write it to the file name of imagePath
            try? jpegData.write(to: imagePath)
        }
        
        // create new person object
        let person = Person(name: "Unknown", image: imageName)
        // append to array
        people.append(person)
        // reload collectionView
        collectionView.reloadData()
        
        dismiss(animated: true)
    }

    // this function gets the apps document directory, which contains private data/info for the app; it's also auto synchronized with iCloud
    func getDocumentsDirectory() -> URL {
        //  asks for the documents directory
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        // makes the path relative to the user's home directory
        return paths[0]
    }
    
}

