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
    
    func fadeInImageFromUrl(url: NSURL, placeholderImage: UIImage?, fadeInDuration: NSTimeInterval) {
        let request = NSURLRequest(URL: url)
        self.setImageWithURLRequest(
            request,
            placeholderImage: placeholderImage,
            success: { (req, response, image) -> Void in
                self.image = image
                self.alpha = 0
                UIView.animateWithDuration(fadeInDuration, animations: { () -> Void in
                    self.alpha = 1
                })
            },
            failure: nil)
    }
    
    
    func loadLowResImageAndSwapToHiRes(lowResImageUrl: NSURL, hiResImageUrl: NSURL) {
        let smallImageRequest = NSURLRequest(URL: lowResImageUrl)
        let largeImageRequest = NSURLRequest(URL: hiResImageUrl)
        
        self.setImageWithURLRequest(
            smallImageRequest,
            placeholderImage: nil,
            success: { (smallImageRequest, smallImageResponse, smallImage) -> Void in
                self.alpha = 0.0
                self.image = smallImage;
                
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.alpha = 1.0
                    }, completion: { (sucess) -> Void in
                        self.setImageWithURLRequest(
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
