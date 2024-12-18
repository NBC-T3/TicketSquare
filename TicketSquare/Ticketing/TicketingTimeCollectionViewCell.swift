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
    
    // 시간 데이터
    private var time: Ticket.TicketcingTime?
    
    // 시간 라벨
    private let timeLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 20)
        label.backgroundColor = .clear
        label.textAlignment = .center
        label.textColor = .white
        
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
        backgroundColor = .black
        setData(nil)
        timeLabel.textColor = .white
        timeLabel.font = .systemFont(ofSize: 20)
        layer.borderColor = UIColor.white.cgColor
    }
    
    // UI 설정
    private func configureUI() {
        addSubview(timeLabel)
        
        timeLabel.snp.makeConstraints {
            $0.center.size.equalToSuperview()
        }
        
        backgroundColor = .black
        clipsToBounds = true
        layer.cornerRadius = 10
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 1
        
    }
    
    // 데이터 설정
    func setData(_ time: Ticket.TicketcingTime?) {
        self.time = time
        let str = time?.cellForm()
        self.timeLabel.text = str ?? "--:--"
    }
    
    // 셀 선택 시
    func didSelected() -> Ticket.TicketcingTime? {
        backgroundColor = .white
        timeLabel.textColor = .black
        timeLabel.font = .systemFont(ofSize: 20, weight: .bold)

        return self.time
    }
    
    // 셀 선택 해제 시
    func didDeselected() {
        backgroundColor = .black
        timeLabel.textColor = .white
        timeLabel.font = .systemFont(ofSize: 20)
    }
}
