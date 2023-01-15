//
//  ReviewResponseDTO+Mapping.swift
//  GLIFlix
//
//  Created by Maurice Tin on 14/01/23.
//

import Foundation

struct ReviewResponseDTO: Decodable{
    let id: Int
    let page: Int
    let results: [ReviewResultResponseDTO]
    let totalPages: Int
    let totalResults: Int
    
    enum CodingKeys: String,CodingKey{
        case id
        case page
        case results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

struct ReviewResultResponseDTO: Decodable{
    public let author: String
    public let authorDetailsResponse: AuthorResponseDTO
    public let content: String
    public let createdAt: String
    public let id: String
    public let updatedAt: String
    public let url: String
    
    enum CodingKeys: String,CodingKey{
        case author
        case authorDetailsResponse = "author_details"
        case content
        case createdAt = "created_at"
        case id
        case updatedAt = "updated_at"
        case url
    }
}

extension ReviewResponseDTO{
    func toDomain()->Review{
        return Review(
            id: self.id,
            page: self.page,
            results: self.results.map({
                $0.toDomain()
            }),
            totalPages: self.totalPages,
            totalResults: self.totalResults
        )
    }
}

extension ReviewResultResponseDTO{
    func toDomain()->ReviewResult{
        return ReviewResult(
            author: self.author,
            authorDetails: self.authorDetailsResponse.toDomain(),
            content: self.content,
            createdAt: self.createdAt,
            id: self.id,
            updatedAt: self.updatedAt,
            url: self.url
        )
    }
}
