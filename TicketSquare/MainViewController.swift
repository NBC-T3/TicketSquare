//
//  MainViewController.swift
//  TicketSquare
//
//  Created by 강민성 on 12/16/24.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {
    
    // 제목 영역을 감싸는 컨테이너 뷰
    private let titleView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    // 제목 레이블 설정
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Ticket Square"
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textColor = .white
        return label
    }()
    
    // 메인 컬렉션 뷰 큰 이미지 섹션과 작은 이미지 섹션을 표시
    private let collectionView: UICollectionView = {
        // CompositionalLayout 설정 : 섹션마다 다른 레이아웃 설정
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            switch sectionIndex {
            case 0: // 첫 번째 섹션 큰 이미지
                return MainViewController.createPagingSection()
            default: // 두 번째 섹션 이후 작은 이미지
                return MainViewController.createSmallImageSection()
            }
        }
        // UICollectionView 초기화 및 설정
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .black
        return collectionView
    }()
    
    // 큰 이미지 URL 배열
    private let bigImageURLs = [
        "https://image.tmdb.org/t/p/w500/1E5baAaEse26fej7uHcjOgEE2t2.jpg",
        "https://image.tmdb.org/t/p/w500/1E5baAaEse26fej7uHcjOgEE2t2.jpg",
        "https://image.tmdb.org/t/p/w500/1E5baAaEse26fej7uHcjOgEE2t2.jpg"
    ]
    
    // 작은 이미지 URL 배열
    private let smallImageURLs = [
        "https://image.tmdb.org/t/p/w500/1E5baAaEse26fej7uHcjOgEE2t2.jpg",
        "https://image.tmdb.org/t/p/w500/1E5baAaEse26fej7uHcjOgEE2t2.jpg",
        "https://image.tmdb.org/t/p/w500/1E5baAaEse26fej7uHcjOgEE2t2.jpg",
        "https://image.tmdb.org/t/p/w500/1E5baAaEse26fej7uHcjOgEE2t2.jpg",
        "https://image.tmdb.org/t/p/w500/1E5baAaEse26fej7uHcjOgEE2t2.jpg"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        view.backgroundColor = .black // 전체 화면 배경색 설정
        
        // 제목 컨테이너 뷰 추가
        view.addSubview(titleView)
        titleView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide) // safeArea와 일치하게 설정
            $0.height.equalTo(60) // 높이 60으로 설정
        }
        
        // 제목 레이블 추가
        titleView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20) // 왼쪽에서 20만큼 여백 설정
            $0.centerY.equalToSuperview() // 수직 중앙에 정렬
        }
        
        // 메인 컬렉션 뷰 추가
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.equalTo(titleView.snp.bottom) // 제목 아래에 배치 설정
            $0.leading.trailing.bottom.equalToSuperview() // 좌우와 아래 맞춤 설정
        }
        
        collectionView.dataSource = self // 데이터 소스 설정
        // 셀 등록 큰 이미지, 작은 이미지
        collectionView.register(PagingImageCell.self, forCellWithReuseIdentifier: PagingImageCell.identifier)
        collectionView.register(SmallImageCell.self, forCellWithReuseIdentifier: SmallImageCell.identifier)
    }
    
    // 큰 이미지 섹션 레이아웃
    private static func createPagingSection() -> NSCollectionLayoutSection {
        
        // 아이템 사이즈 설정 그룹 전체 너비/높이
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // 그룹 설정 너비 85%, 높이 500pt
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.85), heightDimension: .absolute(500))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        // 섹션 설정
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered // 페이징 방식
        
        // 섹션 여백 설정
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10)
        
        // 아이템 사이의 간격 설정
        section.interGroupSpacing = 15 // 그룹 사이 간격 설정

        return section
    }
    
    // 작은 이미지 섹션 레이아웃 설정
    private static func createSmallImageSection() -> NSCollectionLayoutSection {
        // 아이템 사이즈 설정
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(120), // 아이템 너비를 120으로 설정
                                              heightDimension: .absolute(160)) // 아이템 높이를 160으로 설정
        
        // 아이템 구성
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // 아이템 여백 설정
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, // 위쪽에서 10 설정
                                                     leading: 10, // 왼쪽에서 10 설정
                                                     bottom: 10, // 아래쪽에서 10 설정
                                                     trailing: 10) // 오른쪽에서 10 설정
        
        // 그룹 사이즈 설정
        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(600), // 그룹 너비를 예상값으로 설정
                                               heightDimension: .absolute(160)) // 그룹 높이는 160으로 설정
        
        // 그룹 구성
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, // 그룹 크기 설정
                                                       subitems: [item]) // 그룹 안에 아이템 배열
        
        // 섹션 설정
        let section = NSCollectionLayoutSection(group: group)
        
        // 섹션 스크롤 동작 설정 (가로로 연속 스크롤)
        section.orthogonalScrollingBehavior = .continuous
        
        // 섹션 여백 설정
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, // 위쪽에서 10 설정
                                                        leading: 0, // 왼쪽 여백 없음
                                                        bottom: 10, // 아래쪽에서 10 설정
                                                        trailing: 0) // 오른쪽 여백 없음
        return section
    }
}

// 데이터 소스 설정
extension MainViewController: UICollectionViewDataSource {
    
    // 섹션 수 설정
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4 // 큰 이미지 섹션 1개 + 작은 이미지 섹션 3개
    }
    
    // 각 섹션에 대한 아이템 개수 설정
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 섹션이 0번 이라면 큰 이미지 URL 반환
        // 그외 라면 작은 이미지 URL 반환
        return section == 0 ? bigImageURLs.count : smallImageURLs.count
    }
    
    // 셀 구성
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // 섹션이 0번일 경우
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PagingImageCell.identifier, for: indexPath) as! PagingImageCell
            let urlString = bigImageURLs[indexPath.item] // 큰 이미지 URL 가져오기
            cell.configure(with: urlString) // 셀에 이미지 설정
            
            // 버튼 클릭 이벤트 설정
            cell.buttonAction = {
                print("큰 이미지 \(indexPath.item + 1) 클릭됨")
            }
            
            return cell
        } else {
            // 작은 이미지 셀 구성
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SmallImageCell.identifier, for: indexPath) as! SmallImageCell
            let urlString = smallImageURLs[indexPath.item] // 작은 이미지 URL 가져오기
            cell.configure(with: urlString) // 셀에 이미지 설정
            
            // 버튼 클릭 이벤트 설정
            cell.buttonAction = {
                print("작은 이미지 \(indexPath.item + 1) 클릭됨")
            }
            
            return cell
        }
    }
}
