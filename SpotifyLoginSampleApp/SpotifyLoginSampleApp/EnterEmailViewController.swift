//
//  EnterEmailViewController.swift
//  SpotifyLoginSampleApp
//
//  Created by 임윤휘 on 2022/05/24.
//

import UIKit

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
        let main = UIStoryboard(name: "Main", bundle: nil)
        guard let mainViewController = main.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController else {return}
        
        self.navigationController?.pushViewController(mainViewController, animated: true)
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
