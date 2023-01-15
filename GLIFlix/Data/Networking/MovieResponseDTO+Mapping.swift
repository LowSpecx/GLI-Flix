//
//  MovieResponseDTO+Mapping.swift
//  GLIFlix
//
//  Created by Maurice Tin on 12/01/23.
//

import Foundation

struct PopularMoviesResponseDTO: Decodable{
    let page: Int
    let results: [MovieResponseDTO]
}

struct MovieResponseDTO: Decodable{
    let isAdult: Bool
    let backdropPath: String?
    let genreIDs: [Int]
    let id: Int
    let originalLanguage: String
    let originalTitle: String
    let overview: String
    let popularity: Double
    let posterPath: String
    let releaseDate: String
    let title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int
    
    enum CodingKeys: String, CodingKey{
        case isAdult = "adult"
        case backdropPath = "backdrop_path"
        case genreIDs = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview
        case popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title
        case video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

extension MovieResponseDTO{
    func toDomain()->Movie{
        .init(
            isAdult: self.isAdult,
            backdropPath: self.backdropPath,
            genreIDs: self.genreIDs,
            id: self.id,
            originalLanguage: self.originalLanguage,
            originalTitle: self.originalTitle,
            overview: self.overview,
            popularity: self.popularity,
            posterPath: self.posterPath,
            releaseDate: self.releaseDate,
            title: self.title,
            video: self.video,
            voteAverage: self.voteAverage,
            voteCount: self.voteCount
        )
    }
}


