//
//  JoinPage.swift
//  TicketSquare
//
//  Created by 이재건 on 12/16/24.
//

import UIKit
import SnapKit
import Then

class Join: UIViewController, UITextFieldDelegate {
    
    //MARK: 각 요소들의 속성 부분
    private let joinLabel: UILabel = UILabel().then {
        $0.text = "티켓스퀘어 회원가입"
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 30)
        $0.textColor = .white
    }
    private let name: UITextField = UITextField().then {
        $0.placeholder = "이름을 입력해주세요."
        $0.font = UIFont.systemFont(ofSize: 15)
        $0.backgroundColor = .lightGray
        $0.textColor = .black
        $0.borderStyle = .roundedRect
        
        $0.keyboardType = .default
        $0.clearButtonMode = .whileEditing
        $0.returnKeyType = .next
    }
    private let birth: UITextField = UITextField().then {
        $0.placeholder = "생년월일 6자리를 입력해주세요."
        $0.font = UIFont.systemFont(ofSize: 15)
        $0.backgroundColor = .lightGray
        $0.textColor = .black
        $0.borderStyle = .roundedRect
        
        $0.keyboardType = .default
        $0.clearButtonMode = .whileEditing
        $0.returnKeyType = .next
    }
    private let phoneNumber: UITextField = UITextField().then {
        $0.placeholder = "전화번호를 입력해주세요.(-는 제외)"
        $0.font = UIFont.systemFont(ofSize: 15)
        $0.backgroundColor = .lightGray
        $0.textColor = .black
        $0.borderStyle = .roundedRect
        
        $0.keyboardType = .default
        $0.clearButtonMode = .whileEditing
        $0.returnKeyType = .next
    }
    private let id: UITextField = UITextField().then {
        $0.placeholder = " 아이디를 입력해주세요."
        $0.font = UIFont.systemFont(ofSize: 15)
        $0.backgroundColor = .lightGray
        $0.textColor = .black
        $0.borderStyle = .roundedRect
        
        $0.keyboardType = .emailAddress
        $0.clearButtonMode = .whileEditing
        $0.returnKeyType = .next
    }
    private let password: UITextField = UITextField().then {
        $0.placeholder = " 비밀번호를 입력해주세요."
        $0.font = UIFont.systemFont(ofSize: 15)
        $0.backgroundColor = .lightGray
        $0.textColor = .black
        $0.borderStyle = .roundedRect
        
        $0.keyboardType = .default
        $0.clearButtonMode = .whileEditing
        $0.returnKeyType = .done
    }
    private let joinBtn: UIButton = UIButton().then {
        $0.backgroundColor = .gray
        $0.setTitle("회원가입", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 5
        $0.addTarget(self, action: #selector(joinBtnTapped), for: .touchDown)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        name.delegate = self
        birth.delegate = self
        phoneNumber.delegate = self
        id.delegate = self
        password.delegate = self
    }
    
    
    //MARK: 각 요소들의 UI 구현 부분
    private func configureUI() {
        self.navigationController?.navigationBar.isHidden = false;
        view.backgroundColor = UIColorStyle.bg
        
        view.addSubview(joinLabel)
        joinLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(15)
            $0.height.equalTo(250)
        }
        view.addSubview(name)
        name.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.top.equalTo(joinLabel.snp.bottom).offset(20)
            $0.height.equalTo(40)
        }
        view.addSubview(birth)
        birth.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.top.equalTo(name.snp.bottom).offset(20)
            $0.height.equalTo(40)
        }
        view.addSubview(phoneNumber)
        phoneNumber.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.top.equalTo(birth.snp.bottom).offset(20)
            $0.height.equalTo(40)
        }
        view.addSubview(id)
        id.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.top.equalTo(phoneNumber.snp.bottom).offset(20)
            $0.height.equalTo(40)
        }
        view.addSubview(password)
        password.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.top.equalTo(id.snp.bottom).offset(20)
            $0.height.equalTo(40)
        }
        view.addSubview(joinBtn)
        joinBtn.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.top.equalTo(password.snp.bottom).offset(70)
            $0.height.equalTo(60)
        }
        
    }
    
    //MARK: Button Action
    //회원가입 완료 후 메인페이지로 이동하는 Alert
    @objc
    private func joinBtnTapped() {
        //MARK: 회원가입 정보 저장
        UserDefaults.standard.set(id.text, forKey: "ID")
        UserDefaults.standard.set(password.text, forKey: "PW")
        UserDefaults.standard.set(name.text, forKey: "Name")
        UserDefaults.standard.set(phoneNumber.text, forKey: "PhoneNumber")
        UserDefaults.standard.set(birth.text, forKey: "Birth")
        
        //TextField가 전부 채워졌는지 검증
        let textField = [id, password, name, phoneNumber, birth]
        if textField.allSatisfy({ !$0.text!.isEmpty }) {
            welcomAlert()
        } else {
            errorAlert()
        }
        
    }
    
    //MARK: 키보드 설정
    //다른 공간 터치시 키보드 사라짐
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesBegan(touches, with: event)
    }
    
    //다음 TextField로 포커스 이동
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == name {
            birth.becomeFirstResponder() // 다음 필드로 포커스 이동
        } else if textField == birth {
            phoneNumber.becomeFirstResponder()
        } else if textField == phoneNumber {
            id.becomeFirstResponder()
        } else if textField == id {
            password.becomeFirstResponder()
        } else if textField == password {
            textField.resignFirstResponder() // 키보드 숨기기
        }
        return true
    }
    
    //MARK: Alerts
    func welcomAlert() {
        let alert = UIAlertController(title: "Welcome!", message: "회원가입이 완료되었습니다!", preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
    func errorAlert() {
        let alert = UIAlertController(title: "오류", message: "빈칸 없이 입력해주세요.", preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: .default)
        alert.addAction(action)
        present(alert, animated: true)
    }
    
}


