//
//  MyPageViewController.swift
//  TicketSquare
//
//  Created by t2023-m0072 on 12/18/24.
//

import UIKit
import SnapKit


class MyPageViewController: UIViewController {
    
    private var userInfo: UserInfo?
    
    private var tickets: [Ticket] = []
    
    private let ticketTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColorStyle.bg
        return tableView
    }()
    
    private let profileImage: UIImageView = {
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(systemName: "person.circle")
        imageView.layer.cornerRadius = 75
        
        
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
    
    private let phoneNumberLabel: UILabel = {
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
    
    private static func attributeLabel(_ attribute: String) -> UILabel {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: 13)
        label.textAlignment = .left
        label.textColor = .lightGray
        label.numberOfLines = 1
        label.text = attribute
        
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
        configureProfile()

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
            profileImage,
            stackView,
            ticketTableView
        ].forEach { view.addSubview($0) }
        
        [   Self.attributeLabel("이름"),
            nameLabel,
            Self.attributeLabel("생년월일"),
            birthDateLabel,
            Self.attributeLabel("전화번호"),
            phoneNumberLabel
        ].forEach { stackView.addArrangedSubview($0) }
        
        profileImage.snp.makeConstraints {
            $0.leading.top.equalTo(view.safeAreaLayoutGuide).inset(40)
            $0.width.equalTo(120)
            $0.height.equalTo(stackView)
        }
        
        stackView.snp.makeConstraints {
            $0.leading.equalTo(profileImage.snp.trailing).offset(60)
            $0.trailing.top.equalTo(view.safeAreaLayoutGuide).inset(30)
            $0.height.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.25)
        }
        
        ticketTableView.snp.makeConstraints {
            $0.height.equalTo(view.safeAreaLayoutGuide).multipliedBy(0.6)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        [
            nameLabel,
            birthDateLabel,
            phoneNumberLabel
        ].forEach {
            $0.snp.makeConstraints {
                $0.height.equalTo(30)
            }
        }
        
    }
    
    private func configureProfile() {
        guard let userInfo = UserInfo.readDefault() else { return }
        self.userInfo = userInfo
        
        nameLabel.text = userInfo.name
        birthDateLabel.text = userInfo.birth
        phoneNumberLabel.text = userInfo.phoneNumber
        
        if let data = userInfo.profileImage,
           let image = UIImage(data: data) {
            profileImage.image = image
        }
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
        180
    }
    
}



