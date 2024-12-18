import UIKit
import SnapKit

class MovieDetailViewController: UIViewController {
    
    // 영화 데이터
    var movieDetails: MovieDetails!
    
    // MARK: - UI 요소 선언
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textColor = .white
        return label
    }()
    
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white
        label.numberOfLines = 3 // 기본적으로 3줄까지만 표시
        label.isUserInteractionEnabled = true // 제스처 인식을 위해 활성화
        return label
    }()
    
    private let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        return label
    }()
    
    private let runtimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        return label
    }()
    
    private let genresLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .white
        return label
    }()
    
    private let reserveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Reserve Now", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.cornerRadius = 8
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(reserveButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let verticalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .top
        return stackView
    }()
    
    private let horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 16
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private var isOverviewExpanded = false
    private var reserveButtonBottomConstraint: Constraint?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        layoutUI()
        addGestureToOverviewLabel()
        fetchMovieDetails()
    }
    
    // MARK: - UI 배치
    private func layoutUI() {
        view.backgroundColor = .black
        
        [posterImageView, horizontalStackView, overviewLabel, reserveButton].forEach { view.addSubview($0) }
        
        [titleLabel, releaseDateLabel, runtimeLabel, genresLabel].forEach { verticalStackView.addArrangedSubview($0) }
        
        horizontalStackView.addArrangedSubview(verticalStackView)
        
        posterImageView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(view.snp.height).multipliedBy(0.6)
        }
        
        horizontalStackView.snp.makeConstraints { make in
            make.top.equalTo(posterImageView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        overviewLabel.snp.makeConstraints { make in
            make.top.equalTo(horizontalStackView.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        reserveButton.snp.makeConstraints { make in
            make.top.equalTo(overviewLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(300)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
    }
    
    // MARK: - 기본 데이터 설정
    private func configureUI() {
        titleLabel.text = "Loading..."
        overviewLabel.text = ""
        releaseDateLabel.text = ""
        runtimeLabel.text = ""
        genresLabel.text = ""
    }
    
    private func addGestureToOverviewLabel() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleOverviewExpansion))
        overviewLabel.addGestureRecognizer(tapGesture)
    }
    
    @objc private func toggleOverviewExpansion() {
        isOverviewExpanded.toggle()
        
        overviewLabel.numberOfLines = isOverviewExpanded ? 0 : 3
        
        UIView.animate(withDuration: 0.3) {
            // 숨겨진 예매 버튼의 위치를 레이아웃 조정에 따라 업데이트
            self.reserveButtonBottomConstraint?.update(offset: self.isOverviewExpanded ? -40 : -20)
            self.view.layoutIfNeeded()
        }
    }
    
    // 메인 뷰에서 데이터 받아서 데이터 연결 예정 ....
//    // MARK: - 데이터 설정
//    private func configureUI() {
//        guard let movie = movie else { return }
//        titleLabel.text = movie.title
//        overviewLabel.text = movie.overview
//        runtimeLabel.text = "Runtime: \(movie.runtime) minutes"
//        genresLabel.text = "Genres: \(movie.genres.joined(separator: ", "))"
//        posterImageView.image = movie.posterImage
//    }
    
    // API 요청해서 더미 데이터 추출 중... 삭제 예정
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
                self.releaseDateLabel.text = "ReleaseDate: \(details.releaseDate)"
                self.runtimeLabel.text = "Runtime: \(details.runtime) minutes"
                self.genresLabel.text = "Genres: \(details.genres.map { $0.name }.joined(separator: ", "))"
                
                // 포스터 이미지 설정
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
        //let reservationVC = ReservationViewController() // 예매 페이지로 이동
        //navigationController?.pushViewController(reservationVC, animated: true)
    }
}
