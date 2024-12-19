//
//  SearchCollectionViewCell.swift
//  TicketSquare
//
//  Created by 안준경 on 12/17/24.
//

import UIKit

class SearchCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "SearchCollectionViewCell"
    
    //MARK: 셀 구성
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true // 이미지가 셀의 경계를 넘지 않도록 잘라냄
        imageView.layer.cornerRadius = 10 // 셀의 모서리를 둥글게 설정
        imageView.backgroundColor = .lightGray // 이미지 로딩 중에 표시될 배경색
        return imageView
    }()
    
    private let button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .white
        label.text = "title"
        return label
    }()
    
    private let genreLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textColor = .white
        label.text = "genre"
        return label
    }()
    
    
    //MARK: 초기화
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: 제약조건 설정
    func setupView(){
        contentView.addSubview(imageView)
        contentView.addSubview(button)
        addSubview(titleLabel)
        addSubview(genreLabel)
        
        [button].forEach{
            $0.snp.makeConstraints{
                $0.edges.equalToSuperview()
            }
        }
        
        imageView.snp.makeConstraints{
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(160)
            $0.width.equalTo(120)
        }
        
        titleLabel.snp.makeConstraints{
            $0.top.equalTo(imageView.snp.bottom).offset(5)
            $0.width.equalTo(120)
        }
        
        genreLabel.snp.makeConstraints{
            $0.top.equalTo(titleLabel.snp.bottom)
            $0.width.equalTo(120)
        }
        
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    
    //MARK: 컬렉션뷰 탭 이벤트
    @objc private func buttonTapped() {
        //TODO: 상세페이지 이동
    }

    //MARK: 이미지 세팅 메소드
    func configure(_ movie: MovieDetails) {
        
        let urlString = APIManager.shared.getImageURL(for: movie.posterPath ?? "")
        fetchImage(urlString)//이미지 호출 & 이미지뷰 세팅
        
        titleLabel.text = movie.title
        genreLabel.text = movie.genresDescribing()
    }
    
    //MARK: 이미지 fetch
    private func fetchImage(_ urlString: String) {
        guard let url = URL(string: urlString) else { return }
        let request = URLRequest(url: url)

        // URLSession을 사용하여 비동기 네트워크 요청
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
                self.imageView.image = image
            }
        }.resume()
    }
    

}
