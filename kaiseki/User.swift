//
//  User.swift
//  kaiseki
//
//  Created by Ed Chao on 4/15/17.
//  Copyright © 2017 Ed Chao. All rights reserved.
//

import Foundation
import FirebaseAuth

struct User {
    
    // MODEL ATTRIBUTES
    
    let uid:String
    let email:String?
    
    // INITIALIZING USER WITH FIREBASE DATA
    
    init(userData:User){
        uid = userData.uid
        
        if let mail = userData.email{
            email = mail
        }else {
            email = ""
        }
        
        
    }
    
    // INITIALIZING USER WITH ARBITRARY DATA
    
    init(uid:String, email:String){
        self.uid = uid
        self.email = email
    }
}
