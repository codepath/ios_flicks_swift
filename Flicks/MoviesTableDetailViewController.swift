//
//  MoviesTableDetailViewController.swift
//  Flicks
//
//  Created by Sumeet Shendrikar on 1/27/16.
//  Copyright © 2016 udaymitra. All rights reserved.
//

import Foundation

//
//  MoviesTableDetailViewController.swift
//  Flicks
//
//  Created by Soumya on 1/23/16.
//  Copyright © 2016 udaymitra. All rights reserved.
//

import UIKit

class MoviesTableDetailViewController: UIViewController {
    @IBOutlet weak var posterImageView: UIImageView!
    
    var movie: Movie?
    @IBOutlet weak var movieInfoView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var popularityPercentLabel: UILabel!
    @IBOutlet weak var runtimeLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: movieInfoView.frame.origin.y + movieInfoView.frame.size.height)
        
        if let posterUrl = movie?.lowResPosterUrl {
            posterImageView.contentMode = UIViewContentMode.scaleAspectFill
            posterImageView.loadLowResImageAndSwapToHiRes(posterUrl, hiResImageUrl: movie!.hiResPosterUrl!)
        }
        
        if let movie = movie {
            self.titleLabel.text = movie.title
            self.overviewLabel.text = movie.overview
            self.overviewLabel.sizeToFit()
            self.popularityPercentLabel.text = movie.popularityString
            self.runtimeLabel.text = "N/A"

            
            if let date = movie.releaseDate {
                let dayTimePeriodFormatter = DateFormatter()
                dayTimePeriodFormatter.dateFormat = "MMMM dd, yyyy"
                releaseDateLabel.text = dayTimePeriodFormatter.string(from: date as Date)
            }else{
                releaseDateLabel.text = ""
            }

            
            populateAdditionalMovieDetails()
            
            let newSynSize  = self.overviewLabel.sizeThatFits(CGSize(width: self.overviewLabel.frame.size.width, height: CGFloat.greatestFiniteMagnitude))
            var newSynFrame = self.overviewLabel.frame
            newSynFrame.size.height = newSynSize.height
            
            
            // adjust the container view inside the scroll view
            let newContainerHeight = min(self.movieInfoView.frame.height, newSynFrame.origin.y + newSynFrame.size.height)
            self.movieInfoView.frame.size = CGSize(width: self.movieInfoView.frame.width, height: newContainerHeight+50)
            
            // adjust the labels
            overviewLabel.frame = newSynFrame
            
            // set the scroll height
            let contentWidth = self.scrollView.bounds.width
            let contentHeight = self.movieInfoView.frame.origin.y + self.movieInfoView.frame.height // some fudge factor
            self.scrollView.contentSize = CGSize(width: contentWidth, height: contentHeight)
            
            self.scrollView.layoutIfNeeded()

        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func populateAdditionalMovieDetails() {
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string:"https://api.themoviedb.org/3/movie/\(self.movie!.id)?api_key=\(apiKey)")
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        let task : URLSessionDataTask = session.dataTask(with: request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! JSONSerialization.jsonObject(
                        with: data, options:[]) as? NSDictionary {
                            let runtime = responseDictionary["runtime"] as! Int
                            let hours = runtime / 60;
                            let min = runtime % 60;
                            let timeString = "\(hours) hr \(min) mins"
                            self.runtimeLabel.text = timeString
                    }
                }
        });
        task.resume()
        
    }
    
    
}
