import UIKit
import SnapKit

class MainTabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 탭 바 스타일 설정
        tabBar.tintColor = .systemBlue
        tabBar.unselectedItemTintColor = .gray
        tabBar.barTintColor = .white
        tabBar.isTranslucent = false
        
        // 탭 추가
        let homeVC = createNavController(vc: HomeViewController(), title: "Home", imageName: "house.fill")
        let searchVC = createNavController(vc: SearchViewController(), title: "Search", imageName: "magnifyingglass")
        let accountVC = createNavController(vc: AccountViewController(), title: "Account", imageName: "person.fill")
        
        viewControllers = [homeVC, searchVC, accountVC]
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
