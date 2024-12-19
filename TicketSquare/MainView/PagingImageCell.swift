import UIKit
import SnapKit

class PagingImageCell: UICollectionViewCell {
    
    // 셀 재사용 식별자 id
    static let identifier = "PagingImageCell"
    
    // 버튼 클릭 시 실행될 클로저
    var buttonAction: ((MovieDetails, UIImage) -> Void)?
    
    private var movieDetails: MovieDetails? = nil
    private var posterImage: UIImage? = nil
    
    // 이미지 뷰 설정
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill // 이미지 비율을 유지하지 않고 셀 전체를 채움
        imageView.clipsToBounds = true // 이미지가 셀의 경계를 넘어가지 않도록 설정
        imageView.layer.cornerRadius = 10 // 셀의 모서리 둥글게 설정
        imageView.backgroundColor = .lightGray // 이미지 로딩 중에 표시될 배경색
        return imageView
    }()
    
    // 버튼 클릭 이벤트 처리
    private let button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        return button
    }()
    
    // 셀 초기화 메서드
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 셀의 contentView에 imageView를 추가
        contentView.addSubview(imageView)
        contentView.addSubview(button)
        
        // 이미지 뷰 레이아웃 설정
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        button.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        // 버튼 액션 추가
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    // 초기화 메서드 : 스토리보드 사용 시 호출되나 현재 코드에서는 fatalError 처리
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.movieDetails = nil
        self.imageView.image = nil
    }
    
    // 외부에서 호출해 데이터를 설정하는 메서드
    func configure(with movie: Movie) {
        let imageURL = APIManager.shared.getImageURL(for: movie.posterPath)
        
        // 이미지 설정
        getImage(from: imageURL)
        
        // MovieDetails 설정
        APIManager.shared.fetchMovieDetails(movieID: movie.id) { [weak self] movieDetails, error in
            guard let self,
                  let movieDetails,
                  error == nil else { return }
            self.movieDetails = movieDetails
        }
    }
    
    // URL로부터 이미지를 비동기적으로 가져오는 메서드
    private func getImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self,
                  let data,
                  let response = response as? HTTPURLResponse,
                  error == nil else {
                print("데이터 요청 실패: \(error?.localizedDescription ?? "알 수 없는 에러")")
                return
            }

            if !(200..<300).contains(response.statusCode) {
                print("StatusCode: \(response.statusCode)")
                return
            }

            guard let image = UIImage(data: data) else {
                print("이미지 변환 실패")
                return
            }

            DispatchQueue.main.async {
                self.posterImage = image
                self.imageView.image = image
            }
        }.resume()
    }
    
    @objc private func buttonTapped() {
        guard let movieDetails = movieDetails, let posterImage = posterImage else { return }
        buttonAction?(movieDetails, posterImage)
      }
}
