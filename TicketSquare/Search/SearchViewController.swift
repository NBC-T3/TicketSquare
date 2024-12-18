//
//  SearchViewController.swift
//  TicketSquare
//
//  Created by 안준경 on 12/15/24.
//

import UIKit
import SnapKit

class SearchViewController: UIViewController {
    
    private var searchView = SearchView()
    
    private var movies: [Movie] = []
        
    override func viewDidLoad() {
        view.backgroundColor = .black
        getNowPlayingMovies()
        setUpView()
    }
    
    //MARK: 검색버튼 이벤트
    @objc private func searchButtonTapped() {
        searchView.collectionView.isHidden = false
        searchView.tableView.isHidden = true
        searchView.titleLabel.text = "검색 결과"
    }
    
    //MARK: 제약조건
    private func setUpView() {
        view.addSubview(searchView)
        
        //viewState
        searchView.collectionView.isHidden = true
        
        //테이블뷰
        searchView.tableView.dataSource = self
        searchView.tableView.delegate = self
        searchView.tableView.rowHeight = 50
        searchView.searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        
        //컬렉션뷰
        searchView.collectionView.dataSource = self// 데이터 소스 설정
        searchView.collectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: SearchCollectionViewCell.identifier)
        
        searchView.snp.makeConstraints{
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    //MARK: 더미데이터
    var dummyData: [String] = [
        "베놈",
        "해리포터",
        "스파이더맨"
    ]
    
    // 작은 이미지 URL 배열
    private let smallImageURLs = [
        "https://image.tmdb.org/t/p/w500/1E5baAaEse26fej7uHcjOgEE2t2.jpg",
        "https://image.tmdb.org/t/p/w500/1E5baAaEse26fej7uHcjOgEE2t2.jpg",
        "https://image.tmdb.org/t/p/w500/1E5baAaEse26fej7uHcjOgEE2t2.jpg"
    ]
    
    private func getNowPlayingMovies() {
        APIManager.shared.fetchNowPlayingMovies(page: 1) { movies, error in
            if let data = movies {
                self.movies = data
            }
        }
    }
    
}

//테이블 뷰 셀 관련 코드
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
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
    
    // 각 섹션에 대한 아이템 개수 설정
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return smallImageURLs.count
    }
    
    //셀 구성
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.identifier, for: indexPath) as! SearchCollectionViewCell
        let urlString = smallImageURLs[indexPath.item] //이미지 URL 가져오기
        cell.configure(urlString)// 셀에 이미지 설정
        
        //버튼 클릭 이벤트 설정
        cell.buttonAction = {
            print("작은 이미지 \(indexPath.item + 1) 클릭됨")
        }
        
        return cell
    }

}