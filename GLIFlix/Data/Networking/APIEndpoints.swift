//
//  APIEndpoints.swift
//  GLIFlix
//
//  Created by Maurice Tin on 13/01/23.
//

import Foundation

let apiKey = "ed9d5af2f620bc920de2859d27746216"

final class APIEndpoints{
    static let baseURLString = "https://api.themoviedb.org/3"
    
    static public func getImageURL(imagePath: String)->URL?{
        return URL(string: "https://image.tmdb.org/t/p/w200\(imagePath)")
    }
    
    static public func getReviewsURLString(id: Int)->String{
        return baseURLString+"/movie/"+String(id)+"/reviews"
    }
    
    static public func getVideosURLString(id: Int)->String{
        return baseURLString+"/movie/"+String(id)+"/videos"
    }
}
