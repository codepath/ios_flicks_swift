//
//  MoviesViewController.swift
//  Flicks
//
//  Created by Soumya on 1/13/16.
//  Copyright © 2016 udaymitra. All rights reserved.
//

import UIKit
import SwiftyJSON
import MBProgressHUD

class MoviesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate,
    UISearchResultsUpdating {
    
    @IBOutlet weak var moviesCollectionView: UICollectionView!
    
    var movies: [Movie]?
    var filteredMovies: [Movie]?
    var searchController: UISearchController!
    var uiRefreshControl : UIRefreshControl!
    @IBOutlet weak var errorView: UIView!
    var endpoint : String! = "now_playing"
    var lastSelectedCell : MovieCollectionViewCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        moviesCollectionView.delegate = self;
        moviesCollectionView.dataSource = self;
        
        // add refresh control
        uiRefreshControl = UIRefreshControl()
        uiRefreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        moviesCollectionView.addSubview(uiRefreshControl)
        
        // set up for search bar
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.searchBar.sizeToFit()
        
        navigationItem.titleView = searchController.searchBar
        searchController.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
        
        loadData()
    }
    
    func refresh(sender:AnyObject)
    {
        self.uiRefreshControl.endRefreshing()
        loadData()
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
                    self.moviesCollectionView.reloadData()
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
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {indexPath
        let cell = moviesCollectionView.dequeueReusableCellWithReuseIdentifier("MovieCollectionViewCell", forIndexPath: indexPath) as! MovieCollectionViewCell
        
        let movie = filteredMovies![indexPath.row]
        cell.movie = movie
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredMovies?.count ?? 0;
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = moviesCollectionView.cellForItemAtIndexPath(indexPath) as! MovieCollectionViewCell
        lastSelectedCell?.deselectCell()
        cell.selectCell()
        lastSelectedCell = cell
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filteredMovies = searchText.isEmpty ? movies : movies?.filter({ (movie:Movie) -> Bool in
                movie.title.rangeOfString(searchText, options: .CaseInsensitiveSearch) != nil
            });
            moviesCollectionView.reloadData()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let movieCell = sender as! MovieCollectionViewCell
        let selectedMovieIndexPath = moviesCollectionView.indexPathForCell(movieCell)
        
        let movie = filteredMovies![selectedMovieIndexPath!.row]
        let detailVC = segue.destinationViewController as! DetailViewController
        detailVC.movie = movie
    }
}
