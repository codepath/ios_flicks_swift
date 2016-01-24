//
//  DetailViewController.swift
//  Flicks
//
//  Created by Soumya on 1/23/16.
//  Copyright © 2016 udaymitra. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var posterImageView: UIImageView!
    
    var movie: Movie?
    @IBOutlet weak var movieInfoView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var popularityPercentLabel: UILabel!
    @IBOutlet weak var runtimeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollView.contentSize = CGSize(width: scrollView.frame.size.width, height: movieInfoView.frame.origin.y + movieInfoView.frame.size.height)
        
        if let posterUrl = movie?.lowResPosterUrl {
            posterImageView.contentMode = UIViewContentMode.ScaleAspectFill
            posterImageView.loadLowResImageAndSwapToHiRes(posterUrl, hiResImageUrl: movie!.hiResPosterUrl!)
        }
        
        if let movie = movie {
            self.titleLabel.text = movie.title
            self.overviewLabel.text = movie.overview
            self.overviewLabel.sizeToFit()
            self.popularityPercentLabel.text = movie.popularityString
            self.runtimeLabel.text = movie.popularityString
            populateAdditionalMovieDetails()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func populateAdditionalMovieDetails() {
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string:"https://api.themoviedb.org/3/movie/\(self.movie!.id)?api_key=\(apiKey)")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                        data, options:[]) as? NSDictionary {
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
