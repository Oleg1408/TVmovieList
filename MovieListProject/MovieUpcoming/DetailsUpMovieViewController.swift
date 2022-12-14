//
//  DetailsUpMovieViewController.swift
//  MovieListProject
//
//  Created by Олег Курбатов on 20.09.2022.
//

import UIKit
import SDWebImage
import youtube_ios_player_helper
import Alamofire

class DetailsUpMovieViewController: UIViewController {
    
    @IBOutlet weak var upcomMovieImage: UIImageView!
    @IBOutlet weak var upcomMovieTitleLable: UILabel!
    @IBOutlet weak var upcomMovieDataLable: UILabel!
    @IBOutlet weak var upcomMovieLanguageLable: UILabel!
    @IBOutlet weak var upcomMovieRaitingLable: UILabel!
    @IBOutlet weak var upcomMovieOverviewLable: UILabel!
    @IBOutlet weak var upcomingYoutubePlayer: YTPlayerView!
    
    var newUpcomingMovieArray: ResultsOfUpcomingMovie?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addUpcomingMovieDetails()
        loadUpcomingMovieVideo()
    }
    
    
    func loadUpcomingMovieVideo() {
        guard let movieIdInt = newUpcomingMovieArray?.id else {return}
        let movieId = String(movieIdInt)
        let urlVideo = "https://api.themoviedb.org/3/movie/\(movieId)/videos?api_key=f28226d77e6c2b87d7d08bc99737fd1a&language=en-US"
        
        AF.request(urlVideo).responseDecodable(of: ModelsOfVideoMovie.self) { responseModelsVideo in
            if let data = responseModelsVideo.value?.results {
                self.upcomingYoutubePlayer.load(withVideoId: data.first?.key ?? "")
                self.upcomingYoutubePlayer.playVideo()
            }
        }
    }
    
    func addUpcomingMovieDetails() {
        self.upcomMovieTitleLable.text = newUpcomingMovieArray?.title ?? ""
        self.upcomMovieDataLable.text = "Release date: \(newUpcomingMovieArray?.release_date ?? "")"
        self.upcomMovieLanguageLable.text = "Language: \(newUpcomingMovieArray?.original_language ?? "")"
        self.upcomMovieRaitingLable.text = "Rating: \(Int(newUpcomingMovieArray?.popularity ?? 0))"
        self.upcomMovieOverviewLable.text = newUpcomingMovieArray?.overview
        loadPosterUpcominMovew(url: newUpcomingMovieArray?.backdrop_path)
    }
    
    private func loadPosterUpcominMovew(url: String?) {
        guard let url = url else {return}
        let imageUrlString = "https://image.tmdb.org/t/p/w300/" + url
        let imageUrl = URL(string: imageUrlString)
        self.upcomMovieImage.sd_setImage(with: imageUrl)
    }
}


