//
//  AppDelegate.swift
//  LocalNotificationStudy
//
//  Created by 김정민 on 2020/03/08.
//  Copyright © 2020 kjm. All rights reserved.
//

import UIKit
import UserNotifications

// 액션 식별자로 쓸 구조체 (2-1)
struct ActionIdentifier {
    static let like = "ACTION_LIKE"
    static let dislike = "ACTION_DISLIKE"
    static let unfollow = "ACTION_UNFOLLOW"
    static let setting = "ACTION_SETTING"
    private init() {}
}

// 카테고리 식별자로 쓸 구조체 (2-1)
struct CategoryIdentifier {
    static let imagePosting = "CATEGORY_IMAGE_POSTING"
    private init(){}
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
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
    
    /*
        Actionalbe Notifications
     1. 액션의 식별자와 카테고리 식별자를 구분하기 위해 구조체 생성
     2. Notification을 드롭 다운 했을때 보이는 액션 추가
     3. Action 버튼을 눌렀을때 이벤트 처리 구현
     --> Delegate로 구현해야함
     --> Notification에 따라 이미지를 변경하려고 할때도 여기서 해줘야함
     4. Notification 권한 요청 시 해당 메서드 호출
     */
    
    // Notification Category 설정을 통해 Notification Action 추가 (2-2)
    func setupCategory(){
        let likeAction = UNNotificationAction(identifier: ActionIdentifier.like, title: "Like", options: [])
        let dislikeAction = UNNotificationAction(identifier: ActionIdentifier.dislike, title: "Dislike", options: [])
        let unfollowAction = UNNotificationAction(identifier: ActionIdentifier.unfollow, title: "Unfollow", options: [.authenticationRequired, .destructive])   // authenticationRequired는 잠금 상태에서는 잠금 해제가 필요함
        
        // 배너를 받고 싶지 않을 경우 설정을 할 수 있는 액션도 추가
        let settingAction = UNNotificationAction(identifier: ActionIdentifier.setting, title: "Setting", options: [.foreground])
        
        // Custom Dismiss 액션 추가. Default는 항상 처리 가능하고, Custom은 options에 추가를 해야 처리가 가능함
        var options = UNNotificationCategoryOptions.customDismissAction
        options.insert(.hiddenPreviewsShowTitle)    // preview 상태에서 title 숨김처리
        
        let imagePostingCategory = UNNotificationCategory(identifier: CategoryIdentifier.imagePosting, actions: [likeAction, dislikeAction, unfollowAction, settingAction], intentIdentifiers: [], options: options)
        UNUserNotificationCenter.current().setNotificationCategories([imagePostingCategory])
    }


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // Local Notification 권한 요청 (1)
        UNUserNotificationCenter.current().requestAuthorization(options: [UNAuthorizationOptions.badge, .sound, .alert]) { (granted, error) in
            if granted{
                // category 설정 호출 (2-4)
                self.setupCategory()
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
        
        // Action 버튼 이벤트 구현 (2-3)
        // switch를 통한 로그만 확인해볼거임
        switch response.actionIdentifier{
        case ActionIdentifier.like :
            print("Like")
        case ActionIdentifier.dislike :
            print("Dislike")
        case UNNotificationDismissActionIdentifier:
            print("Custom Dismiss")
        case UNNotificationDefaultActionIdentifier:
            print("Launch from noti")
        default :
            print("none")
        }
        
        // 이미지 변경을 위한 코드 (2-3)
        UserDefaults.standard.set(response.actionIdentifier, forKey: "usersel")
        UserDefaults.standard.synchronize()
        
        completionHandler()
    }
}

