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
            overlayView.hidden = true
            if let posterUrl = movie.posterUrl {
                posterImageView.contentMode = UIViewContentMode.ScaleAspectFill
                posterImageView.fadeInImageFromUrl(posterUrl, placeholderImage: nil, fadeInDuration: 0.5)
            }
        }
    }

    func selectCell() {
        overlayView.hidden = false
    }
    
    func deselectCell() {
        overlayView.hidden = true
    }
}
