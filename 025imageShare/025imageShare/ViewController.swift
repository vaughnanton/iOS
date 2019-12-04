//
//  ViewController.swift
//  025imageShare
//
//  Created by Vaughn on 10/2/19.
//  Copyright © 2019 Vaughn Anton. All rights reserved.
//
// In this project we will show photos of user choosing in collection view. When the photo is added it's going to automatically send it to any other devices that user is currently connected to, and any photos the other end selects will appear for user.

// Sending Data with Multipeer Connectivity
// we use pngData() to convert a UIimage object into a Data so it can be saved to disk
// then MCSession objects have a sendData() method that will ensure data gets transmitted reliably to peers
// once the data arrives at each peer, session(_:didReceive:fromPeer:) will get called with the data, at which point we can create a UIImage from it and add it to images array


import UIKit
import MultipeerConnectivity

class ViewController: UICollectionViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, MCSessionDelegate, MCBrowserViewControllerDelegate {

    // identifies each user uniquely in a session
    var peerID = MCPeerID(displayName: UIDevice.current.name)
    // is the manager class that handles alll multipeer connectivity
    var mcSession: MCSession?
    // used when creating a session, telling others that we exist and handling invitations
    var mcAdvertiserAssistant: MCAdvertiserAssistant?
    
    var images = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Image Share"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .camera, target: self, action: #selector(importPicture))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showConnectionPrompt))
        
        mcSession = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        mcSession?.delegate = self
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageView", for: indexPath)
        
        if let imageView = cell.viewWithTag(1000) as? UIImageView {
            imageView.image = images[indexPath.item]
        }
        
        return cell
    }
    
    @objc func importPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        
        dismiss(animated: true)
        
        images.insert(image, at: 0)
        collectionView.reloadData()
        
        // check if we have an active session we can use
        guard let mcSession = mcSession else { return }
        // check if there are any peers to send to
        if mcSession.connectedPeers.count > 0 {
            // convert the new image to a data object
            if let imageData = image.pngData() {
                // do and catch because its possible this code can throw errors
                // when an error is thrown in the do block, swift jumps to the catch block
                do {
                    // send it to all peers, ensuring delivery
                    try mcSession.send(imageData, toPeers: mcSession.connectedPeers, with: .reliable)
                } catch {
                    // show error message if there is a problem
                    let ac = UIAlertController(title: "Send error", message: error.localizedDescription, preferredStyle: .alert)
                    ac.addAction(UIAlertAction(title: "OK", style: .default))
                    present(ac, animated: true)
                }
            }
        }
    }
    
    @objc func showConnectionPrompt() {
        let ac = UIAlertController(title: "Connect to others", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Host a session", style: .default, handler: startHosting))
        ac.addAction(UIAlertAction(title: "Join a session", style: .default, handler: joinSession))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
            present(ac, animated: true)
    }
    
    // the serviceType is a unique identifier for our service
    // MCAdvertiserAssistant and MCBrowserViewController make sure users only see other users of the app
    func startHosting(action: UIAlertAction) {
        guard let mcSession = mcSession else { return }
        mcAdvertiserAssistant = MCAdvertiserAssistant(serviceType: "hws-project25", discoveryInfo: nil, session: mcSession)
        mcAdvertiserAssistant?.start()
    }
    
    func joinSession(action: UIAlertAction) {
        guard let mcSession = mcSession else { return }
        // MCBrowserViewController is used when looking for sessions, showing users who is nearby and letting them join
        let mcBrowser = MCBrowserViewController(serviceType: "hws-project25", session: mcSession)
        mcBrowser.delegate = self
        present(mcBrowser, animated: true)
    }
    
    // for MCSessionDelegate and MCBrowserViewControllerDelegate to work together their are seven methods required (most won't be used for this project but will still need to be stated)
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
    }
 
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        dismiss(animated: true)
    }
    
    // this method is called when something is changed (someone connected, disconnected, is connecting)
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        switch state {
        case .connected:
            print("Connected: \(peerID.displayName)")
            
        case .connecting:
            print("Connecting: \(peerID.displayName)")
            
        case .notConnected:
            print("Not Connected: \(peerID.displayName)")
            
        @unknown default:
            print("Unknown state received: \(peerID.displayName)")
        }
    }
    
    // final protocol to catch data being received in our session
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        // async is called because we should only manipulate UI in the main thread
        DispatchQueue.main.async { [weak self] in
            // create UIimage from image data and add it to images array
            if let image = UIImage(data: data) {
                self?.images.insert(image, at: 0)
                self?.collectionView.reloadData()
            }
        }
    }
    
    
}

