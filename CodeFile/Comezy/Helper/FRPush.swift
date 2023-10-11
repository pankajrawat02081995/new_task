//
//  FRPush.swift
//  Comezy
//
//  Created by amandeepsingh on 04/08/22.
//

import UIKit

import Firebase

import FirebaseMessaging

import FirebaseCore
import CommonCrypto



class FRPush: NSObject {

    

    static let push = FRPush()

    override private init() {

        super.init()

    }

    func config(){

        FirebaseApp.configure()

    }

    func subscribeTopic(_ isSubscribe:Bool = true){

         let userID = UserDefaults.getInteger(forKey: "userId")

        let topic = "\(userID)"
        print("<----TOPIC------>",topic)
        if isSubscribe {

            Messaging.messaging().subscribe(toTopic: "buildezi_\(topic)"){ error in
                if error == nil{
                                print("Subscribed to topic")
                            }
                            else{
                                print("Not Subscribed to topic")
                            }
              }



        }else{
            Messaging.messaging().unsubscribe(fromTopic: "buildezi_\(topic)"){ error in
                if error == nil{
                                print("UNSubscribed to topic")
                            }
                            else{
                                print("Not UNSubscribed to topic")
                            }
              }


        }

    }

}
