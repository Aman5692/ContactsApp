//
//  ContactDetailsModel.swift
//  ContactsApp
//
//  Created by Aman Agarwal on 25/09/19.
//  Copyright © 2019 Aman Agarwal. All rights reserved.
//

import Foundation

class ContactDetailsModel {
    
    var id : Int = 0
    var firstName : String = ""
    var lastName : String = ""
    var profilePic : String = ""
    var favorite : Bool = false
    var phoneNumber : String = ""
    var email : String = ""
    
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
        if let value = data["phone_number"] as? String {
            phoneNumber = value
        }
        if let value = data["email"] as? String {
            email = value
        }
        if(!validateModel()){
            return nil
        }
    }
    
    func validateModel() -> Bool {
        guard !firstName.isEmpty else {
            return false
        }
        return true
    }
    
    func toDictionary() -> Dictionary<String, Any> {
        var dictionary = Dictionary<String, Any>.init()
        if(self.id > 0) {
            dictionary["id"] = self.id
        }
        dictionary["first_name"] = self.firstName
        dictionary["last_name"] = self.lastName
        dictionary["email"] = self.email
        dictionary["phone_number"] = self.phoneNumber
        dictionary["favorite"] = self.favorite
        if(!self.profilePic.isEmpty) {
            dictionary["profile_pic"] = self.profilePic
        }
        print("Contact Dictionary : ", dictionary.description)
        return dictionary
    }
    
    func toString() -> String {
        do{
            let dictionary = self.toDictionary()
            let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
            return jsonData.description
        } catch {
            print(error.localizedDescription)
            return ""
        }
    }
}
