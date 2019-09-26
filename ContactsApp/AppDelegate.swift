//
//  AppDelegate.swift
//  ContactsApp
//
//  Created by Aman Agarwal on 24/09/19.
//  Copyright © 2019 Aman Agarwal. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        NetworkUtility.getContactsList(handler: {
          (list, error) in
            if(error == nil && list != nil) {
                print("Contact list received successfully")
                for contact : ContactListModel in list! {
                    if(!contact.url.isEmpty) {
                        print("Fetch contact details for URL", contact.url)
                        NetworkUtility.getContactDetails(urlString: contact.url, handler: { (model, error) in
                            if(error == nil && model != nil) {
                                print("Contact details fetched successfully")
                                NetworkUtility.updateContactDetails(contact: model!)
                            }
                        })
                        break;
                    }
                }
            }
        })
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

