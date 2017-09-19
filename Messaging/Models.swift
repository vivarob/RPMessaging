//
//  Models.swift
//  Messaging
//
//  Created by Roberto Pirck Valdés on 18/9/17.
//  Copyright © 2017 Roberto Pirck Valdés. All rights reserved.
//

import Foundation
import UIKit



class User {
    let uid: String
    let username: String
    let email: String
    let chats: [String]
    
    init(dictionary: [String: Any]) {
        self.uid = dictionary["uid"] as? String ?? "Invalid id"
        self.username = dictionary["username"] as? String ?? "Invalid username"
        self.email = dictionary["email"] as? String ?? "Invalid email"
        self.chats = dictionary["chats"] as? [String] ?? []
    }
    init(uid: String, username: String, email: String, chats: [String]) {
        self.uid = uid
        self.username = username
        self.email = email
        self.chats = chats
    }
}

class Chat {
    let id: String
    let messages: [String]
    let users: [String]
    let lastMessage: String


    init(dictionary: [String: Any]) {
        self.id = dictionary["id"] as? String ?? "Invalid id"
        self.messages = dictionary["messages"] as? [String] ?? []
        self.users = dictionary["users"] as? [String] ?? []
        self.lastMessage = dictionary["lastMessage"] as? String ?? "Invalid message"

    }
    
    init(id: String, messages: [String], users: [String], lastMessage: String) {
        self.id = id
        self.users = users
        self.messages = messages
        self.lastMessage = lastMessage

    }
}

class Message {
    let id: String
    let text: String
    let userId: String
    
    init(dictionary: [String: Any]) {
        self.id = dictionary["id"] as? String ?? "Invalid id"
        self.text = dictionary["text"] as? String ?? "Invalid text"
        self.userId = dictionary["userId"] as? String ?? "Invalid userId"
        
    }
    
    init(id: String, text: String, userId: String) {
        self.id = id
        self.userId = userId
        self.text = text
        
    }
}
