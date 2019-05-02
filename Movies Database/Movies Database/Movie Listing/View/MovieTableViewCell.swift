//
//  MovieTableViewCell.swift
//  Movies Database
//
//  Created by Umair Ali on 17/04/2019.
//  Copyright © 2019 Umair Ali. All rights reserved.
//

import UIKit
import AlamofireImage


class MovieTableViewCell: UITableViewCell {

    //MARK: IBOutlets
    @IBOutlet weak var imgPoster: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func prepareForReuse() {
        imgPoster.image = nil
    }
    
    //MARK: Set movie data
    func setData(movie: Movie) {
        lblTitle.text = movie.title
        guard let url = URL(string: Server.imageBaseURL+(movie.posterPath ?? movie.backdropPath ?? "")) else {
            return
        }
        imgPoster.af_setImage(withURL: url)
    }
}
