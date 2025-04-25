//
//  Message.swift
//  ChatGPTClone
//
//  Created by Ulgen on 18.03.2025.
//message model two parameters role and content

import Foundation

struct Message: Codable {//our model must be codable
    let role: String
    let content: String
    
    func asDictionary()-> [String: Any] {
        let dictionary: [String: Any] = ["role": role,
                                         "content": content]
        return dictionary
    }
    
    
}
