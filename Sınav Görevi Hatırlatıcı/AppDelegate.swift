//
//  AppDelegate.swift
//  Sınav Görevi Hatırlatıcı
//
//  Created by Furkan Selcuk Dag on 9.01.2017.
//  Copyright © 2017 Furkan Selcuk Dag. All rights reserved.
//

import UIKit
import Firebase
import FirebaseInstanceID
import FirebaseMessaging
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FIRApp.configure()

        
        
        if #available(iOS 10.0, *) {
            let authOptions : UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_,_ in })
            
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            // For iOS 10 data message (sent via FCM)
            FIRMessaging.messaging().remoteMessageDelegate = self
        }
            else {
                let settings: UIUserNotificationSettings =
                    UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
                application.registerUserNotificationSettings(settings)

                 }
        
                
                application.registerForRemoteNotifications()
        
        return true
        
    }


    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        // TODO: Handle data of notification
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Print full message.
        print(userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }
    
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
 
        
        FIRMessaging.messaging().disconnect()
        print("Disconnected from FCM.")
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {

    }

    func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {
        
        return true
        }
    }
    
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
        connectToFcm()
        
    }

    func applicationWillTerminate(_ application: UIApplication) {

    }
    
    func tokenRefreshNotification(_ notification: Notification) {
    if let refreshedToken = FIRInstanceID.instanceID().token() {
        print("InstanceID token: \(refreshedToken)")
    }
    
    // Connect to FCM since connection may have failed when attempted before having a token.
    connectToFcm()
}

func connectToFcm() {
    // Won't connect since there is no token
    guard FIRInstanceID.instanceID().token() != nil else {
        return;
    }
    
    // Disconnect previous FCM connection if it exists.
    FIRMessaging.messaging().disconnect()
    
    FIRMessaging.messaging().connect { (error) in
        if error != nil {
            print("Unable to connect with FCM. \(error)")
        } else {
            print("Connected to FCM.")
        }
    }
}

func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
    print("Unable to register for remote notifications: \(error.localizedDescription)")
}

// This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
// If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
// the InstanceID token.
func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    print("APNs token retrieved: \(deviceToken)")
    
    // With swizzling disabled you must set the APNs token here.
    // FIRInstanceID.instanceID().setAPNSToken(deviceToken, type: FIRInstanceIDAPNSTokenType.sandbox)
}



@available(iOS 10, *)
extension AppDelegate : UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        // Print message ID.
        print("Message ID: \(userInfo["gcm.message_id"]!)")
        
        // Print full message.
        print("%@", userInfo)
        
    }
}


// [END ios_10_message_handling]
// [START ios_10_data_message_handling]
extension AppDelegate : FIRMessagingDelegate {
    // Receive data message on iOS 10 devices while app is in the foreground.
    func applicationReceivedRemoteMessage(_ remoteMessage: FIRMessagingRemoteMessage) {
        print(remoteMessage.appData)
    }
}
