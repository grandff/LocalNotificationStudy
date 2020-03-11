//
//  NotificationSettingsTableViewController.swift
//  LocalNotificationStudy
//
//  Created by 김정민 on 2020/03/11.
//  Copyright © 2020 kjm. All rights reserved.
//

import UIKit

class NotificationSettingsTableViewController: UITableViewController {
    /*
        Notification Settings
     1. getNotificationSettings를 통해 Notification 설정 값을 받을 수 있음
     2. Notification Settings 값을 읽어서 table view에 표시해주는 메서드 생성
     3. Local Notification은 허가가 되어있지 않아도 추가가 되므로 꼭 허가인 상태에서만 추가하도록 설정해야함
     */
    
    @IBOutlet weak var alertStyleLabel: UILabel!
    @IBOutlet weak var showPreviewsLabel: UILabel!
    @IBOutlet weak var alertLabel: UILabel!
    @IBOutlet weak var badgeLabel: UILabel!
    @IBOutlet weak var soundLabel: UILabel!
    @IBOutlet weak var notificationCenterLabel: UILabel!
    @IBOutlet weak var lockScreenLabel: UILabel!
    @IBOutlet weak var authorizationStatusLabel: UILabel!
    
    
    // Notification 설정값 확인 (1)
    @objc func refresh(){
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            DispatchQueue.main.async {
                self.update(from : settings)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // view 로드 시 설정값 확인 (1)
        refresh()
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        // Notification이 활성화 된 상태에서만 예약 (3)
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            // 활성화 상태인지 먼저 확인
            guard settings.authorizationStatus == .authorized else {return}
            
            let content = UNMutableNotificationContent()
            content.title = "Hello"
            content.body = "Hava a nice day :)"
            content.sound = UNNotificationSound.default
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            let request = UNNotificationRequest(identifier: "HelloNoti", content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            print("test")
        }
        
    }
    
    // NotificationSettings 값을 Table View에 표시 (2)
    func update(from settings : UNNotificationSettings){
        // 허가 상태 확인
        switch settings.authorizationStatus{
        case .notDetermined:
            authorizationStatusLabel.text = "Not Determined"
        case .authorized:
            authorizationStatusLabel.text = "Authorized"
        case .denied:
            authorizationStatusLabel.text = "Denied"
        case .provisional:
            authorizationStatusLabel.text = "Provisional"
        default:
            authorizationStatusLabel.text = "Unknwon"
        }
        
        // 사운드 옵션 관련
        switch settings.soundSetting {
        case .enabled:
            soundLabel.text = "Enabled"
        case .disabled:
            soundLabel.text = "Disabled"
        case .notSupported:
            soundLabel.text = "Not Support"
        default :
            soundLabel.text = "Unknown"
        }
        
        // Badge 옵션 확인
        badgeLabel.text = "\(settings.badgeSetting.rawValue)"
        
        // 잠금화면 설정 확인
        lockScreenLabel.text = "\(settings.lockScreenSetting.rawValue)"
        
        // Notification center setting 확인
        notificationCenterLabel.text = "\(settings.notificationCenterSetting.rawValue)"
        
        // alert 설정 확인
        alertLabel.text = "\(settings.alertSetting.rawValue)"
        
        // alert style 확인
        switch settings.alertStyle {
        case .banner:
            alertStyleLabel.text = "Banner"
        case .alert:
            alertStyleLabel.text = "Alert"
        case .none:
            alertStyleLabel.text = "None"
        default:
            alertStyleLabel.text = "Unknown"
        }
        
        // previews setting 확인 (ios 11 이후부터 가능함)
        switch settings.showPreviewsSetting {
        case .always:
            showPreviewsLabel.text = "Always"
        case .whenAuthenticated:
            showPreviewsLabel.text = "Authenticated"
        case .never:
            showPreviewsLabel.text = "Never"
        default:
            showPreviewsLabel.text = "Unknown"
        }
    }
}

// stringValue 여기서 해야함.. 위에 \() 감싼거 다 이걸로
extension UNNotificationSetting {
   var stringValue: String {
      switch self {
      case .notSupported:
         return "Not Supported"
      case .enabled:
         return "Enabled"
      case .disabled:
         return "Disabled"
      }
   }
}
