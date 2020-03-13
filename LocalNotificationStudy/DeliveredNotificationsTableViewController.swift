//
//  DeliveredNotificationsTableViewController.swift
//  LocalNotificationStudy
//
//  Created by 김정민 on 2020/03/13.
//  Copyright © 2020 kjm. All rights reserved.
//

import UIKit

class DeliveredNotificationsTableViewController: UITableViewController {
    
    /*
       Notification Management - Delivered Notifications
    1. 현재 앱으로 전달된 Notification을 전부 확인할 수 있음
    --> Remote와 Local 전부 확인 가능
    --> Notification을 실행하지 않았을 경우에만 목록에 보임
    2. 예약 Notification 삭제 처럼 전달된 Notification 또한 삭제 가능
    */
    
    var deliveredNotifications = [UNNotification]()
    
    // 전달된 Notification 확인 (1)
    func refresh(){
        deliveredNotifications.removeAll()
        UNUserNotificationCenter.current().getDeliveredNotifications { [weak self] (notifications) in
            self?.deliveredNotifications = notifications
            
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        refresh()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return deliveredNotifications.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let target = deliveredNotifications[indexPath.row]
        cell.textLabel?.text = target.request.content.title
        cell.detailTextLabel?.text = target.request.identifier
        
        return cell
    }
    
    // 전달된 Notification 삭제 (2)
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let target = deliveredNotifications[indexPath.row]
        
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [target.request.identifier])
        
        deliveredNotifications.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}
