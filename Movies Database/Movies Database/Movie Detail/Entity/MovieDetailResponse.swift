//
//  MovieDetail.swift
//  Movies Database
//
//  Created by Umair Ali on 20/04/2019.
//  Copyright © 2019 Umair Ali. All rights reserved.
//

import Foundation

struct MovieDetail: Decodable {
    
    var title: String
    var overview: String
    var posterPath: String?
    var backdropPath: String?
    var genres: [Genres]
    var date: String
    
    enum CodingKeys: String, CodingKey {
        case genres
        case title
        case overview
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case date = "release_date"
    }
}

struct Genres: Codable {
    var name: String
}
