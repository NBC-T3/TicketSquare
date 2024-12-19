//
//  Untitled.swift
//  TicketSquare
//
//  Created by 내일배움캠프 on 12/16/24.
//

import Foundation

// fetchNowPlayingMovies, fetchUpcomingMovies 메서드에서 사용되는 모델
struct Movie: Decodable {
    let id: Int
    let title: String
    let posterPath: String

    
    
    enum CodingKeys: String, CodingKey {
        case id, title
        case posterPath = "poster_path"
    }
}

struct MovieResponse: Decodable {
    let results: [Movie]
}

// fetchMovieDetails 메서드에서 사용되는 모델
struct MovieDetails: Decodable {
    let title: String
    let overview: String
    let releaseDate: String
    let posterPath: String?
    let runtime: Int
    let genres: [Genres]
    
    func genresDescribing() -> String {
        if genres.count < 2 {
            return genres.map { $0.name }.joined(separator: ", ")
        } else {
            return genres[0...1].map { $0.name }.joined(separator: ", ")
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case title, overview, runtime
        case releaseDate = "release_date"
        case posterPath = "poster_path"
        case genres
    }
}

struct Genres: Decodable {
    let id: Int
    let name: String
}

// fetchKeywordsMovies 메서드에서 사용되는 모델
struct Keyword: Decodable {
    let id: Int
    let name: String
}

struct KeywordResponse: Decodable {
    let id: Int
    let keywords: [Keyword]
}

// searchForKeyWordMovies 메서드에서 사용되는 모델 
struct SearchKeyword: Decodable{
    let id: Int
    let name: String
}

struct SearchKeywordResponse: Decodable {
    let results: [SearchKeyword]
}
