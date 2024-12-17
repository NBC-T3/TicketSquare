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
    
    private var time: Ticket.TicketcingTime?
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 20)
        label.backgroundColor = .clear
        label.textAlignment = .center
        
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
        self.isSelected = false
    }
    
    private func configureUI() {
        addSubview(timeLabel)
        
        timeLabel.snp.makeConstraints {
            $0.center.size.equalToSuperview()
        }
        
        backgroundColor = .white
        clipsToBounds = true
        layer.cornerRadius = 10
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1
        
    }
    
    func setData(_ time: Ticket.TicketcingTime) {
        self.time = time
        let str = time.cellForm()
        self.timeLabel.text = str
    }
    
    func didSelected() -> Ticket.TicketcingTime? {
        backgroundColor = .systemBlue
        timeLabel.textColor = .white
        return self.time
    }
    
    func didDeselected() {
        backgroundColor = .white
        timeLabel.textColor = .black

    }
}
