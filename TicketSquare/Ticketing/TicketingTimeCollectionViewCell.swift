//
//  TicketingTimeCollectionViewCell.swift
//  TicketSquare
//
//  Created by t2023-m0072 on 12/16/24.
//

import UIKit
import SnapKit

final class TicketingTimeCollectionViewCell: UICollectionViewCell {
    
    static let id: String = "TicketingTimeCollectionViewCell"
    
    private var ticket: Ticket?
    
    // 시작 시간 라벨
    private let startTimeLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 20)
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.textColor = .white
        
        return label
    }()
    // 종료 시간 라벨
    private let endTimeLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 18, weight: .light)
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.textColor = .white
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        reset()
    }
    
    // 셀 초기화
    private func reset() {
        isSelected = false
        
        backgroundColor = .white.withAlphaComponent(0.2)
        layer.borderColor = UIColor.white.cgColor

        startTimeLabel.text = "--:--"
        startTimeLabel.textColor = .white
        startTimeLabel.font = .systemFont(ofSize: 20)
        
        endTimeLabel.text = "--:--"
        endTimeLabel.textColor = .white
        endTimeLabel.font = .systemFont(ofSize: 18, weight: .light)
        didDeselected()
    }
    
    // UI 설정
    private func configureUI() {
        [
            startTimeLabel,
            endTimeLabel
        ].forEach { addSubview($0) }
        
        startTimeLabel.snp.makeConstraints {
            $0.height.equalToSuperview().multipliedBy(0.5)
            $0.top.trailing.leading.equalToSuperview()
        }
        
        endTimeLabel.snp.makeConstraints {
            $0.height.equalToSuperview().multipliedBy(0.5)
            $0.bottom.trailing.leading.equalToSuperview()
        }
        
        backgroundColor = .white.withAlphaComponent(0.15)
        clipsToBounds = true
        layer.cornerRadius = 10
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 1
        
    }
    
    // 데이터 설정
    func setTime(startTime: String, endTime: String) {
        self.startTimeLabel.text = startTime
        self.endTimeLabel.text = endTime
    }
    
    // 셀 선택 시
    func didSelected() {
        backgroundColor = .white
        startTimeLabel.textColor = .black
        startTimeLabel.font = .systemFont(ofSize: 20, weight: .bold)
        
        endTimeLabel.layer.borderColor = UIColor.black.withAlphaComponent(0.3).cgColor
        endTimeLabel.textColor = .black
        endTimeLabel.font = .systemFont(ofSize: 18, weight: .regular)
    }
    
    // 셀 선택 해제 시
    func didDeselected() {
        
        backgroundColor = .white.withAlphaComponent(0.15)
        startTimeLabel.textColor = .white
        startTimeLabel.font = .systemFont(ofSize: 20)
        
        endTimeLabel.textColor = .white
        endTimeLabel.font = .systemFont(ofSize: 18, weight: .light)
        endTimeLabel.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
    }
}
