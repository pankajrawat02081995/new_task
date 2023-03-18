//
//  NotificationService.swift
//  NotificationServiceExtension
//
//  Created by aakarshit on 18/10/22.
//

import UserNotifications

class NotificationService: UNNotificationServiceExtension {

    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?
    let defaults = UserDefaults(suiteName: "group.com.buildezi.ajas")

    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
               bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
               var count: Int = defaults?.value(forKey: "count") as! Int
               if let bestAttemptContent = bestAttemptContent {
                   bestAttemptContent.title = "\(bestAttemptContent.title) "
                   bestAttemptContent.body = "\(bestAttemptContent.body) "
                   bestAttemptContent.badge = count as? NSNumber
                   count = count + 1
                   defaults?.set(count, forKey: "count")
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

}
