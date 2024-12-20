




import SnapKit
import UIKit

class MovieDetailViewController: UIViewController {
    
    // 영화 데이터
    var movieDetails: MovieDetails?
    var posterImage: UIImage?
    var onPushViewController: ((UIViewController) -> Void)?
    // MARK: - UI 요소 선언
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textColor = .white
        return label
    }()
    
    private let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .white
        return label
    }()
    
    private let runtimeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .white
        return label
    }()
    
    private let genresLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .white
        return label
    }()
    
    private let overviewScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = true
        scrollView.isScrollEnabled = false // 초기 상태에서는 스크롤 비활성화
        return scrollView
    }()
    
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.textColor = .white
        label.numberOfLines = 3
        return label
    }()
    
    private let reserveButton: UIButton = {
        let button = UIButton()
        button.setTitle("예매하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColorStyle.bg
        button.layer.cornerRadius = 8
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.addTarget(self, action: #selector(reserveButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private var isOverviewExpanded = false
    private var fullOverviewText: String? // 전체 개요 텍스트 저장
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        layoutUI()
        addGestureToOverviewLabel()
    }
    
    // MARK: - UI 배치
    private func layoutUI() {
        view.backgroundColor = UIColorStyle.bg
        
        [posterImageView, overviewScrollView, reserveButton].forEach { view.addSubview($0) }
        
        let verticalStackView = UIStackView(arrangedSubviews: [titleLabel, releaseDateLabel, runtimeLabel, genresLabel])
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 5
        verticalStackView.alignment = .top
        view.addSubview(verticalStackView)
        
        overviewScrollView.addSubview(overviewLabel)
        
        posterImageView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(view.snp.height).multipliedBy(0.6)
        }
        
        verticalStackView.snp.makeConstraints { make in
            make.top.equalTo(posterImageView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
        }
        
        overviewScrollView.snp.makeConstraints { make in
            make.top.equalTo(verticalStackView.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(80)
        }
        
        overviewLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        reserveButton.snp.makeConstraints { make in
            make.top.equalTo(overviewScrollView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(300)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
        }
    }
    
    private func addGestureToOverviewLabel() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleOverviewExpansion))
        overviewScrollView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func toggleOverviewExpansion() {
        isOverviewExpanded.toggle()
        
        UIView.animate(withDuration: 0.3) {
            if self.isOverviewExpanded {
                self.overviewLabel.numberOfLines = 0
                self.overviewLabel.text = self.fullOverviewText // 전체 텍스트 표시
                self.overviewScrollView.isScrollEnabled = true
                self.overviewScrollView.snp.updateConstraints { make in
                    make.height.equalTo(200)
                }
            } else {
                self.overviewLabel.numberOfLines = 3
                self.overviewLabel.text = self.firstSentence(from: self.fullOverviewText) // 첫 문장만 표시
                self.overviewScrollView.isScrollEnabled = false
                self.overviewScrollView.snp.updateConstraints { make in
                    make.height.equalTo(80)
                }
            }
            self.view.layoutIfNeeded()
        }
    }
    
    func configure(with details: MovieDetails, posterImage: UIImage) {
        self.movieDetails = details
        self.posterImage = posterImage
        updateUI()
    }
    
    private func updateUI() {
        if let details = movieDetails {
            titleLabel.text = details.title
            releaseDateLabel.text = "개봉일: \(details.releaseDate)"
            runtimeLabel.text = "상영 시간: \(details.runtime) 분"
            genresLabel.text = "장르: \(details.genres.map { $0.name }.joined(separator: ", "))"
            fullOverviewText = details.overview // 전체 텍스트 저장
            overviewLabel.text = firstSentence(from: details.overview) // 첫 문장만 표시
            
            if let posterImage = posterImage {
                posterImageView.image = posterImage
            } else {
                posterImageView.image = UIImage(named: "placeholder")
            }
        } else {
            titleLabel.text = "Loading..."
            overviewLabel.text = ""
            releaseDateLabel.text = ""
            runtimeLabel.text = ""
            genresLabel.text = ""
        }
    }
    
    private func firstSentence(from text: String?) -> String? {
        guard let text = text else { return nil }
        let delimiters: CharacterSet = [".", "!"]
        if let range = text.rangeOfCharacter(from: delimiters) {
            return String(text[..<range.upperBound]) // 첫 번째 문장 반환
        }
        return text // 구분자가 없으면 전체 텍스트 반환
    }
    
    // MARK: - 예매 버튼 액션
    @objc private func reserveButtonTapped() {
        dismiss(animated: true){ [weak self] in
            guard let self,
                  let movieDetails = self.movieDetails else { return }
            
            let ticketingViewController = TicketingViewController()
            ticketingViewController.configure(movieDetails)
            
            self.onPushViewController?(ticketingViewController)
        }
    }
}
