# 🎬 TicketSquare (티켓스퀘어)

영화 예매 서비스 iOS 애플리케이션입니다. TMDB API를 활용하여 영화 정보를 제공하고, 예매 기능을 구현했습니다.

## 🙆‍♂️ 팀원

|[이재영](https://github.com/0-jerry) (팀장)|[강민성](https://github.com/kangminseoung)|[안준경](https://github.com/AhnJunGyung)|[이재건](https://github.com/Quaker-Lee)|[황석범](https://github.com/HwangSeokBeom)|
|:---:|:---:|:---:|:---:|:---:|
|예매 페이지<br/>마이 페이지|메인 페이지|검색 페이지|로그인 페이지<br/>회원가입|API 매니저<br/>탭 바, 세부 페이지|

<br/>
<br/>

## 🎥 시연 영상
|<img src="https://github.com/user-attachments/assets/ba66960e-588b-4a16-9081-778a7a3833c3" width="66%">|<img src="https://github.com/user-attachments/assets/c88ca288-76fb-42e5-8203-1ddcb81994fd" width="66%">|<img src="https://github.com/user-attachments/assets/b6e38e12-2eb9-4ed4-afda-ccaa1f726b73" width="66%">|
|:---:|:---:|:---:|
|로그인 & 마이페이지|메인 & 예매|검색|


## 📱 주요 기능

### 1. 메인 화면
- 인기 영화 자동 슬라이드 배너
- 최신 영화, 현재 상영작, 최고 평점 영화 목록 제공
- 가로 스크롤 방식의 영화 목록 탐색

### 2. 영화 검색
- 키워드 기반 영화 검색
- 검색 결과 그리드 뷰 표시
- 현재 상영작 목록 제공

### 3. 영화 상세 정보
- 영화 포스터, 제목, 개봉일, 상영 시간
- 장르 정보
- 줄거리 (접기/펼치기 기능)

### 4. 예매 시스템
- 날짜 선택
- 시간대 선택
- 인원 선택 (일반/청소년)
- 결제 금액 계산

### 5. 마이페이지
- 사용자 프로필 관리
- 예매 내역 확인
- 프로필 이미지 설정


## 📋 구현 내용

### UI 구현
- `UICollectionView`를 활용한 그리드/리스트 레이아웃
- `UITableView`를 통한 예매 내역 표시
- `CompositionalLayout`을 활용한 동적 레이아웃
- 커스텀 셀 디자인
- `SnapKit`을 활용한 프로그래매틱 UI

### 데이터 처리
- `TMDB API` 연동
- `Alamofire`를 활용한 네트워크 통신
- 비동기 이미지 로딩
- `JSON` 데이터 파싱
- `UserDefaults`를 활용한 로컬 데이터 저장

### 사용자 경험
- 자동 슬라이드 배너
- 스크롤 애니메이션
- 실시간 가격 계산
- 직관적인 예매 프로세스

## 🔑 주요 클래스 설명

### APIManager
- `TMDB API` 통신 담당
- 영화 정보 `fetch`
- 이미지 다운로드 관리
- `Alamofire`를 활용한 네트워크 요청 처리

### MainViewController
- 메인 화면 UI 관리
- `CompositionalLayout`을 활용한 섹션 구성
- 영화 목록 표시
- 자동 슬라이드 기능 구현

### TicketingViewController
- 예매 프로세스 관리
- `UIDatePicker`를 활용한 날짜 선택
- `CollectionView`를 활용한 시간 선택
- 커스텀 스테퍼를 통한 인원 선택
- 실시간 가격 계산 및 표시

### SearchViewController
- 영화 검색 기능
- `UISearchBar`를 통한 검색 인터페이스
- 검색 결과의 실시간 업데이트
- 그리드/리스트 뷰 전환

## 🎨 디자인 패턴

- **Singleton Pattern**: `APIManager`, `TicketManager`에서 사용
- **Delegate Pattern**: 테이블뷰, 컬렉션뷰, 검색바 구현에 활용
- **Observer Pattern**: 데이터 바인딩에 활용
- **MVC Pattern**: 뷰와 비즈니스 로직의 분리

## 🛠 기술 스택

- **언어**: `Swift`
- **구조**: `UIKit`, `MVC`
- **네트워킹**: `Alamofire (5.10.2)`
- **레이아웃**: `SnapKit (5.7.1)`
- **유틸리티**: `Then (3.0.0)`
- **API**: `TMDB API`
- **데이터 저장**: `UserDefaults`

## 📁 프로젝트 구조

```
TicketSquare/
├── 📱 APIManager/
│   ├── APIManager.swift          # TMDB API 통신 관리
│   └── Movie.swift              # 영화 데이터 모델
│
├── 🔐 Login/
│   ├── Join.swift               # 회원가입 화면
│   └── Login.swift              # 로그인 화면
│
├── 📋 MainTabBarController/
│   └── MainTabBarController.swift    # 탭바 컨트롤러
│
├── 🏠 MainView/
│   ├── HeaderView.swift              # 헤더 뷰 컴포넌트
│   ├── MainViewController.swift      # 메인 화면 컨트롤러
│   ├── PagingImageCell.swift         # 페이징 이미지 셀
│   └── SmallImageCell.swift          # 작은 이미지 셀
│
├── 🎬 MovieDetail/
│   └── MovieDetailViewController.swift    # 영화 상세 화면
│
├── 👤 MyPage/
│   ├── MyPageViewController.swift         # 마이페이지 화면
│   └── TicketTableViewCell.swift          # 예매 내역 셀
│
├── 🔍 Search/
│   ├── SearchCollectionViewCell.swift     # 검색 결과 그리드 셀
│   ├── SearchTableViewCell.swift          # 검색 결과 리스트 셀
│   ├── SearchView.swift                   # 검색 화면 뷰
│   └── SearchViewController.swift         # 검색 화면 컨트롤러
│
├── 🎫 Ticketing/
│   ├── Ticket.swift                       # 티켓 모델
│   ├── TicketingStepper.swift             # 인원 선택 스테퍼
│   ├── TicketingTimeCollectionViewCell.swift    # 시간 선택 셀
│   ├── TicketingViewController.swift      # 예매 화면 컨트롤러
│   └── TicketManager.swift                # 티켓 데이터 관리
│
└── 🛠 Utility/
    ├── AppDelegate.swift                  # 앱 델리게이트
    ├── Assets.xcassets                    # 에셋 파일
    ├── Info.plist                         # 프로젝트 설정 파일
    ├── LaunchScreen                       # 시작 화면
    ├── MockData                           # 테스트용 더미 데이터
    ├── PreviewProvider                    # SwiftUI 프리뷰 설정
    ├── PriceFormatter                     # 가격 포맷 유틸리티
    ├── SceneDelegate                      # 씬 델리게이트
    ├── UIColorStyle                       # 커스텀 색상 스타일
    ├── UserInfo                           # 사용자 정보 관리
    └── ViewController                     # 기본 뷰 컨트롤러
```


## 🔧 설치 및 실행 방법

1. 프로젝트 클론
```bash
git clone https://github.com/your-username/TicketSquare.git
```

2. Pod 설치
```bash
pod install
```
