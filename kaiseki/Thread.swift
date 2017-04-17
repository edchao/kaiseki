//
//  Thread.swift
//  kaiseki
//
//  Created by Ed Chao on 4/16/17.
//  Copyright © 2017 Ed Chao. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct Thread {
    
    // DECLARE ATTRIBUTES
    
    let key:String!
    let content:String!
    let addedByUser:String!
    let itemRef:FIRDatabaseReference?
    
    
    // INITIALIZE THREAD WITH ARBITRARY DATA
    
    init(content:String, addedByUser:String, key:String = ""){
        self.key = key
        self.content = content
        self.addedByUser = addedByUser
        self.itemRef = nil
    }
    
    // INITIALIZE THREAD WITH FIREBASE DATA
    // ---
    // Firebase data is packaged in a snapshot
    
    init(snapshot:FIRDataSnapshot){
        key = snapshot.key
        itemRef = snapshot.ref
        
        // Firebase snapshots are in json so we have to convert it to a dictionary to access it
        
        if let threadDict = snapshot.value as? NSDictionary, let threadContent = threadDict["content"] as? String {
            content = threadContent
        }else {
            content = ""
        }
        
        if let userDict = snapshot.value as? NSDictionary, let threadUser = userDict["addedByUser"] as? String {
            addedByUser = threadUser
        }else {
            addedByUser = ""
        }
    }
    
    // RETURN THE DICTIONARY
    
    func toAny() -> Any {
        return ["content":content, "addedByUser":addedByUser]
    }
}
