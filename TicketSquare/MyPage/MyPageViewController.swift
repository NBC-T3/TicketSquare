//
//  MyPageViewController.swift
//  TicketSquare
//
//  Created by t2023-m0072 on 12/18/24.
//

import UIKit
import SnapKit

class MyPageViewController: UIViewController {
    
    private var tickets: [Ticket] = MockData.tickets
    
    private let editButton: UIButton = {
        let button = makeButton("개인정보 변경")
        
        return button
    }()
    
    private let ticketTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .black
        return tableView
    }()
    
    private let logOutButton: UIButton = {
        let button = makeButton("로그아웃")
        
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .black
        configureUI()
        configureTableView()
    }
    
    private func configureData() {
        let tickets = TicketManager().read()
        self.tickets = tickets
    }
    
    private func configureUI() {
        
        [
            editButton,
            ticketTableView,
            logOutButton
        ].forEach { view.addSubview($0) }
        
        editButton.snp.makeConstraints {
            $0.top.trailing.equalTo(view.safeAreaLayoutGuide).inset(30)
        }
        
        logOutButton.snp.makeConstraints {
            $0.bottom.trailing.equalTo(view.safeAreaLayoutGuide).inset(30)
        }
        
        ticketTableView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.top.equalTo(editButton.snp.bottom).offset(20)
            $0.bottom.equalTo(logOutButton.snp.top).offset(-20)
        }
        
    }
    
    private static func makeButton(_ title: String) -> UIButton {
        let button = UIButton()
        
        button.setTitle(title, for: .normal)
        button.backgroundColor = .white.withAlphaComponent(0.1)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18)
        
        button.snp.makeConstraints {
            $0.width.equalTo(120)
            $0.height.equalTo(35)
        }
        
        button.layer.cornerRadius = 5
        button.layer.borderColor = UIColor.white.withAlphaComponent(0.3).cgColor
        button.layer.borderWidth = 1
        
        return button
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
        120
    }
    
}



