//
//  Model.swift
//  MobileAppChallenge
//
//  Created by USER on 2/1/44 Saka.
//

import Foundation
import UIKit


// MARK: - MovieResponse
struct MovieResponse: Codable {
    var search: [Search]
    let totalResults, response: String

    enum CodingKeys: String, CodingKey {
        case search = "Search"
        case totalResults
        case response = "Response"
    }
}

// MARK: - Search
struct Search: Codable {
    let title, year, imdbID: String
    let type: TypeEnum
    let poster: String
  //  let hour:String
  //  let rating:String
//    let score:String
//    let popularity:String
//    let director:String
//    let writer:String
//    let actor:String
//    let detail:String
//    let rated:String
    
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case imdbID = "imdbID"
        case type = "Type"
        case poster = "Poster"
     //   case hour = "Runtime"
      //  case rating = "imdbRating"
   //     case score = "Metascore"
//        case popularity = "imdbVotes"
//        case director = "Director"
//        case writer = "Writer"
//        case actor = "Actors"
//        case detail = "Plot"
//        case rated = "Rated"
    }
}



struct detailResponce: Codable {
    let title, year, imdbID: String
    let type: TypeEnum
    let poster: String
    let hour:String
    let rating:String
    let score:String
    let popularity:String
    let director:String
    let writer:String
    let actor:String
    let detail:String
    let rated:String
    
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case imdbID = "imdbID"
        case type = "Type"
        case poster = "Poster"
        case hour = "Runtime"
        case rating = "imdbRating"
        case score = "Metascore"
        case popularity = "imdbVotes"
        case director = "Director"
        case writer = "Writer"
        case actor = "Actors"
        case detail = "Plot"
        case rated = "Rated"
    }
}


enum TypeEnum: String, Codable {
    case movie = "movie"
}
 
    
    
extension UIImageView {
    func downloaded(from url: URL, contentMode mode: ContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.image = image
            }
        }.resume()
    }
    func downloaded(from link: String, contentMode mode: ContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloaded(from: url, contentMode: mode)
    }
}
