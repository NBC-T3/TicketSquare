import UIKit
import SnapKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 탭 바 스타일 설정
        tabBar.tintColor = .white  // 선택된 아이템의 색을 회색으로 설정
        tabBar.unselectedItemTintColor = .gray  // 선택되지 않은 아이템의 색을 회색으로 설정
        tabBar.backgroundColor = .black // 탭 바의 배경색을 검은색으로 설정
        tabBar.isTranslucent = false  // 탭 바의 투명도 비활성화
        
        // 탭 추가
        let homeVC = createNavController(vc: HomeViewController(), title: "Home", imageName: "house.fill")
        let searchVC = createNavController(vc: SearchViewController(), title: "Search", imageName: "magnifyingglass")
        let accountVC = createNavController(vc: AccountViewController(), title: "Account", imageName: "person.fill")
        
        viewControllers = [homeVC, searchVC, accountVC]
        
        // 탭 바와 탭 바 아이템의 간격을 조정 (예: 탭 바 위쪽에 여백 추가)
        addTopPaddingToTabBar()
    }
    
    // 탭 바 상단에 여백을 추가하는 메서드
    private func addTopPaddingToTabBar() {
        // 탭 바의 높이를 늘려서 상단 여백을 추가
        var tabFrame = tabBar.frame
        tabFrame.origin.y += 10  // 상단 여백 10pt 추가
        tabBar.frame = tabFrame
    }

    private func createNavController(vc: UIViewController, title: String, imageName: String) -> UINavigationController {
        let navController = UINavigationController(rootViewController: vc)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = UIImage(systemName: imageName)
        return navController
    }
}

class HomeViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    
    private func setupUI() {
        let label = UILabel()
        label.text = "Home Screen"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .black
        view.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

class SearchViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    
    private func setupUI() {
        let label = UILabel()
        label.text = "Search Screen"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .black
        view.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

class AccountViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
    }
    
    private func setupUI() {
        let label = UILabel()
        label.text = "Account Screen"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .black
        view.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
