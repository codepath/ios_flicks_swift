//
//  MovieCollectionViewCell.swift
//  Flicks
//
//  Created by Soumya on 1/23/16.
//  Copyright © 2016 udaymitra. All rights reserved.
//

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var overlayView: UIView!
    
    var movie: Movie! {
        didSet {
            overlayView.isHidden = true
            overlayView.backgroundColor = UIColor.flk_appThemeColor()
            if let posterUrl = movie.posterUrl {
                posterImageView.contentMode = UIViewContentMode.scaleAspectFill
                posterImageView.fadeInImageFromUrl(posterUrl, placeholderImage: nil, fadeInDuration: 0.5)
            }
        }
    }

    func selectCell() {
        overlayView.isHidden = false
    }
    
    func deselectCell() {
        overlayView.isHidden = true
    }
}
