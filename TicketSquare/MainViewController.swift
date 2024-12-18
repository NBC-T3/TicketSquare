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

    // 제목 영역을 감싸는 컨테이너 뷰
    private let titleView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
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
        collectionView.backgroundColor = .black
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

    private var details: [MovieDetails] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()  // 뷰 구성하는 메서드 호출
        fetchMovies()  // 영화 데이터를 가져오는 메서드 호출
    }

    private func setupViews() {
        view.backgroundColor = .black  // 전체 화면 배경색 설정

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

        collectionView.dataSource = self  // 데이터 소스 설정
        collectionView.register(
            PagingImageCell.self,
            forCellWithReuseIdentifier: PagingImageCell.identifier)  // 큰 이미지 셀 등록
        collectionView.register(
            SmallImageCell.self,
            forCellWithReuseIdentifier: SmallImageCell.identifier)  // 작은 이미지 셀 등록
    }

    // API를 통해 영화 데이터를 가져오는 메서드
    private func fetchMovies() {
        let group = DispatchGroup()  // 여러 작업의 동기화를 위한 DispatchGroup 생성

        // 인기 영화 데이터를 가져옴
        group.enter()
        APIManager.shared.fetchPopularMovies(page: 1) { movies, _ in
            self.popularMovies = movies ?? []  // 데이터를 가져와 popularMovies에 저장
            guard let movies = movies else { return }
            group.leave()
        }

        // 최신 영화 데이터를 가져옴 (장르 포함)
        group.enter()
        APIManager.shared.fetchUpcomingMovies(page: 1) { movies, _ in
            guard let movies = movies else {
                group.leave()
                return
            }

            let dispatchGroup = DispatchGroup()
            for movie in movies {
                dispatchGroup.enter()
                APIManager.shared.fetchMovieDetails(movieID: movie.id) {
                    details, _ in
                    if let details = details {
                        self.details.append(details)
                    }
                    dispatchGroup.leave()
                }
            }

            dispatchGroup.notify(queue: .main) {
                self.upcomingMovies = movies
                group.leave()
            }
        }

        // 현재 상영 중인 영화 데이터를 가져옴 (장르 포함)
        group.enter()
        APIManager.shared.fetchNowPlayingMovies(page: 1) { movies, _ in
            guard let movies = movies else {
                group.leave()
                return
            }

            let dispatchGroup = DispatchGroup()
            for movie in movies {
                dispatchGroup.enter()
                APIManager.shared.fetchMovieDetails(movieID: movie.id) {
                    details, _ in
                    if let details = details {
                        self.details.append(details)
                    }
                    dispatchGroup.leave()
                }
            }

            dispatchGroup.notify(queue: .main) {
                self.nowPlayingMovies = movies
                group.leave()
            }
        }

        // 최고 등급 영화 데이터를 가져옴 (장르 포함)
        group.enter()
        APIManager.shared.fetchTopRatedMovies(page: 1) { movies, _ in
            guard let movies = movies else {
                group.leave()
                return
            }

            let dispatchGroup = DispatchGroup()
            for movie in movies {
                dispatchGroup.enter()
                APIManager.shared.fetchMovieDetails(movieID: movie.id) {
                    details, _ in
                    if let details = details {
                        self.details.append(details)
                    }
                    dispatchGroup.leave()
                }
            }

            dispatchGroup.notify(queue: .main) {
                self.topRatedMovies = movies
                group.leave()
            }
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
            top: 10,  // 위쪽에서 10 설정
            leading: 0,  // 왼쪽 여백 없음
            bottom: 10,  // 아래쪽에서 10 설정
            trailing: 0)  // 오른쪽 여백 없음
        return section
    }
}

// 데이터 소스 설정
extension MainViewController: UICollectionViewDataSource {

    // 섹션 개수 변환
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return MovieSection.allCases.count  // 열거형의 정의된 모든 케이스의 개수를 섹션 개수로 사용
    }

    // 각 섹션의 아이템 개수 반환
    func collectionView(
        _ collectionView: UICollectionView, numberOfItemsInSection section: Int
    ) -> Int {
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

    // 각 아이템의 셀 생성
    func collectionView(
        _ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
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
            cell.configure(
                with: APIManager.shared.getImageURL(for: movie.posterPath))
            return cell

        case .upcoming:  // 나머지 영화: 장르 포함
            let cell =
                collectionView.dequeueReusableCell(
                    withReuseIdentifier: SmallImageCell.identifier,
                    for: indexPath) as! SmallImageCell
            let movieDetail = details[indexPath.item]
            let genreNames = movieDetail.genres.map { $0.name }.joined(
                separator: ", ")  // 장르 이름 합치기
            cell.configure(
                with: APIManager.shared.getImageURL(
                    for: movieDetail.posterPath ?? ""),
                title: movieDetail.title, genre: genreNames)
            return cell

        case .nowPlaying:
            let cell =
                collectionView.dequeueReusableCell(
                    withReuseIdentifier: SmallImageCell.identifier,
                    for: indexPath) as! SmallImageCell
            let movieDetail = details[indexPath.item]
            let genreNames = movieDetail.genres.map { $0.name }.joined(
                separator: ", ")  // 장르 이름 합치기
            cell.configure(
                with: APIManager.shared.getImageURL(
                    for: movieDetail.posterPath ?? ""),
                title: movieDetail.title, genre: genreNames)
            return cell

        case .topRated:
            let cell =
                collectionView.dequeueReusableCell(
                    withReuseIdentifier: SmallImageCell.identifier,
                    for: indexPath) as! SmallImageCell
            let movieDetail = details[indexPath.item]
            let genreNames = movieDetail.genres.map { $0.name }.joined(
                separator: ", ")  // 장르 이름 합치기
            cell.configure(
                with: APIManager.shared.getImageURL(
                    for: movieDetail.posterPath ?? ""),
                title: movieDetail.title, genre: genreNames)
            return cell
        }
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
}
