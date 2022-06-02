//
//  NotificationViewController.swift
//  NotificationContent
//
//  Created by SangWoo's MacBook on 2022/06/01.
//

import UIKit
import UserNotifications
import UserNotificationsUI

class NotificationViewController: UIViewController, UNNotificationContentExtension {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet var label: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any required interface initialization here.
       
        self.imageView.layer.cornerRadius = 35
        
        // Define the custom actions.
        let acceptAction = UNNotificationAction(identifier: "ACCEPT_ACTION", // identifier는 카테고리 구분 없이 유일 해야함
              title: "Accept",
              options: [])
        let declineAction = UNNotificationAction(identifier: "DECLINE_ACTION",
              title: "Decline",
              options: [])
        
        // Define the notification type
        //카테고리 별로 분기 가능 (push시에 보내는 category)
        let meetingInviteCategory =
              UNNotificationCategory(identifier:  "myNotificationCategory",
              actions: [acceptAction, declineAction],
              intentIdentifiers: [],
              hiddenPreviewsBodyPlaceholder: "",
                                     options: .customDismissAction)
        // Register the notification type.
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.setNotificationCategories([meetingInviteCategory])
        
        
    }
    
    func didReceive(_ notification: UNNotification) {
        //이미지 URL로 추가
        if let aps = notification.request.content.userInfo["aps"] as? [AnyHashable : Any] {
            guard let urlArgs = aps["url-args"] as? [String] else { return }
            if let urlString = urlArgs.first {
                let url = URL(string: urlString)!
                print(url)
                let data = try! Data(contentsOf: url)
                self.imageView.image = UIImage(data: data)
            }
        }
        let content = notification.request.content
        self.label.text = content.title
        self.subTitleLabel.text = content.subtitle
        self.bodyLabel.text = content.body
    }
    
    
    // 사용자가 액션을 눌렀을때 호출되는 델리게이트 메소드
    // userNotificationCenterDelegate에 있다!
    func userNotificationCenter(_ center: UNUserNotificationCenter,
           didReceive response: UNNotificationResponse,
           withCompletionHandler completionHandler:
             @escaping () -> Void) {
    
    }
}
