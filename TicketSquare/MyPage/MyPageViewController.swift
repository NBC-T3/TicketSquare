//
//  MyPageViewController.swift
//  TicketSquare
//
//  Created by t2023-m0072 on 12/18/24.
//

import UIKit
import SnapKit

class MyPageViewController: UIViewController {
    
    private var tickets: [Ticket] = []
    
    private let ticketTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColorStyle.bg
        return tableView
    }()
    
    private let profileImage: UIImageView = {
        let imageView = UIImageView()
        
        return imageView
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        
        return stackView
    }()
    
    private let nameLabel: UILabel = {
        let label = profileLabel()
        
        return label
    }()
    
    private let birthDateLabel: UILabel = {
        let label = profileLabel()
        
        return label
    }()
    
    private static func profileLabel() -> UILabel {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .white
        label.textAlignment = .left
        label.numberOfLines = 1
        label.backgroundColor = .clear
        
        return label
    }

    
    /*
     이름
     생년월일
     전화번호
     아이디
     비밀번호
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColorStyle.bg
        configureUI()
        configureTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureData()
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    private func configureData() {
        let tickets = TicketManager().read()
        self.tickets = tickets
        ticketTableView.reloadData()
    }
    
    private func configureUI() {
        [
            ticketTableView
        ].forEach { view.addSubview($0) }
        
        [
            nameLabel
        ].forEach { view.addSubview($0) }
        
        ticketTableView.snp.makeConstraints {
            $0.height.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.6)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
    }
    
    private func configureProfile() {
        
    }
    
}


extension MyPageViewController: UITableViewDataSource, UITableViewDelegate {
    
    private func configureTableView() {
        ticketTableView.dataSource = self
        ticketTableView.delegate = self
        ticketTableView.register(TicketTableViewCell.self,
                                 forCellReuseIdentifier: TicketTableViewCell.id)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.tickets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TicketTableViewCell.id, for: indexPath) as? TicketTableViewCell else {
            print("실패")
            return TicketTableViewCell() }
        
        let ticket = tickets[indexPath.row]
        cell.configure(ticket)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        220
    }
    
}



