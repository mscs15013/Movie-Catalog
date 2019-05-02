//
//  ViewController.swift
//  Movies Database
//
//  Created by Umair Ali on 17/04/2019.
//  Copyright © 2019 Umair Ali. All rights reserved.
//

import UIKit

class MovieListingVC: AppViewController {
    
    //MARK: Properties
    @IBOutlet weak var movieListing: UITableView!
    private let searchController = UISearchController(searchResultsController: nil)
    private var movieDatasource: MovieDataSourceInput = MovieDataSource()
    private let cellIdentifier = "MovieCell"
    private var selectedIndex: IndexPath?
    
    //Calculted property
    var movies: [Movie] = [] {
        didSet {
            movieListing.reloadData()
        }
    }
    
    var filteredMovies: [Movie] = [] {
        didSet {
            movieListing.reloadData()
        }
    }
    
    //MARK: Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureListing()
        setupSearchVC()
        loadListing()
    }
    
    //MARK: Listing methods
    func configureListing(){
        self.title = "Movie Catalog"
        movieListing.delegate = self
        movieListing.dataSource = self
        movieListing.prefetchDataSource = self
        movieDatasource.delegate = self
    }
    
    func loadListing() {
        _ = showActivityIndicator()
        movieDatasource.fetchMoviesList()
    }
    
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= (movies.count-1)
    }
    
    //MARK: Filter methods
    
    func setupSearchVC() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Movies"
        if #available(iOS 11.0, *) {
            navigationItem.searchController = searchController
        } else {
            movieListing.tableHeaderView = searchController.searchBar
        }
        definesPresentationContext = true
        
    }
    
    private func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    private func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        filteredMovies = movies.filter({( movie : Movie) -> Bool in
            return movie.title?.lowercased().contains(searchText.lowercased()) ?? false
        })
    }
    
    //MARK: Segue methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailVC = segue.destination as? MovieDetailVC, let selectedRow = selectedIndex?.row {
            detailVC.movieId = isFiltering() ? filteredMovies[selectedRow].id : movies[selectedRow].id
        }
    }
}

//MARK: Movie datasource delegate methods
extension MovieListingVC: MovieDataSourceDelegate {
    
    func fetchedMovies(movies: [Movie]) {
        _ =  dismissActivityIndicator()
        movieListing.isHidden = false
        self.movies.append(contentsOf: movies)
    }
    
    func failToFetchMovie(error: NSError) {
        _ =  dismissActivityIndicator()
        _ = UIAlertController.showAlertWithMesaage(error.localizedDescription, Title: .error, actionTitles: ["Try Again"], actions: [{
            DispatchQueue.main.async {  [weak self] in
                self?.movieDatasource.fetchMoviesList()
            }
            }])
        showAlertWithTitle(.error, andMessage: error.localizedDescription)
    }
    
    func noMoreMovies() {
    }
}


//MARK: Tableview datasource and delegate methods
extension MovieListingVC: UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering() {
            return filteredMovies.count
        }
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let movieCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? MovieTableViewCell {
            
            let movie = isFiltering() ? filteredMovies[indexPath.row] : movies[indexPath.row]
           
            movieCell.setData(movie: movie)
            return movieCell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        if indexPaths.contains(where: isLoadingCell) {
            movieDatasource.fetchMoviesList()
        }
    }
    
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        selectedIndex = indexPath
        return indexPath
    }
}

//MARK: Search result updater delegate methods

extension MovieListingVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
}
