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
    let POSTER_BASE_URL = "https://image.tmdb.org/t/p/w342"
    let HI_RES_POSTER_BASE_URL = "https://image.tmdb.org/t/p/original"
    let LOW_RES_POSTER_BASE_URL = "https://image.tmdb.org/t/p/w45"

    fileprivate(set) var title : String
    fileprivate(set) var overview : String
    fileprivate(set) var posterPath : String?
    fileprivate(set) var popularity : Float
    var posterUrl : URL? {
        get {
            return posterPath.map({ (path: String) -> URL in
                URL(string: POSTER_BASE_URL + path)!
            })
        }
    }
    var lowResPosterUrl : URL? {
        get {
            return posterPath.map({ (path: String) -> URL in
                URL(string: LOW_RES_POSTER_BASE_URL + path)!
            })
        }
    }
    var hiResPosterUrl : URL? {
        get {
            return posterPath.map({ (path: String) -> URL in
                URL(string: HI_RES_POSTER_BASE_URL + path)!
            })
        }
    }
    var popularityString : String {
        get {
            let popularityInt = (Int) (self.popularity)
            return "\(popularityInt)%"
        }
    }
    var id : Int
    
    fileprivate var releaseDateString : String
    var releaseDate: Date? {
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            return dateFormatter.date(from: releaseDateString)
        }
    }
    
    init(id: Int, overview: String, title: String, posterPath: String?, popularity: Float, releaseDateString: String) {
        self.id = id
        self.overview = overview
        self.title = title
        self.posterPath = posterPath
        self.popularity = popularity
        self.releaseDateString = releaseDateString
    }
    
    class func getMovies(_ json: JSON) -> [Movie] {
        var movies = [Movie]()
        if let movieArray = json["results"].array {
            for movie in movieArray {
                let title = movie["title"].string!
                let overview = movie["overview"].string!
                let posterPath = movie["poster_path"].string
                let popularity = movie["popularity"].float!
                let id = movie["id"].int!
                let releaseDateString = movie["release_date"].string!
                
                movies.append(Movie(id: id, overview: overview, title: title, posterPath: posterPath, popularity: popularity, releaseDateString: releaseDateString));
            }
        }
        return movies
    }
}
