//
//  AttachmentsViewController.swift
//  LocalNotificationStudy
//
//  Created by 김정민 on 2020/03/09.
//  Copyright © 2020 kjm. All rights reserved.
//

import UIKit

class AttachmentsViewController: UIViewController {

      /*
          Attachments Notification
       1. 푸쉬 메시지에 이미지 첨부 가능
       --> 썸네일로 표시되게 하거나, 썸네일로만 표시하거나, 둘 다 표시하되 다른 이미지를 보이게 할 수 있음
       --> 이 때 bundle로 접근해서 가져오기 때문에 프로젝트에 꼭 리소스 파일이 있어야함
     2. 푸쉬 메시지에 동영상 첨부 가능
     --> 이미지와 동일함
     3. 사운드는 이미 커스텀에서 했기 때문에 패쓰
     4. 위 세개 모두 지원되는 확장자와 용량 꼭 확인해야함
       */
      
      // 이미지 첨부 (1)
      @IBAction func addImageAttachment(_ sender: Any) {
          let content = UNMutableNotificationContent()
          content.title = "Hello"
          content.body = "Image Attachment"
          content.sound = UNNotificationSound.default
          
          // image attachment
        guard let url = Bundle.main.url(forResource: "hello", withExtension: "png") else {return}
        var options = [UNNotificationAttachmentOptionsThumbnailHiddenKey : true]    // 썸네일 숨김
        
        guard let imageAttachment = try? UNNotificationAttachment(identifier: "hello-image", url: url, options: options) else {return}  // options를 통해 전달방식 설정 가능
        options = [UNNotificationAttachmentOptionsThumbnailHiddenKey : false]   // 썸네일 보임. 썸네일과 배너를 각기 다른 이미지로 전달할 수 있음
        
        // 새로운 이미지 생성
        guard let thumbUrl = Bundle.main.url(forResource: "logo", withExtension: "png") else {return}
        guard let thumbnailAttachment = try? UNNotificationAttachment(identifier: "thumbnail-image", url: thumbUrl, options: options) else {return}
        
        content.attachments = [imageAttachment, thumbnailAttachment]
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: "Image Attachment", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
      }
    
    // 동영상 첨부 (2)
    @IBAction func addVideoAttachment(_ sender: Any) {
        let content = UNMutableNotificationContent()
        content.title = "Hello"
        content.body = "Video Attachment"
        content.sound = UNNotificationSound.default
        
        // video attachment
        guard let url = Bundle.main.url(forResource: "video", withExtension: "mp4") else {return}
        guard let videoAttachment = try? UNNotificationAttachment(identifier: "video", url: url, options: nil) else {return}
        content.attachments = [videoAttachment]
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: "Video Attachment", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
      
      override func viewDidLoad() {
          super.viewDidLoad()
      }

}
