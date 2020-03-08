//
//  AppDelegate.swift
//  LocalNotificationStudy
//
//  Created by 김정민 on 2020/03/08.
//  Copyright © 2020 kjm. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    /*
        Local Notification
     1. 권한 요청을 해야함
     --> 처음 허용 또는 거부를 한 후 다시 앱을 실행하면 표시가 안됨.
     --> 설정에 들어가서 직접 해지를 하거나 해줘야함
     --> UserNotifications import
     2. foreground에서 앱이 실행 중일 때 Notification 처리 설정
     --> delegate로 처리해줘야함
     3. Notification 클릭 했을 경우 이벤트 처리 설정
     --> 마찬가지로 delegate로 처리해야함
     */


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Local Notification 권한 요청 (1)
        UNUserNotificationCenter.current().requestAuthorization(options: [UNAuthorizationOptions.badge, .sound, .alert]) { (granted, error) in
            if granted{
                UNUserNotificationCenter.current().delegate = self
            }
            
            print("granted \(granted)")
        }
        
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

extension AppDelegate : UNUserNotificationCenterDelegate{
    // foreground에서 앱이 실행 중일때 Notification 처리 (2)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let content = notification.request.content
        let trigger = notification.request.trigger
        
        completionHandler([UNNotificationPresentationOptions.alert])        // 마지막에 handler를 꼭 호출해줘야함
    }
    
    // Notification 클릭 시 처리 이벤트 (3)
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let content = response.notification.request.content
        let trigger = response.notification.request.trigger
        
        completionHandler()
    }
}

