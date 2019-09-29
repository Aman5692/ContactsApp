//
//  ImageCacheUtility.swift
//  ContactsApp
//
//  Created by Aman Agarwal on 29/09/19.
//  Copyright © 2019 Aman Agarwal. All rights reserved.
//

import UIKit

class ImageCacheUtility: NSObject {

    static let imageCache = NSCache<NSString, UIImage>()
    
    
    static func downloadImage(url: String, handler: @escaping (_ image: UIImage?, _ error: Error? ) -> Void) {
        if let cachedImage = imageCache.object(forKey: url as NSString) {
            handler(cachedImage, nil)
        } else {
            NetworkUtility.downloadImageForURL(url: url, handler: { (data, error) in
                if let error = error {
                    handler(nil, error)
                } else if let data = data, let image = UIImage(data: data) {
                    imageCache.setObject(image, forKey: url as NSString)
                    handler(image, nil)
                } else {
                    handler(nil, NSError.init(domain: "ImageCacheUtility", code: 100, userInfo: nil))
                }
            })
        }
    }
}
