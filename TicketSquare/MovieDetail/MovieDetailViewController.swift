//
//  Untitled.swift
//  TicketSquare
//
//  Created by 내일배움캠프 on 12/17/24.
//

import UIKit
import SnapKit

class MovieDetailViewController: UIViewController {
    
    // UI 요소 선언
    private let posterImageView = UIImageView()
    private let titleLabel = UILabel()
    private let overviewLabel = UILabel()
    private let runtimeLabel = UILabel()
    private let genresLabel = UILabel()
    private let reserveButton = UIButton()
    
    // 영화 ID 변수
    var movieID: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        layoutUI()
        configureUI()
        fetchMovieDetails()
    }
    
    // UI 구성
    private func setupUI() {
        view.backgroundColor = .white
        
        // 포스터 이미지
        posterImageView.contentMode = .scaleAspectFill
        posterImageView.clipsToBounds = true
        view.addSubview(posterImageView)
        
        // 영화 제목
        titleLabel.font = UIFont.boldSystemFont(ofSize: 24)
        titleLabel.textColor = .black
        titleLabel.numberOfLines = 2
        view.addSubview(titleLabel)
        
        // 영화 개요
        overviewLabel.font = UIFont.systemFont(ofSize: 16)
        overviewLabel.textColor = .darkGray
        overviewLabel.numberOfLines = 0
        view.addSubview(overviewLabel)
        
        // 상영 시간
        runtimeLabel.font = UIFont.systemFont(ofSize: 14)
        runtimeLabel.textColor = .gray
        view.addSubview(runtimeLabel)
        
        // 장르
        genresLabel.font = UIFont.systemFont(ofSize: 14)
        genresLabel.textColor = .gray
        genresLabel.numberOfLines = 0
        view.addSubview(genresLabel)
        
        // 예매 버튼
        reserveButton.setTitle("Reserve Now", for: .normal)
        reserveButton.setTitleColor(.white, for: .normal)
        reserveButton.backgroundColor = .systemBlue
        reserveButton.layer.cornerRadius = 8
        reserveButton.addTarget(self, action: #selector(reserveButtonTapped), for: .touchUpInside)
        view.addSubview(reserveButton)
    }
    
    // UI 배치
    private func layoutUI() {
        posterImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(300)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(posterImageView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        overviewLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        runtimeLabel.snp.makeConstraints { make in
            make.top.equalTo(overviewLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        genresLabel.snp.makeConstraints { make in
            make.top.equalTo(runtimeLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        reserveButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(200)
        }
    }
    
    // 데이터 구성
    private func configureUI() {
        // 기본 상태
        titleLabel.text = "Loading..."
        overviewLabel.text = ""
        runtimeLabel.text = ""
        genresLabel.text = ""
    }
    
    
    // API 호출로 데이터 가져오기
    private func fetchMovieDetails() {
        // 1. 현재 상영 중인 영화 목록 가져오기
        APIManager.shared.fetchNowPlayingMovies(page: 1) { [weak self] movies, error in
            guard let self = self else { return } // Self weak capture
            if let error = error {
                print("Error fetching movies: \(error.localizedDescription)")
                return
            }
            
            guard let movies = movies, let firstMovie = movies.first else {
                print("No movies available.")
                return
            }
            
            let movieID = firstMovie.id // 첫 번째 영화 ID 사용
            print("Selected Movie ID: \(movieID)")
            
            // 2. 영화 세부 정보 가져오기
            self.fetchDetails(for: movieID)
            
            // 3. 영화 이미지 가져오기
            self.fetchImages(for: movieID)
        }
    }

    private func fetchDetails(for movieID: Int) {
        APIManager.shared.fetchMovieDetails(movieID: movieID) { [weak self] details, error in
            guard let self = self, let details = details else {
                print("Error fetching movie details: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            // UI 업데이트
            DispatchQueue.main.async {
                self.titleLabel.text = details.title
                self.overviewLabel.text = details.overview
                self.runtimeLabel.text = "Runtime: \(details.runtime) minutes"
                self.genresLabel.text = "Genres: \(details.genres.map { $0.name }.joined(separator: ", "))"
            }
        }
    }

    private func fetchImages(for movieID: Int) {
        APIManager.shared.fetchMovieImages(movieID: movieID) { [weak self] data, error in
            guard let self = self, let data = data, error == nil else {
                print("Error fetching movie poster: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            // UI 업데이트
            DispatchQueue.main.async {
                self.posterImageView.image = UIImage(data: data)
            }
        }
    }
    
    // 예매 버튼 액션
    @objc private func reserveButtonTapped() {
        let alert = UIAlertController(title: "Reservation", message: "Reservation successful!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

