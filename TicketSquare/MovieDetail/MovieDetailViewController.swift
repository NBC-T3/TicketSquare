import UIKit
import SnapKit

class MovieDetailViewController: UIViewController {
    
    // MARK: - UI 요소 선언
    
    // 포스터 이미지 뷰
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // 제목 라벨
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .black
        label.numberOfLines = 2
        return label
    }()
    
    // 개요 라벨
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .darkGray
        label.numberOfLines = 0
        return label
    }()
    
    // 상영 시간 라벨
    private let runtimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        return label
    }()
    
    // 장르 라벨
    private let genresLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.numberOfLines = 0
        return label
    }()
    
    // 예매 버튼
    private let reserveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Reserve Now", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(reserveButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // 영화 ID 변수
    var movieID: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        layoutUI()
        fetchMovieDetails()
    }
    
    // MARK: - UI 배치
    private func layoutUI() {
        view.backgroundColor = .white

        [posterImageView, titleLabel, overviewLabel, runtimeLabel, genresLabel, reserveButton].forEach { view.addSubview($0) }
        
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
    
    // MARK: - 기본 데이터 설정
    private func configureUI() {
        titleLabel.text = "Loading..."
        overviewLabel.text = ""
        runtimeLabel.text = ""
        genresLabel.text = ""
    }
    
    // MARK: - API 호출
    private func fetchMovieDetails() {
        APIManager.shared.fetchNowPlayingMovies(page: 1) { [weak self] movies, error in
            guard let self = self else { return }
            if let error = error {
                print("Error fetching movies: \(error.localizedDescription)")
                return
            }
            
            guard let movies = movies, let firstMovie = movies.first else {
                print("No movies available.")
                return
            }
            
            let movieID = firstMovie.id
            print("Selected Movie ID: \(movieID)")
            
            self.fetchDetails(for: movieID)
        }
    }
    
    private func fetchDetails(for movieID: Int) {
        APIManager.shared.fetchMovieDetails(movieID: movieID) { [weak self] details, error in
            guard let self = self, let details = details else {
                print("Error fetching movie details: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            DispatchQueue.main.async {
                self.titleLabel.text = details.title
                self.overviewLabel.text = details.overview
                self.runtimeLabel.text = "Runtime: \(details.runtime) minutes"
                self.genresLabel.text = "Genres: \(details.genres.map { $0.name }.joined(separator: ", "))"
                
                // posterPath를 사용해 이미지 다운로드 및 설정
                if let posterPath = details.posterPath {
                    APIManager.shared.fetchImage(from: posterPath) { image in
                        if let image = image {
                            DispatchQueue.main.async {
                                self.posterImageView.image = image
                            }
                        } else {
                            print("Failed to load poster image")
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - 예매 버튼 액션
    @objc private func reserveButtonTapped() {
        let alert = UIAlertController(title: "Reservation", message: "Reservation successful!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
