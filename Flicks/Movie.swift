//
//  Movie.swift
//  Flicks
//
//  Created by Soumya on 1/14/16.
//  Copyright © 2016 udaymitra. All rights reserved.
//

import UIKit
import SwiftyJSON

class Movie: NSObject {
    let POSTER_BASE_URL = "https://image.tmdb.org/t/p/w500"

    var title : String
    var overview : String
    var posterPath : String?
    var posterUrl : NSURL? {
        get {
            return posterPath.map({ (path: String) -> NSURL in
                NSURL(string: POSTER_BASE_URL + path)!
            })
        }
    }
    
    init(overview: String, title: String, posterPath: String?) {
        self.overview = overview
        self.title = title
        self.posterPath = posterPath
    }
    
    class func getMovies(json: JSON) -> [Movie] {
        var movies = [Movie]()
        if let movieArray = json["results"].array {
            for movie in movieArray {
                let title = movie["title"].string!
                let overview = movie["overview"].string!
                let posterPath = movie["poster_path"].string
                movies.append(Movie(overview: overview, title: title, posterPath: posterPath));
            }
        }
        return movies
    }
}
