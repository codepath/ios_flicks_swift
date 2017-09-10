//
//  UIImageViewExtensions.swift
//  RottenTomatoes
//
//  Created by Soumya on 9/20/15.
//  Copyright © 2015 udaymitra. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    
    func fadeInImageFromUrl(_ url: URL, placeholderImage: UIImage?, fadeInDuration: TimeInterval) {
        let request = URLRequest(url: url)
        self.setImageWith(
            request,
            placeholderImage: placeholderImage,
            success: { (req, response, image) -> Void in
                self.image = image
                self.alpha = 0
                UIView.animate(withDuration: fadeInDuration, animations: { () -> Void in
                    self.alpha = 1
                })
            },
            failure: nil)
    }
    
    
    func loadLowResImageAndSwapToHiRes(_ lowResImageUrl: URL, hiResImageUrl: URL) {
        let smallImageRequest = URLRequest(url: lowResImageUrl)
        let largeImageRequest = URLRequest(url: hiResImageUrl)
        
        self.setImageWith(
            smallImageRequest,
            placeholderImage: nil,
            success: { (smallImageRequest, smallImageResponse, smallImage) -> Void in
                self.alpha = 0.0
                self.image = smallImage;
                
                UIView.animate(withDuration: 0.3, animations: { () -> Void in
                    self.alpha = 1.0
                    }, completion: { (sucess) -> Void in
                        self.setImageWith(
                            largeImageRequest,
                            placeholderImage: smallImage,
                            success: { (largeImageRequest, largeImageResponse, largeImage) -> Void in
                                self.image = largeImage;
                            },
                            failure: { (request, response, error) -> Void in
                        })
                })
            },
            failure: { (request, response, error) -> Void in
        })
        
    }
    
}
