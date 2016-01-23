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
    
    // ISSUE: images fade in even if they are coming from cache
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
    
}
