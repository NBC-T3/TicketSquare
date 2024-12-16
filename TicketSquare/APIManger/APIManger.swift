//
//  APIManger.swift
//  TicketSquare
//
//  Created by 내일배움캠프 on 12/16/24.
//

import Alamofire
import UIKit

class APIManager {
    static let shared = APIManager()
    
    private let baseURL = "https://api.themoviedb.org/3"
    private let imageBaseURL = "https://image.tmdb.org/t/p/w500"
    private let APIKey = Bundle.main.infoDictionary?["APIKey"] as! String
    
    private lazy var headers: HTTPHeaders = [
        "accept": "application/json",
        "Authorization": APIKey
    ]
    
    /// 현재 상영중인 영화 목록 가져오기
    /// response -> 현재 상영중인 영화 id와 tittle들의 array
    func fetchNowPlayingMovies(page: Int, _ completion: @escaping ([Movie]?, Error?) -> Void) {
        
        let parameters: [String: Any] = [
            "language": "en-US",
            "page": page
        ]
        
        let url = "\(baseURL)/movie/now_playing"
  
        AF.request(url, method: .get, parameters: parameters, headers: headers)
            .validate()
            .responseDecodable(of: MovieResponse.self) { response in
                switch response.result {
                case .success(let movieResponse):
                    completion(movieResponse.results, nil)
                case .failure(let error):
                    completion(nil, error)
                }
            }
    }
    
    /// 개봉 예정 영화 목록 가져오기
    /// response -> 개봉 예정인 영화 id와 tittle들의 array
    func fetchUpcomingMovies(page: Int, _ completion: @escaping ([Movie]?, Error?) -> Void) {
        
        let parameters: [String: Any] = [
            "language": "en-US",
            "page": page
        ]
        
        let url = "\(baseURL)/movie/upcoming"
        
        AF.request(url, method: .get, parameters: parameters, headers: headers)
            .validate()
            .responseDecodable(of: MovieResponse.self) { response in
                switch response.result {
                case .success(let movieResponse):
                    completion(movieResponse.results, nil)
                case .failure(let error):
                    completion(nil, error)
                }
            }
    }
    
    /// 인기있는  영화 목록 가져오기
    /// response ->  인기있는  영화 id와 tittle들의 array
    func fetchPopularMovies(page: Int, _ completion: @escaping ([Movie]?, Error?) -> Void) {
        
        let parameters: [String: Any] = [
            "language": "en-US",
            "page": page
        ]
        
        let url = "\(baseURL)/movie/popular"
        
        AF.request(url, method: .get, parameters: parameters, headers: headers)
            .validate()
            .responseDecodable(of: MovieResponse.self) { response in
                switch response.result {
                case .success(let movieResponse):
                    completion(movieResponse.results, nil)
                case .failure(let error):
                    completion(nil, error)
                }
            }
    }
    
    /// 개봉 예정 영화 목록 가져오기
    /// response -> Top Rated 영화 id와 tittle들의 array
    func fetchTopRatedMovies(page: Int, _ completion: @escaping ([Movie]?, Error?) -> Void) {
        
        let parameters: [String: Any] = [
            "language": "en-US",
            "page": page
        ]
        
        let url = "\(baseURL)/movie/upcoming"
        
        AF.request(url, method: .get, parameters: parameters, headers: headers)
            .validate()
            .responseDecodable(of: MovieResponse.self) { response in
                switch response.result {
                case .success(let movieResponse):
                    completion(movieResponse.results, nil)
                case .failure(let error):
                    completion(nil, error)
                }
            }
    }
    
    /// 이미지 가져오기
    /// response -> id에 해당하는 이미지 data
    func fetchMovieImages(movieId: Int, completion: @escaping (Data?, Error?) -> Void) {
        let url = "https://api.themoviedb.org/3/movie/\(movieId)/images"
        print(url)
        AF.request(url, method: .get, headers: headers)
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let data):
                    completion(data, nil)
                case .failure(let error):
                    completion(nil, error)
                }
            }
    }
    
    /// 영화 세부 정보 가져오기
    /// response -> tittle, overview, releaseDate, runtime, genres array( id, name)
    func fetchMovieDetails(movieId: Int, completion: @escaping (MovieDetails?, Error?) -> Void) {
        
        let url = "\(baseURL)/movie/\(movieId)"
        AF.request(url, method: .get, headers: headers)
            .validate()
            .responseDecodable(of: MovieDetails.self) { response in
                switch response.result {
                case .success(let movieDetails):
                    completion(movieDetails, nil)
                case .failure(let error):
                    completion(nil, error)
                }
            }
    }
    
    /// 영화 키워드 목록 가져오기
    /// fetchKeywordsMovies(5353)
    /// response -> 키워드의 id와 키워드들 담은 array
    func fetchKeywordsMovies(movieId: Int, _ completion: @escaping ([Keyword]?, Error?) -> Void) {
        
        let parameters: [String: Any] = [
            "language": "en-US"
        ]
        
        let url = "\(baseURL)/movie/\(movieId)/keywords"
    
        AF.request(url, method: .get, parameters: parameters, headers: headers)
            .validate()
            .responseDecodable(of: KeywordResponse.self) { response in
                switch response.result {
                case .success(let keywordResponse):
                    completion(keywordResponse.keywords, nil)
                case .failure(let error):
                    completion(nil, error)
                }
            }
    }
    
    /// 키워드로 영화 검색
    /// searchForKeyWordMovies(1, "boss")
    /// reponse -> 검색한 키워드를 포함한 영화들의 id와 name들의 array
    func searchForKeyWordMovies(page: Int, keyWord: String, _ completion: @escaping ([SearchKeyword]?, Error?) -> Void) {
        
        let parameters: [String: Any] = [
            "query": keyWord,
            "page": page
        ]
        let url = "\(baseURL)/search/keyword"
        
        // Alamofire 요청
        AF.request(url, method: .get, parameters: parameters, headers: headers)
            .validate()
            .responseDecodable(of: SearchKeywordResponse.self) { response in
                switch response.result {
                case .success(let searchKeywordResponse):
                    completion(searchKeywordResponse.results, nil)
                case .failure(let error):
                    completion(nil, error)
                }
            }
    }
    
}



