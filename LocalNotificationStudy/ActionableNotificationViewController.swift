//
//  ActionableNotificationViewController.swift
//  LocalNotificationStudy
//
//  Created by 김정민 on 2020/03/11.
//  Copyright © 2020 kjm. All rights reserved.
//

import UIKit
import UserNotifications

class ActionableNotificationViewController: UIViewController {

    /*
        Actionable Notification
     1. Notification 클릭 이벤트 등을 설정하기 위해 Appdelegate에서 선행작업
     2. Appdelegate에서 모든 구현을 마쳤으면 Action을 통해 이미지 변경을 위한 메서드 생성
     --> Appdelegate에서 생성한 forkey로 호출해야함
     3. Category를 식별할 수 있도록 UserNotification 생성
     --> 여기선 schedule 버튼에 액션을 달아놨음
     4. View가 호출되는 시점에서 이미지가 변경하도록 viewwillapper 추가
     5. background를 통해 다시 접근할 경우 이미지를 바로 변경해줘야함
     */
    
    @IBOutlet weak var imageView: UIImageView!
    
    // Category를 확인할 수 있는 UserNotification (3)
    @IBAction func schedule(_ sender: Any) {
        let content = UNMutableNotificationContent()
        content.title = "Hello"
        content.body = "KxCoding just shared a photo"
        content.sound = UNNotificationSound.default
        
        // category identifier 선언
        content.categoryIdentifier = CategoryIdentifier.imagePosting
        
        guard let url = Bundle.main.url(forResource: "hello", withExtension: "png") else{return}
        guard let imageAttachment = try? UNNotificationAttachment(identifier: "logo-image", url: url, options: nil) else{return}
        content.attachments = [imageAttachment]
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: "Image Attachment", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    // action 식별자를 통해 이미지 호출을 위한 메서드 (2)
    @objc func updateSelection(){
        switch UserDefaults.standard.string(forKey: "usersel") {
        case .some(ActionIdentifier.like):
            imageView.image = UIImage(named: "thumb-up")
        case .some(ActionIdentifier.dislike):
            imageView.image = UIImage(named: "thumb-down")
        default :
            imageView.image = UIImage(named: "question")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // background를 통해 다시 접근할 경우 이미지 호출 (5)
        NotificationCenter.default.addObserver(self, selector: #selector(updateSelection), name: UIApplication.didBecomeActiveNotification, object: nil)        
    }
    

    
    // viewWillAppear를 통해 이미지 변경 (4)
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateSelection()
    }
}
