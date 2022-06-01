//
//  AppDelegate.swift
//  RemotePush
//
//  Created by SangWoo's MacBook on 2022/05/27.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let authOptions: UNAuthorizationOptions = [.alert, .sound, .badge]
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: authOptions){ //권한요청
            (isAllowd, error) in
            if isAllowd {
                DispatchQueue.main.async(execute: {
                    // 토큰 생성 및 APNs전달
                    application.registerForRemoteNotifications()
                })
            }
        }
        center.delegate = self
        
        return true
    }
  //토큰 전달 성공
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        
        print("APNs device token: \(deviceTokenString)")
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        print(error.localizedDescription)
        
    }

}


//MARK: - Extension for UNUserNotificationCenterDelegate
extension AppDelegate: UNUserNotificationCenterDelegate {
    // 앱이 포그라운드 일 때
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
       
        print("UserInfo: \(userInfo) at willPresent\n aabb\n")
        
        completionHandler([.sound, .banner])
    }

    // 앱이 백그라운드 일 때 노티 알림 노티를 터치할 때 호출됨
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        print("UserInfo: \(userInfo) at didReceive ")
        
        
        completionHandler()
    }
    // 백그라운드시 푸쉬
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print("UserInfo: \(userInfo) at background push \n")
        
        completionHandler(.noData)
    }
}
