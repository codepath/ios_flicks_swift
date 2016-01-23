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
    
    var movie: Movie! {
        didSet {
            if let posterUrl = movie.posterUrl {
                posterImageView.contentMode = UIViewContentMode.ScaleAspectFill
                posterImageView.fadeInImageFromUrl(posterUrl, placeholderImage: nil, fadeInDuration: 0.5)
            }
        }
    }    
}
