//
//  SearchResultView.swift
//  TicketSquare
//
//  Created by 안준경 on 12/17/24.
//

import UIKit
import SnapKit

class SearchResultView: UIView {
    
    private let searchBar: UISearchBar = {
        var searchBar = UISearchBar()
        searchBar.placeholder = "영화를 검색해보세요."
        searchBar.searchTextField.font = .systemFont(ofSize: 18)
        searchBar.setImage(UIImage(), for: UISearchBar.Icon.search, state: .normal)
        return searchBar
    }()
    
    private let searchButton: UIButton = {
        var button = UIButton()
        button.setTitle("검색", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 15
        return button
    }()
    
    let collectionView: UICollectionView = {
        //레이아웃 설정
        let layout = UICollectionViewCompositionalLayout { sectionIndex, layoutEnvironment in
            return createImageSection()
        }
        //컬렉션뷰 초기화 및 설정
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .black        
        return collectionView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpView() {
        let safeArea = safeAreaLayoutGuide
        backgroundColor = .black
                
        addSubview(searchBar)
        addSubview(searchButton)
        addSubview(collectionView)
        
        searchBar.snp.makeConstraints {
            $0.top.equalTo(safeArea.snp.top)
            $0.leading.equalToSuperview()
            $0.trailing.equalTo(searchButton.snp.leading).inset(-10)
            $0.height.equalTo(50)
        }
        
        searchButton.snp.makeConstraints {
            $0.centerY.equalTo(searchBar)
            $0.trailing.equalToSuperview()
            $0.width.equalTo(80)
            $0.height.equalTo(45)
        }
        
        collectionView.snp.makeConstraints{
            $0.top.equalTo(searchBar.snp.bottom).offset(20)
            $0.bottom.leading.trailing.equalTo(safeArea)
        }
    }
    
    //이미지 섹션 레이아웃 설정
    private static func createImageSection() -> NSCollectionLayoutSection {
        //아이템 설정
        let itemSize = NSCollectionLayoutSize(widthDimension: .absolute(120), heightDimension: .absolute(160))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)

        //그룹 설정
        let groupSize = NSCollectionLayoutSize(widthDimension: .estimated(600), heightDimension: .absolute(160))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        //섹션 설정
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .continuous//가로 스크롤
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0)//여백
        
        return section
    }
}
