//
//  NetworkUtility.swift
//  ContactsApp
//
//  Created by Aman Agarwal on 24/09/19.
//  Copyright © 2019 Aman Agarwal. All rights reserved.
//

import Foundation

enum NetworkUtilityError : Error {
    case inValidRequestUrl
    case networkFailure
    case serverError
    case serverReturnedNoFill
    case invalidData
}

let SERVER_ENDPOINT_CONTACT_LIST = "http://gojek-contacts-app.herokuapp.com/contacts.json"


/**
 * Get contact details for URL
 */
func getContactDetails(urlString : String, handler: @escaping (ContactDetailsModel?, Error?) -> Void) {
    guard let url = URL.init(string: urlString) else {
        handler(nil,NetworkUtilityError.inValidRequestUrl)
        return
    }
    let request = NSMutableURLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let session = URLSession.shared
       
    let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
        let httpResponse = response as? HTTPURLResponse
        if (httpResponse?.statusCode == 500) {
            handler(nil,NetworkUtilityError.serverError)
        } else if(httpResponse?.statusCode != 200) {
            handler(nil,NetworkUtilityError.networkFailure)
        } else {
            guard let responseData = data else {
                print("URLSession dataTask error:", error ?? "nil")
                handler(nil,NetworkUtilityError.serverReturnedNoFill)
                return
            }
            do {
                guard let jsonDictionary = try JSONSerialization.jsonObject(with: responseData) as? Dictionary<String, Any> else {
                    print("Invalid response, expected response was a dictionary")
                    handler(nil,NetworkUtilityError.invalidData)
                    return
                }
                guard let contact = ContactDetailsModel.init(data: jsonDictionary) else {
                    print("Invalid dictioanry, model can't be created")
                    handler(nil,NetworkUtilityError.invalidData)
                    return
                }
                handler(contact,nil)
            } catch {
                print("JSONSerialization error:", error)
                handler(nil,NetworkUtilityError.invalidData)
            }
        }
    }
    task.resume()
}

/**
 * Get list of all contacts
 */
func getContactsList(handler: @escaping (Array<ContactListModel>?, Error?) -> Void) {
    guard let url = URL.init(string: SERVER_ENDPOINT_CONTACT_LIST) else {
        handler(nil,NetworkUtilityError.inValidRequestUrl)
        return
    }
    let request = NSMutableURLRequest(url: url)
    request.httpMethod = "GET"
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    
    let session = URLSession.shared
    
    let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
        let httpResponse = response as? HTTPURLResponse
        if (httpResponse?.statusCode == 500) {
            handler(nil,NetworkUtilityError.serverError)
        } else if(httpResponse?.statusCode != 200) {
            handler(nil,NetworkUtilityError.networkFailure)
        } else {
            guard let responseData = data else {
                print("URLSession dataTask error:", error ?? "nil")
                handler(nil,NetworkUtilityError.serverReturnedNoFill)
                return
            }
            var contactsList : Array<ContactListModel> = []
            do {
                guard let jsonList = try JSONSerialization.jsonObject(with: responseData) as? [Any] else {
                    print("Invalid response, expected response was an array")
                    handler(nil,NetworkUtilityError.invalidData)
                    return
                }
                
                for dictionary in jsonList {
                    if let model = ContactListModel.init(data: dictionary as! Dictionary<String, Any>) {
                        contactsList.append(model)
                    } else {
                        print("Invalid dictioanry, model can't be created")
                        handler(nil,NetworkUtilityError.invalidData)
                        return
                    }
                }
                handler(contactsList,nil)
            } catch {
                print("JSONSerialization error:", error)
                handler(nil,NetworkUtilityError.invalidData)
            }
        }
    }
    task.resume()
}


