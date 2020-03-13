//
//  PendingNotificationsTableViewController.swift
//  LocalNotificationStudy
//
//  Created by 김정민 on 2020/03/13.
//  Copyright © 2020 kjm. All rights reserved.
//

import UIKit

class PendingNotificationsTableViewController: UITableViewController {
    
    /*
        Notification Management - Pending Notifications
     1. 예약 되어있는 Notification을 취소할 수 있음
     -> 여기선 tableview의 editingStyle을 통해 구현함
     2. 예약 되어있는 Notification을 확인할 수 있음
     */
    
    var pendingNotifications = [UNNotificationRequest]()
    
    // 예약되어있는 Notification 확인 (2)
    func refresh(){
        UNUserNotificationCenter.current().getPendingNotificationRequests { [weak self] (requests) in
            self?.pendingNotifications = requests
            
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    @objc func scheduleNotifications(){
        for interval in 1...10{
            let content = UNMutableNotificationContent()
            content.title = "Notification Title #\(interval)"
            content.body = "Notification Body #\(interval)"
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(interval), repeats: false)
            let request = UNNotificationRequest(identifier: "nid22\(interval)", content: content, trigger: trigger)
            
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        }
        
        refresh()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Schedule", style: .plain, target: self, action: #selector(scheduleNotifications))
        
        refresh()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pendingNotifications.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let target = pendingNotifications[indexPath.row]
        cell.textLabel?.text = target.content.title
        cell.detailTextLabel?.text = target.identifier
        
        return cell
    }
    
    // Notifications 예약 취소 (1)
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            let target = pendingNotifications[indexPath.row]
            
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [target.identifier]) // 특정 Notification 삭제
            
            // table view로 구성했으므로 배열 인스턴스 삭제 및 셀 삭제
            pendingNotifications.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
