//
//  MovieDetailVC.swift
//  Movies Database
//
//  Created by Umair Ali on 20/04/2019.
//  Copyright © 2019 Umair Ali. All rights reserved.
//

import UIKit
import XCDYouTubeKit
import AVKit

class MovieDetailVC: AppViewController {
    
    @IBOutlet weak var imgPoster: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblGenres: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblOverview: UILabel!
    
    var detailDataSource: DetailDataSourceInput = DetailDataSource()
    var trailerDataSource: TrailerDataSourceInput = TrailerDataSource()
    let playerViewController = AVPlayerViewController()
    var movieId: Int = 0
    
    @IBAction func watchTrailer(_ sender: Any) {
       trailerDataSource.fetchDetail(id: movieId)
        _ = self.showActivityIndicator()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVC()
        fetchData()
    }
    
    func setupVC() {
        self.title = "Movie Detail"
        detailDataSource.delegate = self
        trailerDataSource.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerViewController.player?.currentItem)
    }
    
    func fetchData() {
        _ = showActivityIndicator()
        detailDataSource.fetchDetail(id: movieId)
    }
    
    
    func fillData(movieDetail: MovieDetail) {
        lblTitle.text = movieDetail.title
        lblGenres.text = movieDetail.genres.map({ $0.name}).joined(separator: ",")
        lblDate.text = movieDetail.date
        lblOverview.text = movieDetail.overview
        guard let url = URL(string: Server.imageBaseURL+(movieDetail.posterPath ?? movieDetail.backdropPath ?? "")) else {
            return
        }
        imgPoster.af_setImage(withURL: url)
    }
    
    func playVideo(identifier: String){
        
        self.present(playerViewController, animated: true, completion: nil)
        
        weak var playerVC = playerViewController
        
        XCDYouTubeClient.default().getVideoWithIdentifier(identifier, completionHandler: { video , error in
            
            if let video = video {
                let urls = video.streamURLs
                let url = urls[XCDYouTubeVideoQuality.HD720.rawValue] ??  urls[XCDYouTubeVideoQuality.medium360.rawValue] ?? urls[XCDYouTubeVideoQuality.small240.rawValue]
                
                guard let streamURL = url else {
                    self.dismiss(animated: true, completion: nil)
                    return
                }
                playerVC?.player = AVPlayer(url: streamURL)
                playerVC?.player?.play()
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        })
    }
    
    @objc func playerDidFinishPlaying(note: NSNotification) {
        self.playerViewController.dismiss(animated: true)
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension MovieDetailVC:  DetailDataSourceDelegate{
    func fetchedDetail(movie: MovieDetail) {
        _ = dismissActivityIndicator()
        fillData(movieDetail: movie)
    }
    
    func failToFetchMovie(error: NSError) {
         _ = self.dismissActivityIndicator()
        self.showAlertWithTitle(.error, andMessage: error.localizedDescription, style: .alert)
    }
}

extension MovieDetailVC:  TrailerDataSourceDelegate{
    func fetchedTrailerDetail(movie: TrailerVideoResponse) {
        _ = self.dismissActivityIndicator()
        guard let trailer = movie.results.first else {
            return
        }
        playVideo(identifier: trailer.key)
    }
    
    func failToFetchTrailerDetail(error: NSError) {
        _ = self.dismissActivityIndicator()
        self.showAlertWithTitle(.error, andMessage: error.localizedDescription, style: .alert)
    }
}






