//
//  DataSource.swift
//  Movies Database
//
//  Created by Umair Ali on 20/04/2019.
//  Copyright © 2019 Umair Ali. All rights reserved.
//

import Foundation
import Alamofire

protocol DetailDataSourceInput {
    var delegate: DetailDataSourceDelegate? { get set}
    func fetchDetail(id: Int)
}

protocol DetailDataSourceDelegate: class  {
    func fetchedDetail(movie: MovieDetail)
    func failToFetchMovie(error: NSError)
}

class DetailDataSource {
    private weak var dataSourceDelegate: DetailDataSourceDelegate?

    private func createRequest(id: Int) -> AppRequest {
        
        var appRequest = API.Movie.detail
        appRequest.urltoHit = appRequest.urltoHit+"\(id)"
        appRequest.urltoHit = API.appendAPIKey(url: appRequest.urltoHit)
        return appRequest
    }
    
    private func sendApiCall(appRequest: AppRequest) {
        WebServiceManager.sendAPICall(request: appRequest, parameters: nil, modelType: MovieDetail.self, success: { [weak self] response in
            
            self?.delegate?.fetchedDetail(movie: response)
            
            }, failure: { [weak self] error in
                self?.delegate?.failToFetchMovie(error: error)
        })
    }
}

extension DetailDataSource: DetailDataSourceInput {
    var delegate: DetailDataSourceDelegate? {
        get {
             return dataSourceDelegate
        }
        set {
            dataSourceDelegate = newValue
        }
    }
    
    func fetchDetail(id: Int) {
        sendApiCall(appRequest:createRequest(id:id))
    }
}
