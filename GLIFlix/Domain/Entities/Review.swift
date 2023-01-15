//
//  Review.swift
//  GLIFlix
//
//  Created by Maurice Tin on 14/01/23.
//

public struct Review{
    public let id: Int
    public let page: Int
    public let results: [ReviewResult]
    public let totalPages: Int
    public let totalResults: Int
}

public struct ReviewResult{
    public let author: String
    public let authorDetails: Author
    public let content: String
    public let createdAt: String
    public let id: String
    public let updatedAt: String
    public let url: String
}
