//
//  PreviewProvider.swift
//  TicketSquare
//
//  Created by t2023-m0072 on 12/15/24.
//
import UIKit
import SwiftUI

// 미리보기
// 캔버스에서 프리뷰 고정핀을 설정하면 다른 파일에서도 미리보기 가능
struct PreView: PreviewProvider {
    
    static var previews: some View {
        // 사용할 ViewController 로 수정 후 사용
        MainViewController().toPreview()
    }
    
}

#if DEBUG
extension UIViewController {
    private struct Preview: UIViewControllerRepresentable {
            let viewController: UIViewController

            func makeUIViewController(context: Context) -> UIViewController {
                return viewController
            }

            func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
            }
        }

        func toPreview() -> some View {
            Preview(viewController: self)
        }
}
#endif
