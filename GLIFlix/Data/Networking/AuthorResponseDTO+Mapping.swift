//
//  AuthorResponseDTO+Mapping.swift
//  GLIFlix
//
//  Created by Maurice Tin on 14/01/23.
//

import Foundation

struct AuthorResponseDTO: Decodable{
    let name: String
    let username: String
    let avatarPath: String?
    let rating: Double?
    
    enum CodingKeys: String,CodingKey{
        case name
        case username
        case avatarPath = "avatar_path"
        case rating
    }
}

extension AuthorResponseDTO{
    func toDomain()->Author{
        return Author(
            name: self.name,
            username: self.username,
            avatarPath: self.avatarPath,
            rating: self.rating)
    }
}
