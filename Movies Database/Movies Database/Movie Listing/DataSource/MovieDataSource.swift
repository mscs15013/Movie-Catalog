//
//  DataSource.swift
//  Movies Database
//
//  Created by Umair Ali on 20/04/2019.
//  Copyright © 2019 Umair Ali. All rights reserved.
//

import Foundation
import Alamofire

//MARK: Movie Datasource Delegate fetching data
protocol MovieDataSourceInput {
    var delegate: MovieDataSourceDelegate? { get set}
    func fetchMoviesList()
}

//MARK: Movie Datasource Delegate Fetched movies
protocol MovieDataSourceDelegate: class  {
    func fetchedMovies(movies: [Movie])
    func failToFetchMovie(error: NSError)
    func noMoreMovies()
}

class MovieDataSource {
    private weak var dataSourceDelegate: MovieDataSourceDelegate?
    private var page = 1
    private var totalPage = 1
    
    func createRequest() -> AppRequest {
        
        var appRequest = API.Movie.listing
        appRequest.urltoHit = API.appendAPIKey(url: appRequest.urltoHit)
        appRequest.urltoHit = appRequest.urltoHit+"&page=\(page)"
        return appRequest
    }
    
    func sendApiCall(appRequest: AppRequest, success: @escaping (_ movies: [Movie], _ totalPages: Int) -> Void, failure: @escaping (_ error: NSError) -> Void) {
        WebServiceManager.sendAPICall(request: appRequest, parameters: nil, modelType: MovieResponse.self, success: { response in
            
            success(response.results, response.totalPages)
            
        }, failure: { error in
            failure(error)
        })
    }
}

extension MovieDataSource: MovieDataSourceInput {
    
    var delegate: MovieDataSourceDelegate? {
        get {
            return dataSourceDelegate
        }
        set {
            dataSourceDelegate = newValue
        }
    }
    
    func fetchMoviesList() {
        if page <= totalPage {
            sendApiCall(appRequest: createRequest(), success: {[weak self] movies, pages  in
                guard let self = self else {
                    return
                }
                self.page = self.page + 1
                self.totalPage = pages
                self.delegate?.fetchedMovies(movies: movies)
                }, failure: {[weak self] error in
                    self?.delegate?.failToFetchMovie(error: error)
            })
        }else {
            delegate?.noMoreMovies()
        }
    }
}
