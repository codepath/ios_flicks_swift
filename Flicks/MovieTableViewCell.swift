//
//  MovieTableViewCell.swift
//  Flicks
//
//  Created by Soumya on 1/13/16.
//  Copyright © 2016 udaymitra. All rights reserved.
//

import UIKit
import AFNetworking

class MovieTableViewCell: UITableViewCell {
    @IBOutlet weak var movieLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var overlayView: UIView!
    
    var movie: Movie! {
        didSet {
            overlayView.backgroundColor = UIColor.flk_cellThemeColor()
            movieLabel.text = movie.title
            overviewLabel.text = movie.overview
            if let posterUrl = movie.posterUrl {
                posterImageView.setImageWith(posterUrl as URL)
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
