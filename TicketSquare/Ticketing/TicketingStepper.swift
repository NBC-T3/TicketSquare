//
//  TicketingStepper.swift
//  TicketSquare
//
//  Created by t2023-m0072 on 12/16/24.
//

import UIKit
import SnapKit

class TicketingStepper: UIView {
    
    private(set) var value: Int = 0
    
    var onIncreaseButton: (() -> Void)?
    
    var onDecreaseButton: (() -> Void)?
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Title"
        label.textColor = .white
        label.font = .systemFont(ofSize: 23, weight: .bold)
        label.textAlignment = .left
        
        
        return label
    }()
    
    // 
    private let stepperlStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.backgroundColor = .lightGray

        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        
        stackView.clipsToBounds = true
        stackView.layer.cornerRadius = 8
        stackView.layer.borderWidth = 1
        stackView.layer.borderColor = UIColor.white.cgColor
        
        return stackView
    }()
    
    // 감소 버튼
    private lazy var decreaseButton = {
        let button = stepperButton(.decrease)
        
        button.addTarget(self,
                         action: #selector(decreaseButtonTapped),
                         for: .touchUpInside)
        return button
    }()
    
    // 증가 버튼
    private lazy var increaseButton = {
        let button = stepperButton(.increase)
        
        button.addTarget(self,
                         action: #selector(increaseButtonTapped),
                         for: .touchUpInside)
        
        return button
    }()
    
    // 값 라벨
    private var valueLabel: UILabel = {
        let label = UILabel()
        
        label.text = "0"
        
        label.font = .systemFont(ofSize: 20)
        label.textAlignment = .center
        label.backgroundColor = .black
        label.textColor = .white
        
        label.layer.cornerRadius = 2
        label.clipsToBounds = true
        
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.white.cgColor
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 전체 UI 설정
    private func configureUI() {
        
        backgroundColor = .clear
        
        [
            titleLabel,
            stepperlStackView
        ].forEach { addSubview($0) }
        
        [
            decreaseButton,
            valueLabel,
            increaseButton
        ].forEach { stepperlStackView.addArrangedSubview($0) }
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
        }
        
        stepperlStackView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(10)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(130)
            $0.height.equalTo(40)
        }
        
        [
            decreaseButton,
            increaseButton
        ].forEach {
            $0.snp.makeConstraints {
                $0.top.bottom.equalToSuperview()
            }
        }
        
        valueLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(3)
        }
        
    }

    /// (외부 설정 메서드) 타이틀 설정
    func setTitle(_ title: String) {
        self.titleLabel.text = title
    }
    
    /// (외부 설정 메서드) 배경 색상 설정
    func setColor(_ color: UIColor) {
        self.stepperlStackView.backgroundColor = color
    }
    
}

// MARK: - 버튼 설정

extension TicketingStepper {
    
    // 스텝퍼 버튼 기본 설정
    private func stepperButton(_ type: StepperButtonType) -> UIButton {
        let button = UIButton()
        button.setImage(type.image, for: .normal)

        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .white
        button.backgroundColor = .clear
        button.clipsToBounds = true
        
        return button
    }
    
    // 감소 버튼 액션
    @objc
    private func decreaseButtonTapped() {
        guard value > 0 else { return }
        value -= 1
        
        DispatchQueue.main.async {
            self.updateValueLabel()
        }
        
        onDecreaseButton?()
    }
    
    // 증가 버튼 액션
    @objc
    private func increaseButtonTapped() {
        guard value <= 99 else { return }
        value += 1
        
        DispatchQueue.main.async {
            self.updateValueLabel()
        }
        
        onIncreaseButton?()
    }
    
    // 값 라벨 업데이트
    private func updateValueLabel() {
        valueLabel.text = "\(value)"
    }
}

extension TicketingStepper {
    
    enum StepperButtonType {
        case increase
        case decrease
        
        var image: UIImage? {
            switch self {
            case .increase:
                return UIImage(systemName: "plus")
                
            case .decrease:
                return UIImage(systemName: "minus")
            }
        }
    }
}
