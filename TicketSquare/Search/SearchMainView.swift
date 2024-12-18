//
//  SearchMainView.swift
//  TicketSquare
//
//  Created by 안준경 on 12/17/24.
//

import UIKit
import SnapKit

class SearchMainView: UIView {
    
    private let searchBar: UISearchBar = {
        var searchBar = UISearchBar()
        searchBar.tintColor = .red
        searchBar.placeholder = "영화를 검색해보세요."
        searchBar.searchTextField.font = .systemFont(ofSize: 18)
        searchBar.setImage(UIImage(), for: UISearchBar.Icon.search, state: .normal)
        return searchBar
    }()
    
    private let searchButton: UIButton = {
        var button = UIButton()
        button.setTitle("검색", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 15
        return button
    }()
    
    private let label: UILabel = {
        var label = UILabel()
        label.text = "현재 상영중"
        label.textColor = .white
        label.font = .systemFont(ofSize: 22)
        return label
    }()
    
    let tableView: UITableView = {
        var tableView = UITableView()
        tableView.backgroundColor = .black
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
//        tableView.reloadData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpView() {
        let safeArea = safeAreaLayoutGuide
        
        backgroundColor = .black
        
        addSubview(searchBar)
        addSubview(searchButton)
        addSubview(label)
        addSubview(tableView)
        
        searchBar.snp.makeConstraints {
            $0.top.equalTo(safeArea.snp.top)
            $0.leading.equalToSuperview()
            $0.trailing.equalTo(searchButton.snp.leading).inset(-10)
            $0.height.equalTo(50)
        }
        
        searchButton.snp.makeConstraints {
            $0.centerY.equalTo(searchBar)
            $0.trailing.equalToSuperview()
            $0.width.equalTo(80)
            $0.height.equalTo(45)
        }
        
        label.snp.makeConstraints {
            $0.top.equalTo(safeArea).offset(30)
            $0.leading.equalTo(safeArea).offset(20)
            $0.bottom.equalTo(tableView.snp.top).inset(50)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(safeArea).offset(140)
            $0.leading.equalTo(safeArea).inset(20)
            $0.trailing.equalToSuperview().inset(20)
            $0.bottom.equalTo(safeArea).offset(-40)
        }
    }
    
    
}

#Preview{
    SearchMainView()
}
