//
//  NewMessage.swift
//  ChatGPTClone
//
//  Created by Ulgen on 15.05.2025.
//

import Foundation

struct NewMessage{
    var role : String
    var content : String
    var date : Int
    
    static func asDictionaryMessages (dict : Dictionary<String,Any>) -> NewMessage {
        let role = dict["role"] as? String ?? ""
        let content = dict["content"] as? String ?? ""
        let date = dict["date"] as? Int ?? 0
        
        let newMessage = NewMessage(role: role, content: content, date: date)
        return newMessage
    }
}
