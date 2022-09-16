//
//  User.swift
//  Race_Game
//
//  Created by Nikita Pishchugin on 12.07.2022.
//

import UIKit

class User {
    static let singleton = User(userName: "")
    
    var userName: String
    
    private init(userName: String) {
        self.userName = userName
    }
}
