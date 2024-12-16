//
//  JoinPage.swift
//  TicketSquare
//
//  Created by 이재건 on 12/16/24.
//

import UIKit
import SnapKit
import Then

class Join: UIViewController {
    
    private let joinLabel: UILabel = UILabel().then {
        $0.text = "티켓스퀘어 회원가입"
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 30)
        $0.textColor = .white
    }
    private let name: UITextField = UITextField().then {
        $0.text = " 이름을 입력해주세요."
        $0.font = UIFont.systemFont(ofSize: 15)
        $0.backgroundColor = .gray
        $0.textColor = .darkGray
        $0.layer.cornerRadius = 3
    }
    private let birth: UITextField = UITextField().then {
        $0.text = " 생년월일을 입력해주세요."
        $0.font = UIFont.systemFont(ofSize: 15)
        $0.backgroundColor = .gray
        $0.textColor = .darkGray
        $0.layer.cornerRadius = 3
    }
    private let phoneNumber: UITextField = UITextField().then {
        $0.text = " 전화번호를 입력해주세요."
        $0.font = UIFont.systemFont(ofSize: 15)
        $0.backgroundColor = .gray
        $0.textColor = .darkGray
        $0.layer.cornerRadius = 3
    }
    private let ID: UITextField = UITextField().then {
        $0.text = " 아이디를 입력해주세요."
        $0.font = UIFont.systemFont(ofSize: 15)
        $0.backgroundColor = .gray
        $0.textColor = .darkGray
        $0.layer.cornerRadius = 3
    }
    private let password: UITextField = UITextField().then {
        $0.text = " 비밀번호를 입력해주세요."
        $0.font = UIFont.systemFont(ofSize: 15)
        $0.backgroundColor = .gray
        $0.textColor = .darkGray
        $0.layer.cornerRadius = 3
    }
    private let joinBtn: UIButton = UIButton().then {
        $0.backgroundColor = .systemBlue
        $0.setTitle("회원가입", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 3
        $0.addTarget(self, action: #selector(joinBtnTapped), for: .touchDown)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    
    private func configureUI() {
        
        view.addSubview(joinLabel)
        joinLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(15)
            $0.height.equalTo(250)
        }
        view.addSubview(name)
        name.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.top.equalTo(joinLabel.snp.bottom).offset(15)
            $0.height.equalTo(40)
        }
        view.addSubview(birth)
        birth.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.top.equalTo(name.snp.bottom).offset(15)
            $0.height.equalTo(40)
        }
        view.addSubview(phoneNumber)
        phoneNumber.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.top.equalTo(birth.snp.bottom).offset(15)
            $0.height.equalTo(40)
        }
        view.addSubview(ID)
        ID.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.top.equalTo(phoneNumber.snp.bottom).offset(15)
            $0.height.equalTo(40)
        }
        view.addSubview(password)
        password.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.top.equalTo(ID.snp.bottom).offset(15)
            $0.height.equalTo(40)
        }
        view.addSubview(joinBtn)
        joinBtn.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.top.equalTo(password.snp.bottom).offset(70)
            $0.height.equalTo(60)
        }
        
    }
    
    //회원가입 완료 후 메인페이지로 이동하는 Alert
    @objc
    private func joinBtnTapped() {
            let alert = UIAlertController(title: "Welcome!", message: "회원가입이 완료되었습니다!", preferredStyle: .alert)
            let done = UIAlertAction(title: "확인", style: .default, handler: nil)
            
            alert.addAction(done)
            present(alert, animated: true)
        }
    
}
