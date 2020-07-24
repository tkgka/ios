//
//  DatabaseManager.swift
//  ChatTest
//
//  Created by 김수환 on 2020/07/24.
//  Copyright © 2020 김수환. All rights reserved.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager{
    
    static let shared = DatabaseManager()
    
    private let database = Database.database().reference()
}
    // mark : Account Manangement
extension DatabaseManager{
        public func userExists(with Email: String, completion: @escaping((Bool)->Void)){
            
            var safeEmail = Email.replacingOccurrences(of: ".", with: "-")
            safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
            
            database.child(safeEmail).observeSingleEvent(of: .value, with: {snapshot in
                guard snapshot.value as? String != nil else{
                    completion(false)
                    return
                }
                completion(true)
            })
            
        }
    
        ///insert new user to database
    public func insertUser(with user: ChatAppUser){
        database.child(user.safeEmail).setValue([
            "firset_name":user.firstName,
            "last_name":user.lastName
        ])
        
    }
}
    
    
    
    
    
struct ChatAppUser {
    let firstName: String
    let lastName: String
    let emailAddress: String
    
    var safeEmail: String{

        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
}

