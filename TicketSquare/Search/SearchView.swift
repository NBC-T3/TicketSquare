//
//  SearchView.swift
//  TicketSquare
//
//  Created by 안준경 on 12/18/24.
//

import UIKit
import SnapKit

class SearchView: UIView {
    
    //MARK: 검색바
    private let searchBar: UISearchBar = {
        var searchBar = UISearchBar()
        searchBar.tintColor = .red
        searchBar.placeholder = "영화를 검색해보세요."
        searchBar.searchTextField.font = .systemFont(ofSize: 18)
        searchBar.setImage(UIImage(), for: UISearchBar.Icon.search, state: .normal)
        return searchBar
    }()
    
    let searchButton: UIButton = {
        var button = UIButton()
        button.setTitle("검색", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 15
        return button
    }()
    
    //MARK: 메인화면
    let titleLabel: UILabel = {
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
    
    //MARK: 검색결과화면
    let headerLabel: UILabel = {
        var label = UILabel()
        label.backgroundColor = .red
        label.text = "Header"
        label.font = .systemFont(ofSize: 40)
        return label
    }()
    
    let collectionView: UICollectionView = {
        //레이아웃 설정
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 120, height: 180) //셀 크기
        flowLayout.minimumLineSpacing = 50 //셀 세로 간격
        flowLayout.minimumInteritemSpacing = 2 //셀 가로 간격
        flowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 10, right: 0) //셀 여백
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .black
        
        return collectionView
    }()
    

    
    //MARK: 초기화
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: 제약조건
    func setUpView() {
        let safeArea = safeAreaLayoutGuide
        
        backgroundColor = .black
        
        addSubview(searchBar)
        addSubview(searchButton)
        addSubview(titleLabel)
        addSubview(tableView)
        addSubview(collectionView)
        
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
        
        titleLabel.snp.makeConstraints {
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
        
        collectionView.snp.makeConstraints{
            $0.top.equalTo(safeArea).offset(140)
            $0.leading.equalTo(safeArea)
            $0.trailing.equalToSuperview()
            $0.bottom.equalTo(safeArea).offset(-40)
        }
    }
    
}