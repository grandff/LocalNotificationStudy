//
//  LocalNotificationViewController.swift
//  LocalNotificationStudy
//
//  Created by 김정민 on 2020/03/08.
//  Copyright © 2020 kjm. All rights reserved.
//

import UIKit
import UserNotifications

class LocalNotificationViewController: UIViewController {

    /*
        Local Notification
    --> picker view에서 설정한 타이머 후에 notification이 오는 앱 설정
     1. Local notification 예약 설정
     2. 만약 Notification을 클릭해서 들어온 경우 badge를 초기화 해줘야함
     --> 이경우 코드로 구현해야함
     */
    
    var interval : TimeInterval = 1     // timer 설정을 위한 변수
    @IBOutlet weak var inputField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // badge 초기화 (2)
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    // Local notification 예약 처리 버튼 (1)
    @IBAction func schedule(_ sender: Any) {
        let content = UNMutableNotificationContent()
        content.title = "Hello"
        content.body = inputField.text ?? "Empty body"
        content.badge = 123
        content.sound = UNNotificationSound.default
        
        /*
            trigger 종류
         UNCalendarnotifiationTrigger -> 지정된 날짜에 실행
         UNTimeIntervalNotificationTrigger -> 현재 시간 기준으로 실행
         UNLocationNotificationTrigger -> 특정 위치에서 실행
         */
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: false) // repeats는 60 이상 값을 써야함
        let request = UNNotificationRequest(identifier: "test", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { (error) in
            if let error = error{
                print(error)
            }else{
                print("Done")
            }
        }
        
        inputField.text = nil
    }
}


// picker view 기본 설정(60초 타이머용)
extension LocalNotificationViewController : UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 60
    }
}

extension LocalNotificationViewController : UIPickerViewDelegate{
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(row + 1)"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        interval = TimeInterval(row + 1)
    }
}
