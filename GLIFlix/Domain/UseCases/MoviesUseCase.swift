//
//  MovieUseCase.swift
//  GLIFlix
//
//  Created by Maurice Tin on 12/01/23.
//
import Alamofire
import RxSwift

protocol MoviesUseCase{
    func fetchPopularMovies(page: Int)
    func fetchReviews(for id: Int)->Observable<[ReviewResult]>
    func fetchVideos(for id: Int)->Observable<[VideoResult]>
}

final class DefaultMoviesUseCase: MoviesUseCase{
    enum FailureReason: Error{
        case notFound
    }
    
    public var popularMoviesSubject = PublishSubject<Result<[Movie],Error>>()
    
    func fetchPopularMovies(page: Int = 1){
        let url = "https://api.themoviedb.org/3/movie/popular"
        let parameters: [String:String] = [
            "api_key" : "ed9d5af2f620bc920de2859d27746216",
            "page" : String(page)
        ]
        
        AF.request(url,parameters: parameters)
            .responseDecodable(of: PopularMoviesResponseDTO.self) { [popularMoviesSubject] response in
                if let someError = response.error{
                    popularMoviesSubject.onNext(.failure(someError))
                    return
                }
                
                guard let moviesDTO = response.value?.results else {return}
                let movies = moviesDTO.map { movieDTO in
                    movieDTO.toDomain()
                }
                popularMoviesSubject.onNext(.success(movies))
            }
    }
    
    func fetchReviews(for id: Int) -> Observable<[ReviewResult]> {
        return Observable<[ReviewResult]>.create { observer in
            let parameters: [String:String] = [
                "api_key" : apiKey
            ]
            AF.request(APIEndpoints.getReviewsURLString(id: id), parameters: parameters)
                .validate()
                .responseDecodable(of: ReviewResponseDTO.self) { response in
                    guard let reviewResponseDTO = response.value?.results else{
                        return
                    }
                    let result = reviewResponseDTO.map { reviewDTO in
                        reviewDTO.toDomain()
                    }
                    observer.onNext(result)
                }
            return Disposables.create()
        }
    }
    
    func fetchVideos(for id: Int) -> Observable<[VideoResult]> {
        return Observable<[VideoResult]>.create { observer in
            let parameters: [String:String] = [
                "api_key" : apiKey
            ]
            AF.request(APIEndpoints.getVideosURLString(id: id), parameters: parameters)
                .validate()
                .responseDecodable(of: Videos.self) { response in
                    guard let videoResult = response.value?.results else{
                        return
                    }
                    
                    observer.onNext(videoResult)
                }
            return Disposables.create()
        }
    }
}
