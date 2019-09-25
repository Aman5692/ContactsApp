//
//  ContactModel.swift
//  ContactsApp
//
//  Created by Aman Agarwal on 25/09/19.
//  Copyright © 2019 Aman Agarwal. All rights reserved.
//

import Foundation

class ContactListModel {
    
    var id : Int = 0
    var firstName : String = ""
    var lastName : String = ""
    var profilePic : String = ""
    var favorite : Bool = false
    var url : String = ""
    
    init?(data : Dictionary<String, Any>) {
        if let value = data["id"] as? Int {
            id = value
        }
        if let value = data["first_name"] as? String {
            firstName = value
        }
        if let value = data["last_name"] as? String {
            lastName = value
        }
        if let value = data["profile_pic"] as? String {
            profilePic = value
        }
        if let value = data["favorite"] as? Bool {
            favorite = value
        }
        if let value = data["url"] as? String {
            url = value
        }
        if(!validateModel()){
            return nil
        }
    }
    
    func validateModel() -> Bool {
        guard id > 0 else {
            return false
        }
        guard !firstName.isEmpty else {
            return false
        }
        guard !lastName.isEmpty else {
            return false
        }
        guard !profilePic.isEmpty else {
            return false
        }
        guard !url.isEmpty else {
            return false
        }
        return true
    }
}


