//
//  LoginPage.swift
//  TicketSquare
//
//  Created by 이재건 on 12/16/24.
//

import UIKit
import SnapKit
import Then

class Login: UIViewController, UITextFieldDelegate {
    
    //MARK: 각 요소들의 속성 부분
    private let loginLabel: UILabel = UILabel().then {
        $0.text = "티켓스퀘어 ID 로그인"
        $0.textAlignment = .left
        $0.font = UIFont.systemFont(ofSize: 30)
        $0.textColor = .white
    }
    private let id: UITextField = UITextField().then {
        $0.placeholder = "아이디"
        $0.font = UIFont.systemFont(ofSize: 25)
        $0.backgroundColor = .lightGray
        $0.textColor = .black
        $0.borderStyle = .roundedRect
        
        $0.keyboardType = .emailAddress
        $0.clearButtonMode = .whileEditing
        $0.returnKeyType = .next
    }
    private let password: UITextField = UITextField().then {
        $0.placeholder = "비밀번호"
        $0.font = UIFont.systemFont(ofSize: 25)
        $0.backgroundColor = .lightGray
        $0.textColor = .black
        $0.borderStyle = .roundedRect
        
        $0.keyboardType = .default
        $0.clearButtonMode = .whileEditing
        $0.returnKeyType = .done
        $0.isSecureTextEntry = true
        $0.textContentType = .password
    }
    private let loginBtn: UIButton = UIButton().then {
        $0.setTitle("로그인하기", for: .normal)
        $0.backgroundColor = .gray
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 4
        $0.addTarget(self, action: #selector(loginBtnTapped), for: .touchDown)
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
        
        id.delegate = self
        password.delegate = self
    }
    
    
    //MARK: 각 요소들의 UI 구현 부분
    private func configureUI() {
        self.navigationController?.navigationBar.isHidden = true;

        view.backgroundColor = UIColorStyle.bg
        
        view.addSubview(loginLabel)
        loginLabel.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(15)
            $0.height.equalTo(200)
        }
        view.addSubview(id)
        id.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.top.equalTo(loginLabel.snp.bottom)
            $0.height.equalTo(50)
        }
        view.addSubview(password)
        password.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.top.equalTo(id.snp.bottom).offset(10)
            $0.height.equalTo(50)
        }
        view.addSubview(loginBtn)
        loginBtn.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.top.equalTo(password.snp.bottom).offset(20)
            $0.height.equalTo(50)
        }
        view.addSubview(joinBtn)
        joinBtn.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.top.equalTo(loginBtn.snp.bottom).offset(20)
        }
    }
    
    //MARK: Button Actions
    //회원가입 버튼이 눌렸을 때
    @objc
    private func joinBtnTapped() {
        self.navigationController?.pushViewController(Join(), animated: true)
    }
    
    //로그인 버튼이 눌렸을 때
    @objc
    private func loginBtnTapped() {
        //UserDefaults에 저장되어있는 아이디와 비밀번호
        let checkID = UserDefaults.standard.string(forKey: UserInfo.Key.id)
        let checkPW = UserDefaults.standard.string(forKey: UserInfo.Key.password)
        
        //사용자가 입력한 아이디와 비밀번호
        let userInputID = id.text
        let userInputPW = password.text
        
        //UserDefaults와 사용자가 입력한 값을 비교하여 판단
        if checkID == userInputID && checkPW == userInputPW {
            self.navigationController?.pushViewController(MainTabBarController(), animated: true)
            self.navigationController?.navigationBar.isHidden = true
        } else {
            let alert = UIAlertController(title: "로그인 실패", message: "아이디, 비밀번호를 다시 확인해주세요.", preferredStyle: .alert)
            let action = UIAlertAction(title: "확인", style: .default)
            alert.addAction(action)
            present(alert, animated: true)
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
        if textField == id {
            password.becomeFirstResponder() // 다음 필드로 포커스 이동
        } else if textField == password {
            textField.resignFirstResponder() // 키보드 숨기기
        }
        return true
    }
}

