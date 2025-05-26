//
//  UserIdentificationManager.swift
//  ChatGPTClone
//
//  Created by Ulgen on 14.05.2025.
//

import Foundation
import FirebaseDatabase

class UserIdentificationManager {
    
    static let shared = UserIdentificationManager()
    
    private init() {}
    
    func assignUserIdIfNeeded() {
        if let userID = UserDefaults.standard.string(forKey: "userID") {
            print("The user already has an ID: \(userID)")
        }else{
            let newUserId = UUID().uuidString
            saveUserIdToFirebase(userID: newUserId)
            UserDefaults.standard.set(newUserId, forKey: "userID")
        }
    }
    private func saveUserIdToFirebase(userID: String) {
        let databaseRef = Database.database().reference()
        let usersRef = databaseRef.child("users").child(userID)
        let updates : [String: Any] = [
            "userID" : userID,
            "premium" : false
        ]
        usersRef.updateChildValues(updates){ error, ref in
            if let error = error {
                print(error.localizedDescription)
            }
            
        }
        
        
    }
    
}
