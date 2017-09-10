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
        uiRefreshControl.addTarget(self, action: #selector(MoviesViewController.refresh(_:)), for: UIControlEvents.valueChanged)
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
    
    func refresh(_ sender:AnyObject)
    {
        self.uiRefreshControl.endRefreshing()
        loadData()
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
                    self.moviesCollectionView.reloadData()
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
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {indexPath
        let cell = moviesCollectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as! MovieCollectionViewCell
        
        let movie = filteredMovies![indexPath.row]
        cell.movie = movie
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredMovies?.count ?? 0;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = moviesCollectionView.cellForItem(at: indexPath) as! MovieCollectionViewCell
        lastSelectedCell?.deselectCell()
        cell.selectCell()
        lastSelectedCell = cell
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filteredMovies = searchText.isEmpty ? movies : movies?.filter({ (movie:Movie) -> Bool in
                movie.title.range(of: searchText, options: .caseInsensitive) != nil
            });
            moviesCollectionView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let movieCell = sender as! MovieCollectionViewCell
        let selectedMovieIndexPath = moviesCollectionView.indexPath(for: movieCell)
        
        let movie = filteredMovies![selectedMovieIndexPath!.row]
        let detailVC = segue.destination as! DetailViewController
        detailVC.movie = movie
    }
}
