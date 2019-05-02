//
//  API.swift
//  Movies Database
//
//  Created by Umair Ali on 17/04/2019.
//  Copyright © 2019 Umair Ali. All rights reserved.
//


import UIKit
import Foundation
import Alamofire

public struct Server {
    //Base URLs
    public static let baseURL = "https://api.themoviedb.org/3/movie/"
    public static let imageBaseURL = "https://image.tmdb.org/t/p/w342"
}

public struct API {
    private struct endPoints {
        static let popular  = "popular"
    }
    
    public struct Movie {
        public static let listing: AppRequest = (urltoHit: Server.baseURL+endPoints.popular, type: .get)
        public static let detail: AppRequest = (urltoHit: Server.baseURL, type: .get)
    }
    
    static func appendAPIKey(url: String) -> String {
       return  url+"?api_key=3c56224ce04861c6d41b46a64570b1a4"
    }
}
