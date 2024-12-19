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
    
    //MARK: 각 요소들의 속성 부분
    //UserDefaults 부분 추후 확인을 위해 일단 주석처리 함. 추후 삭제예정
    private let joinLabel: UILabel = UILabel().then {
        $0.text = "티켓스퀘어 회원가입"
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 30)
        $0.textColor = .white
    }
    private let name: UITextField = UITextField().then {
        $0.placeholder = " 이름을 입력해주세요."
        $0.font = UIFont.systemFont(ofSize: 15)
        $0.backgroundColor = .gray
        $0.textColor = .darkGray
        $0.layer.cornerRadius = 3
        
        $0.keyboardType = .default
        $0.clearButtonMode = .whileEditing
        $0.returnKeyType = .next
        
        $0.becomeFirstResponder() //화면에서 가장 처음으로 포커스 주는 부분
        //$0.text = UserDefaults.standard.string(forKey: "Name")
    }
    private let birth: UITextField = UITextField().then {
        $0.placeholder = " 생년월일을 입력해주세요."
        $0.font = UIFont.systemFont(ofSize: 15)
        $0.backgroundColor = .gray
        $0.textColor = .darkGray
        $0.layer.cornerRadius = 3
        
        $0.keyboardType = .default
        $0.clearButtonMode = .whileEditing
        $0.returnKeyType = .next
        
        //$0.text = UserDefaults.standard.string(forKey: "Birth")
    }
    private let phoneNumber: UITextField = UITextField().then {
        $0.placeholder = " 전화번호를 입력해주세요."
        $0.font = UIFont.systemFont(ofSize: 15)
        $0.backgroundColor = .gray
        $0.textColor = .darkGray
        $0.layer.cornerRadius = 3
        
        $0.keyboardType = .default
        $0.clearButtonMode = .whileEditing
        $0.returnKeyType = .next
        
        //$0.text = UserDefaults.standard.string(forKey: "PhoneNumber")
    }
    private let id: UITextField = UITextField().then {
        $0.placeholder = " 아이디를 입력해주세요."
        $0.font = UIFont.systemFont(ofSize: 15)
        $0.backgroundColor = .gray
        $0.textColor = .darkGray
        $0.layer.cornerRadius = 3
        
        $0.keyboardType = .emailAddress
        $0.clearButtonMode = .whileEditing
        $0.returnKeyType = .next
        
        //$0.text = UserDefaults.standard.string(forKey: "ID")
    }
    private let password: UITextField = UITextField().then {
        $0.placeholder = " 비밀번호를 입력해주세요."
        $0.font = UIFont.systemFont(ofSize: 15)
        $0.backgroundColor = .gray
        $0.textColor = .darkGray
        $0.layer.cornerRadius = 3
        
        $0.keyboardType = .default
        $0.clearButtonMode = .whileEditing
        $0.returnKeyType = .done
        
        //$0.text = UserDefaults.standard.string(forKey: "PW")
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
    
    
    //MARK: 각 요소들의 UI 구현 부분
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
        view.addSubview(id)
        id.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.top.equalTo(phoneNumber.snp.bottom).offset(15)
            $0.height.equalTo(40)
        }
        view.addSubview(password)
        password.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(10)
            $0.top.equalTo(id.snp.bottom).offset(15)
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
        UserDefaults.standard.set(id.text, forKey: "ID")
        UserDefaults.standard.set(password.text, forKey: "PW")
        UserDefaults.standard.set(name.text, forKey: "Name")
        UserDefaults.standard.set(phoneNumber.text, forKey: "PhoneNumber")
        UserDefaults.standard.set(birth.text, forKey: "Birth")
        
        let alert = UIAlertController(title: "Welcome!", message: "회원가입이 완료되었습니다!", preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            self?.navigationController?.pushViewController(Login(), animated: true)
//            MainViewController().modalPresentationStyle = .fullScreen
//            self?.present(MainViewController(), animated: true, completion: nil)
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
    
}


