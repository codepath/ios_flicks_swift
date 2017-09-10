//
//  MoviesTableViewController.swift
//  Flicks
//
//  Created by Soumya on 1/13/16.
//  Copyright © 2016 udaymitra. All rights reserved.
//

import UIKit
import SwiftyJSON
import MBProgressHUD

class MoviesTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,
UISearchResultsUpdating {
    
    @IBOutlet weak var moviesTableView: UITableView!
    
    var movies: [Movie]?
    var filteredMovies: [Movie]?
    var searchController: UISearchController!
    var uiRefreshControl : UIRefreshControl!
    @IBOutlet weak var errorView: UIView!
    var endpoint: String = "now_playing"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.title = "Flicks"
        
        moviesTableView.delegate = self;
        moviesTableView.dataSource = self;
        moviesTableView.backgroundColor = UIColor.flk_appThemeColor()
        
        // add refresh control
        uiRefreshControl = UIRefreshControl()
        uiRefreshControl.addTarget(self, action: #selector(MoviesTableViewController.refresh(_:)), for: UIControlEvents.valueChanged)
        let refreshTitleAttr = [NSForegroundColorAttributeName: UIColor.black]
        uiRefreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh", attributes:refreshTitleAttr)
        uiRefreshControl.backgroundColor = UIColor.flk_appThemeColor()
        uiRefreshControl.tintColor = UIColor.flk_appThemeColor()
        moviesTableView.addSubview(uiRefreshControl)
        
        // set up for search bar
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.sizeToFit()
        searchController.dimsBackgroundDuringPresentation = false
  
        moviesTableView.tableHeaderView = searchController.searchBar
        navigationItem.titleView = searchController.searchBar
        searchController.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
        
        loadData()
    }
    
    func refresh(_ sender:AnyObject)
    {
        loadData()
        self.uiRefreshControl.endRefreshing()
    }
    
    func loadData() {
        let spinningActivity = MBProgressHUD.showAdded(to: self.view, animated: true)
        spinningActivity?.labelText = "Loading movies..."
        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = URL(string:"https://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(apiKey)")
        let request = URLRequest(url: url!)
        let session = URLSession(
            configuration: URLSessionConfiguration.default,
            delegate:nil,
            delegateQueue:OperationQueue.main
        )
        
        let task : URLSessionDataTask = session.dataTask(with: request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    self.movies = Movie.getMovies(JSON(data : data))
                    self.filteredMovies = self.movies
                    self.errorView.isHidden = true
                    
                    // reload view with new data
                    self.moviesTableView.reloadData()
                } else {
                    self.errorView.isHidden = false
                    if let e = error {
                        NSLog("Error: \(e)")
                    }
                }
                // stop spinning activity
                spinningActivity?.hide(true)
        });
        task.resume()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let movies = self.filteredMovies {
            return movies.count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = moviesTableView.dequeueReusableCell(withIdentifier: "MovieTableViewCell", for: indexPath) as! MovieTableViewCell
        
        let movie = filteredMovies![indexPath.row]
        cell.movie = movie
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        moviesTableView.deselectRow(at: indexPath, animated: true)
    }
        
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filteredMovies = searchText.isEmpty ? movies : movies?.filter({ (movie:Movie) -> Bool in
                movie.title.range(of: searchText, options: .caseInsensitive) != nil
            });
            moviesTableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let movieCell = sender as! MovieTableViewCell
        let selectedMovieIndexPath = moviesTableView.indexPath(for: movieCell)
        
        let movie = filteredMovies![selectedMovieIndexPath!.row]
        let detailVC = segue.destination as! MoviesTableDetailViewController
        detailVC.movie = movie
    }
}
