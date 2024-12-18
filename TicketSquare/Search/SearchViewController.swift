//
//  SearchViewController.swift
//  TicketSquare
//
//  Created by 안준경 on 12/15/24.
//

import UIKit
import SnapKit

//검색페이지 화면 설정
enum SearchMode {
    case searchMain
    case searchResult
}

class SearchViewController: UIViewController {
    
    private lazy var searchMainView: SearchMainView = .init()
    private lazy var searchResultView: SearchResultView = .init()
    var mode: SearchMode
    
    init(mode: SearchMode) {
        self.mode = mode
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .black

        setUpCell()
        setUpView()
    }
    
    private func setUpCell() {
        searchMainView.tableView.dataSource = self
        searchMainView.tableView.delegate = self
        searchMainView.tableView.rowHeight = 50
        
        searchResultView.collectionView.dataSource = self// 데이터 소스 설정
        searchResultView.collectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: SearchCollectionViewCell.identifier)
    }
    
    private func setUpView() {
        view.addSubview(searchMainView)
        view.addSubview(searchResultView)
        
        searchMainView.snp.makeConstraints{
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        searchResultView.snp.makeConstraints{
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
    }
     
    var dummyData: [String] = [
            "베놈",
            "해리포터",
            "스파이더맨",
            "베놈",
            "해리포터",
            "스파이더맨",
            "베놈",
            "해리포터",
            "스파이더맨"
    ]
    
    // 작은 이미지 URL 배열
    private let smallImageURLs = [
        "https://image.tmdb.org/t/p/w500/1E5baAaEse26fej7uHcjOgEE2t2.jpg",
        "https://image.tmdb.org/t/p/w500/1E5baAaEse26fej7uHcjOgEE2t2.jpg",
        "https://image.tmdb.org/t/p/w500/1E5baAaEse26fej7uHcjOgEE2t2.jpg",
        "https://image.tmdb.org/t/p/w500/1E5baAaEse26fej7uHcjOgEE2t2.jpg",
        "https://image.tmdb.org/t/p/w500/1E5baAaEse26fej7uHcjOgEE2t2.jpg"
    ]
    
}

//테이블 뷰 셀 관련 코드
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dummyData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? SearchTableViewCell else {
            return UITableViewCell()
        }
        
        cell.configureCell(dummyData[indexPath.row])
        
        return cell
    }
}


//컬렉션 뷰 관련 코드
//데이터 소스 설정
extension SearchViewController: UICollectionViewDataSource {
    
    // 섹션 수 설정
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    // 각 섹션에 대한 아이템 개수 설정
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return smallImageURLs.count
    }
    
    //셀 구성
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.identifier, for: indexPath) as! SearchCollectionViewCell
        let urlString = smallImageURLs[indexPath.item] //이미지 URL 가져오기
        cell.configure(with: urlString)// 셀에 이미지 설정
        
        //버튼 클릭 이벤트 설정
        cell.buttonAction = {
            print("작은 이미지 \(indexPath.item + 1) 클릭됨")
        }
        
        return cell
    }
    
    //헤더
//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: SearchCollectionHeaderView.identifier, for: indexPath) as? SearchCollectionHeaderView else {
//            return SearchCollectionHeaderView()
//        }
//        header.configure()
//        return header
//    }
}

#Preview{
    SearchViewController(mode: .searchMain)
}
