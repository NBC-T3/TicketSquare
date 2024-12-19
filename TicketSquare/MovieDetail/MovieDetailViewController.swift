import UIKit
import SnapKit

class MovieDetailViewController: UIViewController {
    
    // 영화 데이터
    var movieDetails: MovieDetails?
    var posterImage: UIImage?
    // MARK: - UI 요소 선언
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .top
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textColor = .white
        return label
    }()
    
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.textColor = .white
        label.numberOfLines = 3
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
        button.setTitle("예매하기", for: .normal)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        layoutUI()
        addGestureToOverviewLabel()
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
            make.top.equalTo(horizontalStackView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(80)
        }
        
        reserveButton.snp.makeConstraints { make in
            make.top.equalTo(overviewLabel.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(300)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
    }
    
    private func addGestureToOverviewLabel() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleOverviewExpansion))
        overviewLabel.addGestureRecognizer(tapGesture)
    }
    
    @objc private func toggleOverviewExpansion() {
        isOverviewExpanded.toggle()
        
        UIView.animate(withDuration: 0.3) {
            if self.isOverviewExpanded {
                self.overviewLabel.numberOfLines = 0 // 제한 없는 레이아웃
                self.overviewLabel.snp.updateConstraints { make in
                    make.height.equalTo(200) // 레이블이 확장될 공간
                }
            } else {
                self.overviewLabel.numberOfLines = 3
                self.overviewLabel.snp.updateConstraints { make in
                    make.height.equalTo(80) // 기본 크기로 설정
                }
            }
            self.view.layoutIfNeeded() // 레이아웃 업데이트
        }
    }
    
    func configure(with details: MovieDetails, posterImage: UIImage) {
        self.movieDetails = details
        self.posterImage = posterImage
        updateUI() // UI 업데이트
    }
    
    private func updateUI() {
        if let details = movieDetails {
            titleLabel.text = details.title
            releaseDateLabel.text = "ReleaseDate: \(details.releaseDate)"
            runtimeLabel.text = "Runtime: \(details.runtime) minutes"
            overviewLabel.text = details.overview
            genresLabel.text = "Genres: \(details.genres.map { $0.name }.joined(separator: ", "))"
            
            // 포스터 이미지 설정
            if let posterImage = posterImage {
                posterImageView.image = posterImage
            } else {
                posterImageView.image = UIImage(named: "placeholder") // 기본 이미지
            }
        } else {
            titleLabel.text = "Loading..."
            overviewLabel.text = ""
            releaseDateLabel.text = ""
            runtimeLabel.text = ""
            genresLabel.text = ""
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
