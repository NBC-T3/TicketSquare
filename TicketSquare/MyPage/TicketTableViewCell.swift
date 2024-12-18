//
//  TicketTableViewCell.swift
//  TicketSquare
//
//  Created by t2023-m0072 on 12/18/24.
//

import UIKit
import SnapKit

class TicketTableViewCell: UITableViewCell {
    
    static let id = "TicketTableViewCell"
    
    private var ticket: Ticket?
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .clear
        imageView.image = UIImage(systemName: "square.and.arrow.up.circle.fill")
        
        return imageView
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 15
        
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        
        label.text = "Title"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.backgroundColor = .clear
        label.textColor = .white
        
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        
        label.text = "0000-00-00 00:00"
        label.font = .systemFont(ofSize: 17)
        label.backgroundColor = .clear
        label.textColor = .white
        label.textAlignment = .right


        return label
    }()
    
    private let peopleCountLabel: UILabel = {
        let label = UILabel()
        
        label.text = "어른 3명, 청소년 2명"
        label.font = .systemFont(ofSize: 17)
        label.backgroundColor = .clear
        label.textColor = .white
        label.textAlignment = .right
        
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        backgroundColor = .white.withAlphaComponent(0.07)
        layer.borderColor = UIColor.white.withAlphaComponent(0.03).cgColor
        layer.borderWidth = 2
        
        [
            posterImageView,
            stackView
        ].forEach { addSubview($0) }
        
        [
            titleLabel,
            timeLabel,
            peopleCountLabel
        ].forEach { stackView.addArrangedSubview($0) }
        

        posterImageView.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview()
            $0.width.equalTo(90)
        }
        
        stackView.snp.makeConstraints {
            $0.top.bottom.trailing.equalToSuperview().inset(10)
            $0.leading.equalTo(posterImageView.snp.trailing).offset(30)
        }
    }
    
    func configure(_ ticket: Ticket) {
        self.ticket = ticket
    }
}
