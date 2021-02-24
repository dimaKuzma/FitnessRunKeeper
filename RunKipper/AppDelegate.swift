//
//  AppDelegate.swift
//  RunKipper
//
//  Created by Дмитрий on 12/18/20.
//  Copyright © 2020 DK. All rights reserved.
//

import UIKit
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    // - Window
    var window: UIWindow?
    let googleMapsApiKey = "AIzaSyA3aQoCunStRdX2DF6vwigBTH7OGBrtFNo"
    
    // - Notification
    let notificationCenter = UNUserNotificationCenter.current ()
    
    // - Data
    private var countsOfLaunch = UserDefaults.standard.integer(forKey: "CountsOfLaunch")
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GMSServices.provideAPIKey(googleMapsApiKey)
        window = UIWindow(frame: UIScreen.main.bounds)
        if countsOfLaunch == 0 {
        window?.rootViewController = UIStoryboard(name: "Preview", bundle: nil).instantiateInitialViewController() as! PreviewViewController
            countsOfLaunch += 1
            UserDefaults.standard.set(countsOfLaunch, forKey: "CountsOfLaunch")
        } else {
            window?.rootViewController = TabBarController()
        }
//        window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! ViewController
        window?.makeKeyAndVisible()
        notificationCenter.delegate = self
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        notificationCenter.requestAuthorization (options: options) {
            (didAllow, error) in
            print ("Пользователь разрешил уведомления")
        }
        return true
    }
    
    func recordNotification (notificationType: String, distance: Int) {
        
        let content = UNMutableNotificationContent () // Содержимое уведомление
        let userActions = "User Actions"
        content.title = notificationType
        if notificationType == "Новый рекорд" {
            content.body = "Самая длительная тренировка на \(distance) км"
        }
        if #available(iOS 12.0, *) {
            content.sound = UNNotificationSound.defaultCritical
        } else {
            content.sound = UNNotificationSound.default
        }
        content.badge = 1 // значок кол-ва уведомлений
        content.categoryIdentifier = userActions
        let trigger = UNTimeIntervalNotificationTrigger (timeInterval: 1, repeats: false)
        let identifier = "Local Notification"
        let request = UNNotificationRequest (identifier: identifier, content: content, trigger: trigger)
        
        notificationCenter.add (request) {(error) in
            if let error = error {
                print ("Error \(error.localizedDescription)")
            }
        }
        // после отведения уведомления вниз появятся выборки
        let snoozeAction = UNNotificationAction(identifier: "Snooze", title: "Отложить", options: [])
        let deleteAction = UNNotificationAction(identifier: "Delete", title: "Удалить", options: [.destructive])
        let category = UNNotificationCategory(identifier: userActions, actions: [snoozeAction, deleteAction], intentIdentifiers: [], options: [])
        
        notificationCenter.setNotificationCategories([category])
    }
    
    func sneakersNotification (notificationType: String, distance: Int, name: String) {
        
        let content = UNMutableNotificationContent () // Содержимое уведомление
        let userActions = "User Actions"
        content.title = notificationType
        if notificationType == "Обувь износилась" {
            content.body = "Кроссовки \(name) прошли свои \(distance) км"
        }
        if #available(iOS 12.0, *) {
            content.sound = UNNotificationSound.defaultCritical
        } else {
            content.sound = UNNotificationSound.default
        }
        content.badge = 1 // значок кол-ва уведомлений
        content.categoryIdentifier = userActions
        let trigger = UNTimeIntervalNotificationTrigger (timeInterval: 1, repeats: false)
        let identifier = "Local Notification"
        let request = UNNotificationRequest (identifier: identifier, content: content, trigger: trigger)
        
        notificationCenter.add (request) {(error) in
            if let error = error {
                print ("Error \(error.localizedDescription)")
            }
        }
        // после отведения уведомления вниз появятся выборки
        let snoozeAction = UNNotificationAction(identifier: "Snooze", title: "Отложить", options: [])
        let deleteAction = UNNotificationAction(identifier: "Delete", title: "Удалить", options: [.destructive])
        let category = UNNotificationCategory(identifier: userActions, actions: [snoozeAction, deleteAction], intentIdentifiers: [], options: [])
        
        notificationCenter.setNotificationCategories([category])
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    
}

// MARK: -
// MARK: Delegate Notification
extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter (_ center: UNUserNotificationCenter,
                                 willPresent notification: UNNotification,
                                 withCompletionHandler completedHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completedHandler([.alert, .sound])
        
    }
}


