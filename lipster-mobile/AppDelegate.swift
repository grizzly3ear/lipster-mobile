//
//  AppDelegate.swift
//  lipster
//
//  Created by Mainatvara on 13/3/2562 BE.
//  Copyright © 2562 Mainatvara. All rights reserved.
//

import UIKit
import Firebase

import UserNotifications

import FBSDKLoginKit
import FBSDKCoreKit
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        FBLoginButton.self
        
        GIDSignIn.sharedInstance().clientID = "929204994294-d301m529i288rnjjbt0ulhquoooh05u7.apps.googleusercontent.com"
        
        if #available(iOS 10.0, *) {
          // For iOS 10 display notification (sent via APNS)
          UNUserNotificationCenter.current().delegate = self

          let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
          UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
        } else {
          let settings: UIUserNotificationSettings =
          UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
          application.registerUserNotificationSettings(settings)
        }

        application.registerForRemoteNotifications()
        
        Messaging.messaging().delegate = self
        
        UserRepository.getUser { (userModel, result) in
            if result {
                if let user = userModel {
                    User.setSingletonUser(user: user)
                }
            } else {
                User.clearSingletonUser()
            }
            
            
        }
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("***************************")
        print("error: \(error)")
        
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("****************************")
        print("token \(deviceToken)")
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        let facebookHandle: Bool = ApplicationDelegate.shared.application(app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as! String, annotation: options[UIApplication.OpenURLOptionsKey.annotation])
        let googleHandle: Bool = GIDSignIn.sharedInstance().handle(url)
        
        return true
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print(userInfo)
        let aps = userInfo["aps"] as! NSDictionary
        print(aps["category"])
        
    }
    
    
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {

        print("token: \(fcmToken)")
        
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instance ID: \(error)")
            } else if let result = result {
                print("Remote instance ID token: \(result.token)")
                UserRepository.setNotificationToken(token: result.token) { _ in
                    UserRepository.getMyNotification { (_, _) in }
                }

            }
        }
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        let category = notification.request.content.categoryIdentifier

        if category == "setBadge" || category == "trend_group" {
            
            NotificationCenter.default.post(name: NSNotification.Name(NotificationEvent.updateBadge),
                                            object: self,
                                            userInfo: ["badge": notification.request.content.badge])
            
            completionHandler([.badge])
            return
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(NotificationEvent.newNotification),
                                        object: self)
        
        completionHandler([.alert, .sound, .badge])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let application = UIApplication.shared
        let userInfo = response.notification.request.content.userInfo        
        
        guard let dataId = (userInfo["data"] as? NSString)?.integerValue else {
            completionHandler()
            return
        }
        
        guard let rootvc = self.window?.rootViewController as? TabBarController else {
            completionHandler()
            return
        }
        
        rootvc.selectedIndex = 0
        
        guard let navvc = rootvc.selectedViewController as? UINavigationController else {
            completionHandler()
            return
        }
        
        if response.notification.request.content.categoryIdentifier == "trend_group" {
            
            let vc = rootvc.storyboard?.instantiateViewController(withIdentifier: "PinterestCollectionViewController") as! PinterestCollectionViewController
            
            TrendRepository.fetchTrendGroupFromId(dataId) { (trendGroup, httpStatusCode) in
                vc.trendGroup = trendGroup
                navvc.pushViewController(vc, animated: true)
                completionHandler()
                return
            }
        }

        if application.applicationState == .active {
            print("user tap app when app are already active")
        }

        if application.applicationState == .inactive {
            print("user tap app when app in background")
        }


        completionHandler()
    }
}
