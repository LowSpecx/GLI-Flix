//
//  Video.swift
//  GLIFlix
//
//  Created by Maurice Tin on 14/01/23.
//

import Foundation

public struct Videos: Decodable{
    let id: Int
    let results: [VideoResult]
}

public struct VideoResult: Decodable{
    let name: String
    let key: String
    let site: String
    let size: Int
    let type: String
    let official: Bool
    let publishedAt: String
    let id: String
    
    enum CodingKeys: String,CodingKey{
        case name
        case key
        case site
        case size
        case type
        case official
        case publishedAt = "published_at"
        case id
    }
}
