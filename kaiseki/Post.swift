//
//  Post.swift
//  kaiseki
//
//  Created by Ed Chao on 4/15/17.
//  Copyright © 2017 Ed Chao. All rights reserved.
//


import Foundation
import FirebaseDatabase


struct Post {
    
    // DECLARE ATTRIBUTES
    
    let key:String!
    let content:String!
    let addedByUser:String!
    let addedToThread:String!
    let itemRef:FIRDatabaseReference?
    
    
    // INITIALIZE POST WITH ARBITRARY DATA
    
    init(content:String, addedByUser:String, addedToThread:String, key:String = ""){
        self.key = key
        self.content = content
        self.addedByUser = addedByUser
        self.addedToThread = addedToThread
        self.itemRef = nil
    }
    
    // INITIALIZE POST WITH FIREBASE DATA
    // ---
    // Firebase data is packaged in a snapshot
    
    init(snapshot:FIRDataSnapshot){
        key = snapshot.key
        itemRef = snapshot.ref
        addedToThread = ""
        
        // Firebase snapshots are in json so we have to convert it to a dictionary to access it
    
        
        if let postDict = snapshot.value as? NSDictionary, let postContent = postDict["content"] as? String {
            content = postContent
        }else {
            content = ""
        }
        
        if let userDict = snapshot.value as? NSDictionary, let postUser = userDict["addedByUser"] as? String {
            addedByUser = postUser
        }else {
            addedByUser = ""
        }
        
        
    }
    
    // RETURN THE DICTIONARY
    
    func toAny() -> Any {
        return ["content":content, "addedByUser":addedByUser, "addedToThread":addedToThread]
    }
}
