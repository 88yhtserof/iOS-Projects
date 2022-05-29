//
//  EnterEmailViewController.swift
//  SpotifyLoginSampleApp
//
//  Created by 임윤휘 on 2022/05/24.
//

import UIKit
import FirebaseAuth

class EnterEmailViewController: UIViewController {
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorMessageLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextButton.layer.cornerRadius = 30
        nextButton.isEnabled = false
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        //커서를 바로 email TextField에 위치하도록 하기
        emailTextField.becomeFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.title = "이메일/비밀번호로 로그인하기"
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    @IBAction func tapNextButton(_ sender: UIButton) {
        //Firebase 이메일/비밀번호 인증
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        //신규 사용자 생성
        //순환 참조 방지를 위해 weak self 처리
        Auth.auth().createUser(withEmail: email, password: password){[weak self] authResult, error in
            //회원가입이 끝났거나 취소되었을 때 호출되는 클로저
            guard let self = self else {return}
            
            if let error = error {//오류가 발생한 경우
                let code = (error as NSError).code
                switch code {
                case 17007: //이미 가입한 계정인 경우
                    self.signInUer(withEmail: email, password: password) //로그인 하기
                default:
                    self.errorMessageLabel.text = error.localizedDescription
                }
            }else {//정상적으로 회원가입이 된 경우
                self.showMainViewController()
            }
        }
    }
    
    private func showMainViewController(){
        let main = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let mainViewController = main.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController else {return}
        
        mainViewController.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(mainViewController, animated: true)
    }
    
    //Firebase 인증을 통해 로그인할 수 있는 함수
    private func signInUer(withEmail email: String, password: String){
        Auth.auth().signIn(withEmail: email, password: password){ [weak self] _, error in
            guard let self = self else {return}
            
            if let error = error {//로그인 에러가 발생한 경우
                self.errorMessageLabel.text = error.localizedDescription
            }else{//정상적으로 로그인된 경우
                self.showMainViewController()
            }
            
        }
    }
}

extension EnterEmailViewController: UITextFieldDelegate {
    //이메일 또는 비밀번호 작성이 끝난 후 키보드의 리턴 버튼이 눌리면 호출되는 메서드
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true) //뷰의 수정이 끝나면
        return false //키보드 내리기
    }
    
    // 글 수정이 다 끝나면 호출
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        
        nextButton.isEnabled = !email.isEmpty && !password.isEmpty
    }
}
