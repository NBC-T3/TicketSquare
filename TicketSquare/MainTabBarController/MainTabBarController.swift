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
        
        // 탭 추가 ( ViewController 들 연결 )
        let homeVC = createNavController(vc: MainViewController(), title: "Home", imageName: "house.fill")
        let searchVC = createNavController(vc: SearchViewController(), title: "Search", imageName: "magnifyingglass")
        let accountVC = createNavController(vc: MyPageViewController(), title: "Account", imageName: "person.fill")
        
        viewControllers = [homeVC, searchVC, accountVC]
        
    }
    
    private func createNavController(vc: UIViewController, title: String, imageName: String) -> UINavigationController {
        let navController = UINavigationController(rootViewController: vc)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = UIImage(systemName: imageName,
                                                 withConfiguration: UIImage.SymbolConfiguration(font: .systemFont(ofSize: 20)))?.withBaselineOffset(fromBottom: UIFont.systemFontSize)
        return navController
    }
    
    // 탭 전환 시 애니메이션 제거
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let index = tabBar.items?.firstIndex(of: item),
              let viewControllers = viewControllers else { return }

        UIView.performWithoutAnimation {
            selectedViewController = viewControllers[index]
        }
    }
}

