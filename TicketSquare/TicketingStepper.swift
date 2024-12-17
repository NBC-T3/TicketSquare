//
//  TicketingStepper.swift
//  TicketSquare
//
//  Created by t2023-m0072 on 12/16/24.
//

import UIKit
import SnapKit

class TestViewController: UIViewController {
    override func loadView() {
        super.loadView()
        view = TicketingStepper()
        view.backgroundColor = .gray
    }
}

class TicketingStepper: UIView {
    
    private var title: String?
    
    private(set) var value: Int = 0
    

    
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
    
    
    private let horizentalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
//        UITabbarC
        return stackView
    }()
    
    private lazy var decreaseButton = {
        let button = stepperButton(.decrease)
        
        return button
    }()
    
    private lazy var increaseButton = {
        let button = stepperButton(.increase)
        
        return button
    }()
    
    private var valueLabel: UILabel = {
        let label = UILabel()
        
        return label
    }()
        
    
    private func stepperButton(_ type: StepperButtonType) -> UIButton {
        let button = UIButton()
        
        button.setTitle(type.title, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 15)
        
        return button
    }
//    
//    func setTitleFont(_ size: Int) {
//        
//        guard let decreaseButtonLabel = decreaseButton.titleLabel?,
//              let increaseButton
//        
//        [
//            decreaseButton.titleLabel?,
//            increaseButton.titleLabel?,
//            valueLabel,
//        
//    }
    
    enum StepperButtonType {
        case increase
        case decrease
        
        var title: String {
            switch self {
            case .increase: return "-"
            case .decrease: return "+"
            }
        }
    }
}
