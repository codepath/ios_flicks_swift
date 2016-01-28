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
    var endpoint : String! = "now_playing"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.title = "Flicks"
        
        moviesTableView.delegate = self;
        moviesTableView.dataSource = self;
        moviesTableView.backgroundColor = UIColor.flk_appThemeColor()
        
        // add refresh control
        uiRefreshControl = UIRefreshControl()
        uiRefreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        let refreshTitleAttr = [NSForegroundColorAttributeName: UIColor.blackColor()]
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
    
    func refresh(sender:AnyObject)
    {
        loadData()
        self.uiRefreshControl.endRefreshing()
    }
    
    func loadData() {
        let spinningActivity = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        spinningActivity.labelText = "Loading movies..."
        
        let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
        let url = NSURL(string:"https://api.themoviedb.org/3/movie/\(endpoint)?api_key=\(apiKey)")
        let request = NSURLRequest(URL: url!)
        let session = NSURLSession(
            configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
            delegate:nil,
            delegateQueue:NSOperationQueue.mainQueue()
        )
        
        let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
            completionHandler: { (dataOrNil, response, error) in
                if let data = dataOrNil {
                    self.movies = Movie.getMovies(JSON(data : data))
                    self.filteredMovies = self.movies
                    self.errorView.hidden = true
                    
                    // reload view with new data
                    self.moviesTableView.reloadData()
                } else {
                    self.errorView.hidden = false
                    if let e = error {
                        NSLog("Error: \(e)")
                    }
                }
                // stop spinning activity
                spinningActivity.hide(true)
        });
        task.resume()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let movies = self.filteredMovies {
            return movies.count
        }else{
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = moviesTableView.dequeueReusableCellWithIdentifier("MovieTableViewCell", forIndexPath: indexPath) as! MovieTableViewCell
        
        let movie = filteredMovies![indexPath.row]
        cell.movie = movie
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        moviesTableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
        
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filteredMovies = searchText.isEmpty ? movies : movies?.filter({ (movie:Movie) -> Bool in
                movie.title.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil
            });
            moviesTableView.reloadData()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let movieCell = sender as! MovieTableViewCell
        let selectedMovieIndexPath = moviesTableView.indexPathForCell(movieCell)
        
        let movie = filteredMovies![selectedMovieIndexPath!.row]
        let detailVC = segue.destinationViewController as! MoviesTableDetailViewController
        detailVC.movie = movie
    }
}
