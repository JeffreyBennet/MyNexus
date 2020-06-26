
import Firebase
import FirebaseFirestore
import FirebaseMessaging
import UIKit
import UserNotifications

class PushNotificationManager: NSObject, MessagingDelegate, UNUserNotificationCenterDelegate {
    let db = Firestore.firestore()
    func registerForPushNotifications() {
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
            // For iOS 10 data message (sent via FCM)
            Messaging.messaging().delegate = self
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
        UIApplication.shared.registerForRemoteNotifications()
        //updateFirestorePushTokenIfNeeded()
    }
    
    func updateFirestorePushTokenIfNeeded() {
        if let token = Messaging.messaging().fcmToken {
            db.collection(Auth.auth().currentUser?.uid ?? "").document("UserInfo").getDocument(){
                (document, error) in
                if let snapshot = document{
                    if snapshot.exists{
                        print(token)
                        self.db.collection(Auth.auth().currentUser?.uid ?? "").document("UserInfo").getDocument(){(document, error) in
                            let data = document?.data()
                            Constants.fcmToken = token
                            Constants.name = data!["Name"] as! String
                            if let fcm = data?["fcmToken"] as? String{
                                if fcm != token{
                                   
                            self.db.collection(Auth.auth().currentUser?.uid ?? "").document("UserInfo").setData(["fcmToken": token], merge: true)
                                    Constants.isNewDevice = true
                                    NotificationCenter.default.post(
                                    name: Notification.Name("SuccessfulNotificationSetUp"), object: nil, userInfo: nil)
                                    
                                    
                                }
                                else{
                                    Constants.isNewDevice = false
                                    NotificationCenter.default.post(
                                    name: Notification.Name("SuccessfulNotificationSetUp"), object: nil, userInfo: nil)
                                }
                                    
                                
                            }
                        }
                        
                    }
                    else{
                        Constants.isNewDevice = true 
                        self.db.collection(Auth.auth().currentUser?.uid ?? "").document("UserInfo").setData(["fcmToken": token,"TimeStamp": "\(Date().timeIntervalSince1970)","OwnedTimeStamp": "\(Date().timeIntervalSince1970)","JoinedTimeStamp": "\(Date().timeIntervalSince1970)","UUID": Auth.auth().currentUser?.uid ?? "", "Sender": Auth.auth().currentUser?.email ?? "","Name": Auth.auth().currentUser? .displayName ?? ""])
                        Constants.fcmToken = token
                        Constants.name = Auth.auth().currentUser?.displayName ?? ""
                            NotificationCenter.default.post(
                                     name: Notification.Name("SuccessfulNotificationSetUp"), object: nil, userInfo: nil)
                    }
                }
            }
        }
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        print(remoteMessage.appData)
    }
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
       // updateFirestorePushTokenIfNeeded()
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print(response)
    }
}
