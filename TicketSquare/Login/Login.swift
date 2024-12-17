//
//  LoginPage.swift
//  TicketSquare
//
//  Created by 이재건 on 12/16/24.
//

import UIKit
import SnapKit
import Then

class Login: UIViewController {
    
    //MARK: 각 요소들의 속성 부분
    private let loginLabel: UILabel = UILabel().then {
        $0.text = "티켓스퀘어 ID 로그인"
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: 30)
        $0.textColor = .white
    }
    private let id: UITextField = UITextField().then {
        $0.text = " 아이디"
        $0.font = UIFont.systemFont(ofSize: 25)
        $0.backgroundColor = .gray
        $0.textColor = .darkGray
        $0.layer.cornerRadius = 3
    }
    private let password: UITextField = UITextField().then {
        $0.text = " 비밀번호"
        $0.font = UIFont.systemFont(ofSize: 25)
        $0.backgroundColor = .gray
        $0.textColor = .darkGray
        $0.layer.cornerRadius = 3
    }
    private let loginBtn: UIButton = UIButton().then {
        $0.setTitle("로그인하기", for: .normal)
        $0.backgroundColor = .darkGray
        $0.setTitleColor(.gray, for: .normal)
        $0.layer.cornerRadius = 3
    }
    private let joinBtn: UIButton = UIButton().then {
        $0.backgroundColor = .clear
        $0.setTitle("회원가입", for: .normal)
        $0.setTitleColor(.gray, for: .normal)
        $0.addTarget(self, action: #selector(joinBtnTapped), for: .touchDown)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        configureUI()
    }
    
    
    //MARK: 각 요소들의 UI 구현 부분
    private func configureUI() {
        view.backgroundColor = .black
        
        view.addSubview(loginLabel)
        loginLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(15)
            $0.height.equalTo(200)
        }
        view.addSubview(id)
        id.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.top.equalTo(loginLabel.snp.bottom)
            $0.height.equalTo(50)
        }
        view.addSubview(password)
        password.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.top.equalTo(id.snp.bottom).offset(10)
            $0.height.equalTo(50)
        }
        view.addSubview(loginBtn)
        loginBtn.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.top.equalTo(password.snp.bottom).offset(20)
            $0.height.equalTo(50)
        }
        view.addSubview(joinBtn)
        joinBtn.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.top.equalTo(loginBtn.snp.bottom).offset(20)
        }
    }
    
    //회원가입 버튼이 눌렸을 때
    @objc
    private func joinBtnTapped() {
        self.navigationController?.pushViewController(Join(), animated: true)
    }
}
