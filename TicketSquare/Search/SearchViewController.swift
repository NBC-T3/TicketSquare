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
    private var nowPlayingMovies: [Movie] = []//현재 상영중인 영화
    private var searchedMovies: [Movie] = []//검색된 영화
    private var searchKeyword: [SearchKeyword] = []//키워드로 검색한 결과
    private var movieDetails: [MovieDetails] = []//id로 검색한 결과
    private var filteredItems: [String] = []//검색결과

    override func viewDidLoad() {
        view.backgroundColor = .black
        fetchNowPlayingMovies()
        setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // 뷰 컨트롤러가 나타날 때 네비게이션 숨기기
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        super.viewWillAppear(animated)
        viewReset()//뷰 시작시 초기화된 화면 표시
    }
    
    //뷰 시작시 초기화된 화면 표시
    private func viewReset() {
        searchView.collectionView.isHidden = true
        searchView.tableView.isHidden = false
        searchView.titleLabel.text = "현재 상영중"
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
        
        //컬렉션뷰
        searchView.collectionView.dataSource = self// 데이터 소스 설정
        searchView.collectionView.register(SearchCollectionViewCell.self, forCellWithReuseIdentifier: SearchCollectionViewCell.identifier)
        
        //서치바
        searchView.searchButton.addTarget(self, action: #selector(searchButtonTapped), for: .touchUpInside)
        
        searchView.snp.makeConstraints{
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    //MARK: 검색버튼 이벤트
    @objc private func searchButtonTapped() {
        movieDetails.removeAll()
        
        let text = searchView.searchBar.searchTextField.text
        if let searchText = text {
            searchMovies(searchText)
        }
        
        changeCollectionView()//컬렉션 뷰로 전환
        searchView.searchBar.searchTextField.text = nil
        
    }
    
    //컬렉션 뷰로 전환
    private func changeCollectionView() {
        searchView.collectionView.isHidden = false
        searchView.tableView.isHidden = true
        searchView.titleLabel.text = "검색 결과"
    }
    
    //MARK: 현재 상영중인 영화 fetch
    private func fetchNowPlayingMovies() {
        APIManager.shared.fetchUpcomingMovies(page: 1) { [weak self] movies, _ in
            guard let self,
                let movies else {
                return
            }
            
            self.nowPlayingMovies = movies
            reloadTableView()
        }
    }
    
    //MARK: 키워드로 영화 검색 fetch
    private func searchMovies(_ searchKeyword: String) {
        let group = DispatchGroup()
        
        //이미지
        group.enter()
        APIManager.shared.searchForKeyWordMovies(page: 1, keyWord: searchKeyword) { result, _ in
            if let data = result {
                //self.searchKeyword = data
                for searchMovie in data {
                    APIManager.shared.fetchMovieDetails(movieID: searchMovie.id) { result,_ in
                        if let data = result {
                            self.movieDetails.append(data)
                        }
                    }
                }
            }
            group.leave()
        }
        
        // 모든 데이터를 가져오면 컬렉션 뷰를 새로고침
        group.notify(queue: .main) {
            self.reloadCollectionView()
        }
    }


    //테이블뷰 reload
    func reloadTableView() {
        searchView.tableView.reloadData()
    }
    
    //컬렉션뷰 reload
    func reloadCollectionView() {
        searchView.collectionView.reloadData()
    }
    
    //TODO: 키보드 메소드
    
    
}

//테이블 뷰 셀 관련 코드
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nowPlayingMovies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? SearchTableViewCell else {
            return UITableViewCell()
        }

        cell.configureCell(nowPlayingMovies[indexPath.row].title)
        return cell
    }
     
}


//MARK: 컬렉션 뷰 설정
extension SearchViewController: UICollectionViewDataSource {
    
    //각 섹션에 대한 아이템 개수 설정
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movieDetails.count
    }
    
    //켈렉션뷰 셀 구성
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchCollectionViewCell.identifier, for: indexPath) as! SearchCollectionViewCell
        let movieInfo = movieDetails[indexPath.item]//검색한 영화정보
        
        cell.configure(movieInfo)
        
        return cell
    }

}

//MARK: 검색바 설정
extension SearchViewController: UISearchBarDelegate {
    
    // 유저가 텍스트 입력했을 때
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        reloadCollectionView()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        // 취소 버튼을 누를 때 검색어를 초기화하고 테이블 뷰를 갱신합니다.
        searchBar.text = nil
        searchBar.resignFirstResponder() // 키보드 내림
        reloadCollectionView()
    }
    
    
}


#Preview{
    SearchViewController()
}
