//
//  SearchTableViewCell.swift
//  TicketSquare
//
//  Created by 안준경 on 12/16/24.
//

import UIKit

class SearchTableViewCell: UITableViewCell {

    let label: UILabel = {
        var label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.textColor = .white
        label.backgroundColor = UIColorStyle.bg
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
    }
    
    private func setupCell() {
        addSubview(label)
                
        label.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.leading.equalTo(safeAreaLayoutGuide)
            $0.trailing.equalTo(safeAreaLayoutGuide)
            $0.width.equalTo(340)
            $0.height.equalTo(80)
        }
    }
    
    public func configureCell(_ data: String) {
        label.text = data
    }
    
}

