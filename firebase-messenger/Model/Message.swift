//
//  Message.swift
//  firebase-messenger
//
//  Created by r3d on 29/10/2017.
//  Copyright © 2017 Alexandru Corut. All rights reserved.
//

import Foundation

class Message: NSObject {
    var fromId: String?
    var toId: String?
    var text: String?
    var timestamp: String?
    
    init(dictionary: [String: AnyObject]) {
        self.fromId = dictionary[FROM_ID] as? String
        self.toId = dictionary[TO_ID] as? String
        self.text = dictionary[TEXT] as? String
        self.timestamp = dictionary[TIMESTAMP] as? String
    }
}
 
