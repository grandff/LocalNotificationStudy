//
//  CustomSoundViewController.swift
//  LocalNotificationStudy
//
//  Created by 김정민 on 2020/03/09.
//  Copyright © 2020 kjm. All rights reserved.
//

import UIKit
import UserNotifications

class CustomSoundViewController: UIViewController {

    /*
        Local Notification Custom Sound
     1. sound를 default가 아닌 프로젝트에 추가한 파일로 설정할 수 있음
     --> 확장자까지 다 적어줘야함
     */
    
    // Custom Sound (1)
    @IBAction func useCustomSound(_ sender: Any) {
        let content = UNMutableNotificationContent()
        content.title = "Hello"
        content.body = "Custom Sound"
        content.sound = UNNotificationSound(named: UNNotificationSoundName(rawValue: "bell.aif"))
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let request = UNNotificationRequest(identifier: "CustomSound", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
