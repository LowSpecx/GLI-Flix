//
//  MovieInfoViewModel.swift
//  GLIFlix
//
//  Created by Maurice Tin on 14/01/23.
//
import RxSwift
import RxCocoa

final class MovieInfoViewModel: ViewModelType{
    private let useCase: MoviesUseCase
    private let movie: Movie
    
    struct Input{
        let didLoadTrigger: Observable<Void>
    }
    
    struct Output{
        let movie: Driver<Movie>
        let reviews: Driver<[ReviewResult]>
        let youtubeVideo: Driver<VideoResult>
    }
    
    init(useCase: MoviesUseCase, movie: Movie) {
        self.useCase = useCase
        self.movie = movie
    }
    
    func transform(input: Input) -> Output {
        let movieResult = Driver.just(movie)
        let reviews = input.didLoadTrigger.flatMap { [movie,useCase] in
            useCase.fetchReviews(for: movie.id)
        }.asDriver(onErrorJustReturn: [])
        
        let videoResults = input.didLoadTrigger.flatMap({ [movie,useCase] in
            useCase.fetchVideos(for: movie.id)
        }).asDriver(onErrorJustReturn: [])
        
        let youtubeVideo = videoResults.compactMap { videoResults in
            return videoResults.first(where:{ $0.site == "YouTube" })
        }
        
        return Output(
            movie: movieResult,
            reviews: reviews,
            youtubeVideo: youtubeVideo
        )
    }
}
