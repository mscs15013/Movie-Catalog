//
//  VideoDetailResponse.swift
//  Movies Database
//
//  Created by Umair Ali on 26/04/2019.
//  Copyright © 2019 Umair Ali. All rights reserved.
//

import Foundation

struct TrailerVideoResponse: Decodable {
    var results : [TrailerVideo]
}

struct TrailerVideo: Decodable {
    var key: String
}


