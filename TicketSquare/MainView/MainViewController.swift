//
//  MainViewController.swift
//  TicketSquare
//
//  Created by 강민성 on 12/16/24.
//

import SnapKit
import UIKit

// 영화 섹션을 나타내는 열거형.
enum MovieSection: Int, CaseIterable {
    case popular = 0  // 인기영화
    case upcoming  // 최신영화
    case nowPlaying  // 현재 상영 중인 영화
    case topRated  // 최고 등급 영화
}

class MainViewController: UIViewController {
    
    private var autoScrollTimer: Timer?  // 자동 스크롤 타이머
    private var currentPage = 0  // 현재 페이지 인덱스
    
    // 제목 영역을 감싸는 컨테이너 뷰
    private let titleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColorStyle.bg
        return view
    }()
    
    // 제목 레이블 설정
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Ticket Square"  // 제목 텍스트 설정
        label.font = UIFont.boldSystemFont(ofSize: 30)  // 글씨 굵기와 글씨체 크기 설정
        label.textColor = .white
        return label
    }()
    
    // 메인 컬렉션 뷰 큰 이미지 섹션과 작은 이미지 섹션을 표시
    private let collectionView: UICollectionView = {
        // CompositionalLayout 설정 : 섹션마다 다른 레이아웃 설정
        let layout = UICollectionViewCompositionalLayout {
            sectionIndex, layoutEnvironment in
            switch sectionIndex {
            case 0:  // 첫 번째 섹션 큰 이미지
                return MainViewController.createPagingSection()
            default:  // 두 번째 섹션 이후 작은 이미지
                return MainViewController.createSmallImageSection()
            }
        }
        // UICollectionView 초기화 및 설정
        let collectionView = UICollectionView(
            frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = UIColorStyle.bg
        return collectionView
    }()
    
    // 인기 영화 데이터를 저장할 배열
    private var popularMovies: [Movie] = []
    // 최신 영화 데이터를 저장할 배열
    private var upcomingMovies: [Movie] = []
    // 현재 상영 중인 영화 데이터를 저장할 배열
    private var nowPlayingMovies: [Movie] = []
    // 최고 등급 영화 데이터를 저장할 배열
    private var topRatedMovies: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        setupViews()  // 뷰 구성하는 메서드 호출
        fetchMovies()  // 영화 데이터를 가져오는 메서드 호출
        startAutoScroll()
    }
    
    private func startAutoScroll() {
        stopAutoScroll()
        autoScrollTimer = Timer.scheduledTimer(
            timeInterval: 3.0,  // 3초마다 실행
            target: self,
            selector: #selector(scrollToNextPage),
            userInfo: nil,
            repeats: true
        )
    }
    
    private func stopAutoScroll() {
        autoScrollTimer?.invalidate()
        autoScrollTimer = nil
    }
    
    // 다음 페이지로 스크롤
    @objc private func scrollToNextPage() {
        let totalItems = collectionView.numberOfItems(inSection: 0)
        guard totalItems > 0 else { return }
        
        let nextPage = (currentPage + 1) % totalItems  // 다음 페이지 계산
        let nextIndexPath = IndexPath(item: nextPage, section: 0)
        
        collectionView.scrollToItem(at: nextIndexPath, at: .centeredHorizontally, animated: true)
        currentPage = nextPage  // 현재 페이지 업데이트
    }
    
    private func setupViews() {
        view.backgroundColor = UIColorStyle.bg  // 전체 화면 배경색 설정
        
        // 제목 컨테이너 뷰 추가
        view.addSubview(titleView)
        titleView.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)  // safeArea와 일치하게 설정
            $0.height.equalTo(60)  // 높이 60으로 설정
        }
        
        // 제목 레이블 추가
        titleView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(20)  // 왼쪽에서 20만큼 여백 설정
            $0.centerY.equalToSuperview()  // 수직 중앙에 정렬
        }
        
        // 메인 컬렉션 뷰 추가
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.top.equalTo(titleView.snp.bottom)  // 제목 아래에 배치 설정
            $0.leading.trailing.bottom.equalToSuperview()  // 좌우와 아래 맞춤 설정
        }
        
        collectionView.delegate = self // 델리게이트 설정
        collectionView.dataSource = self  // 데이터 소스 설정
        collectionView.register(
            PagingImageCell.self,
            forCellWithReuseIdentifier: PagingImageCell.identifier)  // 큰 이미지 셀 등록
        collectionView.register(
            SmallImageCell.self,
            forCellWithReuseIdentifier: SmallImageCell.identifier)  // 작은 이미지 셀 등록
        
        collectionView.register(
            HeaderView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: HeaderView.identifier
        )
    }
    
    // API를 통해 영화 데이터를 가져오는 메서드
    private func fetchMovies() {
        let group = DispatchGroup()  // 여러 작업의 동기화를 위한 DispatchGroup 생성
        
        // 인기 영화 데이터를 가져옴
        group.enter()
        APIManager.shared.fetchPopularMovies(page: 1) { [weak self] movies, _ in
            guard let self,
                let movies else {
                group.leave()
                return
            }
            
            self.popularMovies = movies// 데이터를 가져와 popularMovies에 저장
            group.leave()
        }
        
        // 최신 영화 데이터를 가져옴 (장르 포함)
        group.enter()
        APIManager.shared.fetchUpcomingMovies(page: 1) { [weak self] movies, _ in
            guard let self,
                let movies else {
                group.leave()
                return
            }
            
            self.upcomingMovies = movies
            group.leave()
        }
        
        // 현재 상영 중인 영화 데이터를 가져옴 (장르 포함)
        group.enter()
        APIManager.shared.fetchNowPlayingMovies(page: 1) { [weak self] movies, _ in
            guard let self,
                let movies else {
                group.leave()
                return
            }
            
            self.nowPlayingMovies = movies
            group.leave()
        }
        
        // 최고 등급 영화 데이터를 가져옴 (장르 포함)
        group.enter()
        APIManager.shared.fetchTopRatedMovies(page: 1) { [weak self] movies, _ in
            guard let self,
                let movies else {
                group.leave()
                return
            }
            
            self.topRatedMovies = movies
            group.leave()
        }
        
        // 모든 데이터를 가져오면 컬렉션 뷰를 새로고침
        group.notify(queue: .main) {
            self.collectionView.reloadData()
        }
    }
    
    // 큰 이미지 섹션 레이아웃
    private static func createPagingSection() -> NSCollectionLayoutSection {
        
        // 아이템 사이즈 설정 그룹 전체 너비/높이
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // 그룹 설정 너비 85%, 높이 500pt
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.85),
            heightDimension: .absolute(500))
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize, subitems: [item])
        
        // 섹션 설정
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPagingCentered  // 가로 페이징 방식
        
        // 섹션 여백 설정
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0, leading: 10, bottom: 0, trailing: 10)
        
        // 아이템 사이의 간격 설정
        section.interGroupSpacing = 15  // 그룹 사이 간격 설정
        
        return section
    }
    
    // 작은 이미지 섹션 레이아웃 설정
    private static func createSmallImageSection() -> NSCollectionLayoutSection {
        // 아이템 사이즈 설정
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .absolute(120),  // 아이템 너비를 120으로 설정
            heightDimension: .absolute(160))  // 아이템 높이를 160으로 설정
        
        // 아이템 구성
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // 아이템 여백 설정
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 10,  // 위쪽에서 10 설정
            leading: 10,  // 왼쪽에서 10 설정
            bottom: 10,  // 아래쪽에서 10 설정
            trailing: 10)  // 오른쪽에서 10 설정
        
        // 그룹 사이즈 설정
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .estimated(600),  // 그룹 너비를 예상값으로 설정
            heightDimension: .absolute(160))  // 그룹 높이는 160으로 설정
        
        // 그룹 구성
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,  // 그룹 크기 설정
            subitems: [item])  // 그룹 안에 아이템 배열
        
        // 섹션 설정
        let section = NSCollectionLayoutSection(group: group)
        
        // 섹션 스크롤 동작 설정 (가로로 연속 스크롤)
        section.orthogonalScrollingBehavior = .continuous
        
        // 섹션 여백 설정
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 5,  // 위쪽에서 10 설정
            leading: 0,  // 왼쪽 여백 없음
            bottom: 15,  // 아래쪽에서 10 설정
            trailing: 0)  // 오른쪽 여백 없음
        
        // 헤더 설정
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(50))
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top)
        
        header.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 0,
            bottom: -38,
            trailing: 0
        )
        
        section.boundarySupplementaryItems = [header]

        return section
    }
}

// 데이터 소스 설정
extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    

    // 섹션 개수 변환
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return MovieSection.allCases.count  // 열거형의 정의된 모든 케이스의 개수를 섹션 개수로 사용
    }
    
    // 각 섹션의 아이템 개수 반환
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let movieSection = MovieSection(rawValue: section) else {
            return 0
        }  // 각 섹션에 있는 아이템의 개수를 반환하는 메서드
        switch movieSection {  // 열거형에서 현재 섹션에 해당하는 케이스를 가져옴
        case .popular: return popularMovies.count  // 인기 영화 섹션 : popularMovies 배열의 개수를 반환
        case .upcoming: return upcomingMovies.count  // 최신 영화 섹션 : upcomingMovies 배열의 개수를 반환
        case .nowPlaying: return nowPlayingMovies.count  // 현재 상영 중 섹션 : nowPlayingMovies 배열의 개수를 반환
        case .topRated: return topRatedMovies.count  // 최고 등급 영화 섹션 : topRatedMovies 배열의 개수를 반환
        }
    }
    
    // 사용자가 스크롤할 경우 자동 스크롤 중지
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        stopAutoScroll()
    }
    
    
    // 각 아이템의 셀 생성
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let movieSection = MovieSection(rawValue: indexPath.section)
        else {
            return UICollectionViewCell()
        }
        
        switch movieSection {
        case .popular:  // 인기 영화: 장르 없이 처리
            let cell =
            collectionView.dequeueReusableCell(
                withReuseIdentifier: PagingImageCell.identifier,
                for: indexPath) as! PagingImageCell
            let movie = popularMovies[indexPath.item]
            cell.configure(with: movie)
            
            // 버튼 액션 설정
            cell.buttonAction = { [weak self] movieDetails, image in
                self?.presentMovieDetailView(movieDetails: movieDetails, image: image)
            }
            
            return cell
            
        case .upcoming:  // 나머지 영화: 장르 포함
            let cell =
            collectionView.dequeueReusableCell(
                withReuseIdentifier: SmallImageCell.identifier,
                for: indexPath) as! SmallImageCell
            let movie = upcomingMovies[indexPath.item]
            cell.configure(by: movie)
            
            // 버튼 액션 추가
            cell.buttonAction = { [weak self] movieDetails, image in
                self?.presentMovieDetailView(movieDetails: movieDetails, image: image)
            }
            
            return cell
            
        case .nowPlaying:
            let cell =
            collectionView.dequeueReusableCell(
                withReuseIdentifier: SmallImageCell.identifier,
                for: indexPath) as! SmallImageCell
            let movie = nowPlayingMovies[indexPath.item]
            cell.configure(by: movie)
            
            // 버튼 액션 추가
            cell.buttonAction = { [weak self] movieDetails, image in
                self?.presentMovieDetailView(movieDetails: movieDetails, image: image)
            }
            return cell
            
        case .topRated:
            let cell =
            collectionView.dequeueReusableCell(
                withReuseIdentifier: SmallImageCell.identifier,
                for: indexPath) as! SmallImageCell
            let movie = topRatedMovies[indexPath.item]
            cell.configure(by: movie)
            
            // 버튼 액션 추가
            cell.buttonAction = { [weak self] movieDetails, image in
                self?.presentMovieDetailView(movieDetails: movieDetails, image: image)
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        // 헤더의 경우에만 처리
        if kind == UICollectionView.elementKindSectionHeader {
            guard let section = MovieSection(rawValue: indexPath.section), section != .popular else {
                return UICollectionReusableView() // popular 섹션은 헤더 반환 X
            }

            // SectionHeaderView 반환
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderView.identifier, for: indexPath) as! HeaderView

            // 섹션에 따른 헤더 타이틀 설정
            switch section {
            case .upcoming:
                headerView.configure(with: "최신 영화")
            case .nowPlaying:
                headerView.configure(with: "현재 상영 중인 영화")
            case .topRated:
                headerView.configure(with: "최고 평점 영화")
            default:
                break
            }
            return headerView
        }
        return UICollectionReusableView()
    }
    
    // 주어진 섹션과 인덱스에 해당하는 영화 반환
    private func getMovie(for section: MovieSection, at index: Int) -> Movie {
        switch section {
        case .upcoming: return upcomingMovies[index]
        case .nowPlaying: return nowPlayingMovies[index]
        case .topRated: return topRatedMovies[index]
        default: fatalError("Invalid section")
        }
    }
    
    private func presentMovieDetailView(movieDetails: MovieDetails, image: UIImage) {
        let detailsVC = MovieDetailViewController()
        detailsVC.configure(with: movieDetails, posterImage: image)
        detailsVC.onPushViewController = { [weak self] viewController in
            guard let self else {
                print("1")
                return }
            self.navigationController?.pushViewController(viewController, animated: true)

            print(self.navigationController)
        }
        self.present(detailsVC, animated: true)
    }
}
