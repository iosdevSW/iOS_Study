//
//  NotificationService.swift
//  NotificationService
//
//  Created by SangWoo's MacBook on 2022/05/29.
//

import UserNotifications

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?

    //푸시 변경이 가능한 푸시가 전달될 경우 수신되는 함수 부분
    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        
        if let bestAttemptContent = bestAttemptContent {
            // Modify the notification content here...
            // 푸시를 실질적으로 변경하는 부분
            bestAttemptContent.title = "수정한 제목 / [수정됨!]"
            var urlString: String? = nil
            if let urlArg = bestAttemptContent.userInfo["urlArg"] as? [String] {
                urlString = urlArg[0]
                
                if let imagePath = self.image(urlString!){
                    let imageURL = URL(fileURLWithPath: imagePath)
                    do {
                        let attach = try UNNotificationAttachment(identifier: "image-test", url: imageURL, options: nil)
                        bestAttemptContent.attachments = [attach]
                    } catch {
                        print(error)
                    }
                }
            
            }
            
            contentHandler(bestAttemptContent)
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent =  bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
    
    func image(_ stringURL: String) -> String? {
        let component = stringURL.components(separatedBy: "/")
        if let fileName = component.last { // 파일명 구하기
            // 경로 구하기
            let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
            if let documentPath = paths.first {
                let filePath = documentPath.appending("/" +  fileName)
                
                if let imageURL = URL(string: stringURL) {
                    do {
                        let data = try NSData(contentsOf: imageURL, options: NSData.ReadingOptions.init(rawValue: 0))
                        if data.write(toFile: filePath, atomically: true) {
                            return filePath
                        }
                    } catch {
                        print(error)
                    }
                }
            }
        }
        return nil
    }

}
