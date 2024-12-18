//
//  SmallImageCell.swift
//  TicketSquare
//
//  Created by 강민성 on 12/16/24.
//

import UIKit
import SnapKit

class SmallImageCell: UICollectionViewCell {
    
    // 셀의 재사용 식별자 id
    static let identifier = "SmallImageCell"
    
    // 영화 이미지 뷰 설정
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill // 이미지 비율을 유지하며 셀 영역을 채움
        imageView.clipsToBounds = true // 이미지가 셀의 경계를 넘지 않도록 잘라냄
        imageView.layer.cornerRadius = 10 // 셀의 모서리를 둥글게 설정
        imageView.backgroundColor = .lightGray // 이미지 로딩 중에 표시될 배경색
        return imageView
    }()
    
    // 영화 제목 레이블 설정
    private let movieTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .white
        label.text = "Movie Title" // 임시 텍스트
        return label
    }()
    
    // 장르 레이블 설정
    private let genreLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .lightGray
        label.text = "Genre" // 임시 텍스트
        return label
    }()
    
    private let button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        return button
    }()
    
    // 버튼이 눌렸을 때 실행될 클로저를 정의
    var buttonAction: (() -> Void)?
    
    // 셀 초기화 메서드
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 셀의 콘텐츠 뷰에 이미지 뷰 추가
        contentView.addSubview(imageView)
        // 셀의 콘텐츠 뷰에 버튼 추가
        contentView.addSubview(button)
        // 셀의 콘텐츠 뷰에 영화 제목 레이블 추가
        contentView.addSubview(movieTitleLabel)
        // 셀의 콘텐츠 뷰에 장르 레이블 추가
        contentView.addSubview(genreLabel)
        
        // 이미지 뷰 레이아웃 설정
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview() // 이미지 뷰가 셀의 전체 영역을 채우도록 오토 레이아웃 설정
        }
        
        // 영화 제목 레이블 레이아웃 설정
        movieTitleLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(5) // 제목 레이블이 이미지 뷰의 아래에 위치하도록 설정, 간격 5
            $0.leading.trailing.equalToSuperview() // 제목 레이블의 왼쪽과 오른쪽이 셀의 경계와 일치 하도록 설정
        }
        
        // 장르 레이블 레이아웃 설정
        genreLabel.snp.makeConstraints {
            $0.top.equalTo(movieTitleLabel.snp.bottom) // 장르 레이블이 제목 레이블의 아래에 위치하도록 설정
            $0.leading.trailing.equalToSuperview() // 장르 레이블의 왼쪽과 오른쪽이 셀의 경계와 일치 하도록 설정
        }
        
        // 버튼 레이아웃 설정
        button.snp.makeConstraints {
            $0.edges.equalToSuperview() // 버튼이 셀의 전체 영역을 차지하도록 레이아웃 설정
        }
        
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
    // 스토리보드 사용 시 호출되는 초기화 메서드
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented") // 스토리보드를 사용하지 않으므로 에러 처리
    }

    // 외부에서 셀에 이미지를 설정하는 메서드
    func configure(with urlString: String, title: String, genre: String? = nil) {
        movieTitleLabel.text = title
        genreLabel.text = genre ?? ""
        
    }

    
    // URL로부터 이미지를 비동기적으로 가져오는 메서드
    private func getImage(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        var request = URLRequest(url: url)

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
    
    @objc private func buttonTapped() {
        buttonAction?()
    }
}
