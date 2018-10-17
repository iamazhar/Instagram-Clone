//
//  Post.swift
//  InstagramFirebase
//
//  Created by Azhar Anwar on 15/10/18.
//  Copyright © 2018 Azhar Anwar. All rights reserved.
//

import Foundation

struct Post {
    
    let user: User
    let imageUrl: String
    let caption: String
    
    init(user: User, dictionary: [String: Any]) {
        self.user = user
        self.imageUrl = dictionary["imageUrl"] as? String ?? ""
        self.caption = dictionary["caption"] as? String ?? ""
    }
}
