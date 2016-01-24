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

    var title : String
    var overview : String
    var posterPath : String?
    var popularity : Float
    var posterUrl : NSURL? {
        get {
            return posterPath.map({ (path: String) -> NSURL in
                NSURL(string: POSTER_BASE_URL + path)!
            })
        }
    }
    var lowResPosterUrl : NSURL? {
        get {
            return posterPath.map({ (path: String) -> NSURL in
                NSURL(string: LOW_RES_POSTER_BASE_URL + path)!
            })
        }
    }
    var hiResPosterUrl : NSURL? {
        get {
            return posterPath.map({ (path: String) -> NSURL in
                NSURL(string: HI_RES_POSTER_BASE_URL + path)!
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
    
    init(id: Int, overview: String, title: String, posterPath: String?, popularity: Float) {
        self.id = id
        self.overview = overview
        self.title = title
        self.posterPath = posterPath
        self.popularity = popularity
    }
    
    class func getMovies(json: JSON) -> [Movie] {
        var movies = [Movie]()
        if let movieArray = json["results"].array {
            for movie in movieArray {
                let title = movie["title"].string!
                let overview = movie["overview"].string!
                let posterPath = movie["poster_path"].string
                let popularity = movie["popularity"].float!
                let id = movie["id"].int!
                
                movies.append(Movie(id: id, overview: overview, title: title, posterPath: posterPath, popularity: popularity));
            }
        }
        return movies
    }
}
