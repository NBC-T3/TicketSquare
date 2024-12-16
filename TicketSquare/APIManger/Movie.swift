//
//  Untitled.swift
//  TicketSquare
//
//  Created by 내일배움캠프 on 12/16/24.
//

import Foundation

struct Movie: Decodable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
}

struct MovieResponse: Decodable {
    let results: [Movie]
}

struct MovieDetails: Decodable {
    let title: String
    let overview: String
    let releaseDate: String
    let runtime: Int
}
