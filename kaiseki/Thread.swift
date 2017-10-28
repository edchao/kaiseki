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
    let primaryContent:String!
    let secondaryContent: String!
    let tertiaryContent: String!
    let quaternaryContent: String!
    let addedByUser:String!
    let itemRef:FIRDatabaseReference?
    
    
    // INITIALIZE THREAD WITH ARBITRARY DATA
    
    init(primaryContent:String, secondaryContent: String, tertiaryContent: String, quaternaryContent:String, addedByUser:String, key:String = ""){
        self.key = key
        self.primaryContent = primaryContent
        self.secondaryContent = secondaryContent
        self.tertiaryContent = tertiaryContent
        self.quaternaryContent = quaternaryContent
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
        
//        if let threadDict = snapshot.value as? NSDictionary, let threadPrimaryContent = threadDict["primaryContent"] as? String, let threadSecondaryContent = threadDict["secondaryContent"] as? String, let threadTertiaryContent = threadDict["threadTertiaryContent"] as? String {
//            primaryContent = threadPrimaryContent
//            secondaryContent = threadSecondaryContent
//            tertiaryContent = threadTertiaryContent
//        }else {
//            primaryContent = ""
//            secondaryContent = ""
//            tertiaryContent = ""
//        }
        
        if let threadDict = snapshot.value as? NSDictionary, let threadPrimaryContent = threadDict["primaryContent"] as? String {
            primaryContent = threadPrimaryContent
        }else{
            primaryContent = ""
        }
        
        if let threadDict = snapshot.value as? NSDictionary, let threadSecondaryContent = threadDict["secondaryContent"] as? String {
            secondaryContent = threadSecondaryContent
        }else{
            secondaryContent = ""
        }
        
        if let threadDict = snapshot.value as? NSDictionary, let threadTertiaryContent = threadDict["tertiaryContent"] as? String {
            tertiaryContent = threadTertiaryContent
        }else{
            tertiaryContent = ""
        }
        
        if let threadDict = snapshot.value as? NSDictionary, let threadQuaternaryContent = threadDict["quaternaryContent"] as? String {
            quaternaryContent = threadQuaternaryContent
        }else{
            quaternaryContent = ""
        }
        
        if let userDict = snapshot.value as? NSDictionary, let threadUser = userDict["addedByUser"] as? String {
            addedByUser = threadUser
        }else {
            addedByUser = ""
        }
    }
    
    // RETURN THE DICTIONARY
    
    func toAny() -> Any {
        return ["primaryContent":primaryContent, "secondaryContent":secondaryContent, "tertiaryContent":tertiaryContent, "quaternaryContent":quaternaryContent, "addedByUser":addedByUser]
    }
}
