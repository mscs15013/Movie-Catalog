//
//  TrailerDataSource.swift
//  Movies Database
//
//  Created by Umair Ali on 26/04/2019.
//  Copyright © 2019 Umair Ali. All rights reserved.
//

import Foundation
import Alamofire

protocol TrailerDataSourceInput {
    var delegate: TrailerDataSourceDelegate? { get set}
    func fetchDetail(id: Int)
}

protocol TrailerDataSourceDelegate: class  {
    func fetchedTrailerDetail(movie: TrailerVideoResponse)
    func failToFetchTrailerDetail(error: NSError)
}

class TrailerDataSource {
    
    private weak var dataSourceDelegate: TrailerDataSourceDelegate?
    
    private func createRequest(id: Int) -> AppRequest {
        
        var appRequest = API.Movie.detail
        
        appRequest.urltoHit = appRequest.urltoHit+"\(id)/videos"
        appRequest.urltoHit = API.appendAPIKey(url: appRequest.urltoHit)
        return appRequest
    }
    
    private func sendApiCall(appRequest: AppRequest) {
        WebServiceManager.sendAPICall(request: appRequest, parameters: nil, modelType: TrailerVideoResponse.self, success: { [weak self] response in
            
            self?.delegate?.fetchedTrailerDetail(movie: response)
            
            }, failure: { [weak self] error in
                self?.delegate?.failToFetchTrailerDetail(error: error)
        })
    }
}

extension TrailerDataSource: TrailerDataSourceInput {
    
    var delegate: TrailerDataSourceDelegate? {
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
