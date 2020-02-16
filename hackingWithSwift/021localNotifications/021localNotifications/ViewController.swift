//
//  ViewController.swift
//  021localNotifications
//
//  Created by Vaughn on 9/10/19.
//  Copyright © 2019 Vaughn Anton. All rights reserved.
//
// we'll send reminders to user's lock screen to show info when app isn't running
// this is like when you set a reminder in a calendar and it pops up on the lock screen at the correct time 

import UIKit
import UserNotifications

class ViewController: UIViewController, UNUserNotificationCenterDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Register", style: .plain, target: self, action: #selector(registerLocal))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(scheduleLocal))
        
    }
    
    // ask for permission for notifications
    @objc func registerLocal() {
        let center = UNUserNotificationCenter.current()
        
        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted {
                print("Yay!")
            } else {
                print("D'oh!")
            }
        }
    }
    
    // once permission is granted, this will configure all data to schedule a notification (content - what to show, trigger - when to show it, and request - the combo of content and trigger)
    @objc func scheduleLocal() {
        let center = UNUserNotificationCenter.current()
        
        // this is a calendar alert, repeating every day at 1030am
        var dateComponents = DateComponents()
        dateComponents.hour = 10
        dateComponents.minute = 30
        // date based calendar trigger
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        // interval based trigger
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        // we can add buttons for user to choose from (UNNotificationAction creates individual button, UNNotificationCategory groups multiple buttons together)
        // creating a UNNotificationAction requires three parameters (an identifier - a unique string that gets sent when button is tapped, a title, and any options)
        func registerCategories() {
            let center = UNUserNotificationCenter.current()
            center.delegate = self
            
            let show = UNNotificationAction(identifier: "show", title: "Tell me more...", options: .foreground)
            let category = UNNotificationCategory(identifier: "alarm", actions: [show], intentIdentifiers: [])
            
            center.setNotificationCategories([category])
        }
    
        // what to actually show
        let content = UNMutableNotificationContent()
        content.title = "Late wake up call"
        content.body = "The early bird catches the worm, but the second mouse gets the cheese."
        content.categoryIdentifier = "alarm"
        // attaching custom data to the notifcation, like an internal ID
        content.userInfo = ["customData": "fizzbuzz"]
        content.sound = UNNotificationSound.default
        
        // UUID will generate unique identifiers
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
        // cancel pending notifications,
        center.removeAllDeliveredNotifications()
        
        func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
            
            //pull out the buried userInfo dictionary
            let userInfo = response.notification.request.content.userInfo
            
            if let customData = userInfo["customData"] as? String {
                print("Custom data received: \(customData)")
                
                switch response.actionIdentifier {
                    case UNNotificationDefaultActionIdentifier:
                    // the user swiped to unlock
                    print("Default Identifier")
                    
                    case "show":
                    // the user tapped our "show more info..." button
                    print("Show more information...")
                    
                default:
                    break
                }
            }
            // must call completion handler when done
            completionHandler()
        }
        
        // this project now creates notifications, attaches them to categories so you can create action buttons, then responds to whichever button was tapped by the user
    }

}

