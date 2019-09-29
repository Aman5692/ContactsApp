//
//  NetworkUtility.swift
//  ContactsApp
//
//  Created by Aman Agarwal on 24/09/19.
//  Copyright © 2019 Aman Agarwal. All rights reserved.
//

import Foundation

enum NetworkUtilityError : Error {
    case badRequest
    case contactNotFound
    case networkFailure
    case serverError
    case serverReturnedNoFill
    case invalidData
}

let SERVER_ENDPOINT = "http://gojek-contacts-app.herokuapp.com/contacts.json"

public class NetworkUtility {
    
    private static func createPostRequest(contact : ContactDetailsModel, methodType : String) -> NSMutableURLRequest? {
        var request : NSMutableURLRequest? = nil
        if(!contact.validateModel()) {
            print("Invalid contact details, can't post on server")
            return request
        }
        guard let url = URL.init(string: SERVER_ENDPOINT) else {
            print("Invalid url string")
            return request
        }
        request = NSMutableURLRequest(url: url)
        request!.httpMethod = methodType
        request!.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            let jsonDictionary = contact.toDictionary()
            let jsonData = try JSONSerialization.data(withJSONObject: jsonDictionary, options: .init(rawValue: 0))
            request!.httpBody = jsonData
        } catch {
            print(error.localizedDescription)
        }
        return request
    }
    
    private static func createRequestWithUrl(urlString : String, methodType : String) -> NSMutableURLRequest? {
        var request : NSMutableURLRequest? = nil
        guard let url = URL.init(string: urlString) else {
            print("Invalid url string")
            return request
        }
        request = NSMutableURLRequest(url: url)
        request!.httpMethod = methodType
        request!.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
    
    private static func makeNetworkRequest(request : NSMutableURLRequest, handler: @escaping (Data?, NetworkUtilityError?) -> Void) {
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse else {
                handler(nil,NetworkUtilityError.networkFailure)
                return
            }
            if (httpResponse.statusCode >= 500) {
                handler(nil,NetworkUtilityError.serverError)
            } else if(httpResponse.statusCode >= 400) {
                if(httpResponse.statusCode == 404) {
                    handler(nil,NetworkUtilityError.contactNotFound)
                } else {
                    handler(nil,NetworkUtilityError.badRequest)
                }
            } else if(httpResponse.statusCode >= 300) {
                handler(nil,NetworkUtilityError.serverError)
            } else if(httpResponse.statusCode == 201 || httpResponse.statusCode == 200) {
                guard let responseData = data else {
                    print("URLSession dataTask error:", error ?? "nil")
                    handler(nil,NetworkUtilityError.serverReturnedNoFill)
                    return
                }
                handler(responseData,nil)
            } else {
                handler(nil,NetworkUtilityError.networkFailure)
            }
        }
        task.resume()
    }
    
    /**
     * Update contact to server
     */
    static func updateContactDetails(contact : ContactDetailsModel) -> Void {
        contact.firstName = "Aman"
        contact.phoneNumber = "+91 9953534853"
        guard let request = NetworkUtility.createPostRequest(contact: contact, methodType: "PUT") else {
            print("Invalid request, contact can not be posted to server")
            return
        }
        NetworkUtility.makeNetworkRequest(request: request, handler: { (data, error) in
            if(data != nil && error == nil) {
                print("Contact successfully updated on server")
            } else {
                print("Contact updatation on server failed with error : ", error ?? "nil")
            }
        })
    }
    
    /**
     * Add contact to server
     */
    static func addContactDetails(contact : ContactDetailsModel) -> Void {
        guard let request = NetworkUtility.createPostRequest(contact: contact, methodType: "POST") else {
            print("Invalid request, contact can not be posted to server")
            return
        }
        NetworkUtility.makeNetworkRequest(request: request, handler: { (data, error) in
            if(data != nil && error == nil) {
                print("Contact successfully saved to server")
            } else {
                print("Contact posting to server failed with error : ", error ?? "nil")
            }
        })
    }

    /**
     * Get contact details for URL
     */
    static func getContactDetails(urlString : String, handler: @escaping (ContactDetailsModel?, Error?) -> Void) {
        guard let request = NetworkUtility.createRequestWithUrl(urlString: urlString, methodType: "GET") else {
            print("Invalid request, contact can not be posted to server")
            return
        }
        NetworkUtility.makeNetworkRequest(request: request, handler: { (data, error) in
            if(data != nil && error == nil) {
                do {
                    guard let jsonDictionary = try JSONSerialization.jsonObject(with: data!) as? Dictionary<String, Any> else {
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
            } else {
                print("Invalid response received with error :", error ?? "nil")
            }
        })
    }

    /**
     * Get list of all contacts
     */
    static func getContactsList(handler: @escaping (Array<ContactListModel>?, Error?) -> Void) {
        guard let request = NetworkUtility.createRequestWithUrl(urlString: SERVER_ENDPOINT, methodType: "GET") else {
            print("Invalid request, contact can not be posted to server")
            return
        }
        NetworkUtility.makeNetworkRequest(request: request, handler: { (data, error) in
            if(data != nil && error == nil) {
                var contactsList : Array<ContactListModel> = []
                do {
                    guard let jsonList = try JSONSerialization.jsonObject(with: data!) as? [Any] else {
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
            } else {
                print("Invalid response received with error :", error ?? "nil")
            }
        })
    }
    
    static func downloadImageForURL(url: String, handler: @escaping (Data?,Error?) -> Void) {
        guard let request = NetworkUtility.createRequestWithUrl(urlString: url, methodType: "GET") else {
            print("Invalid request, contact can not be posted to server")
            return
        }
        NetworkUtility.makeNetworkRequest(request: request, handler: { (data, error) in
            if(data != nil && error == nil) {
                handler(data,nil)
            } else {
                handler(nil,NetworkUtilityError.invalidData)
            }
        })
    }
}


