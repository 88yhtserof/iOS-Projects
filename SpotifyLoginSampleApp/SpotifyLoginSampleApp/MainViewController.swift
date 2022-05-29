//
//  MainViewController.swift
//  SpotifyLoginSampleApp
//
//  Created by 임윤휘 on 2022/05/24.
//

import UIKit
import FirebaseAuth

class MainViewController: UIViewController {
    @IBOutlet weak var resetPasswordButton: UIButton!
    @IBOutlet weak var welcomeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //navigationBar가 보이거나 popgesture를 했을 때 보이는 뒤로 가기 제스처 비활성화
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let email = Auth.auth().currentUser?.email ?? "고객"
        
        welcomeLabel.text = """
환영합니다.
\(email)님
"""
        
        //이메일/비밀번호 회원인지 알아내기
        let isEmailSignIn = Auth.auth().currentUser?.providerData[0].providerID == "password"
        //이메일/비밀번호 회원일 경우에만 비밀번호 변경 버튼 보이기
        resetPasswordButton.isHidden = !isEmailSignIn
    }
    
    @IBAction func tapSignOutButton(_ sender: UIButton) {
        //Firebase의 signOut 함수는 에러 처리를 위한 throw 함수이기 때문에 do try catch문 사용한다.
        let firebaseAuth = Auth.auth()
        do{
            try firebaseAuth.signOut()
            //오류가 발생하지 않는다면
            self.navigationController?.popToRootViewController(animated: true)
        }catch let signOutError as NSError {
            print("ERROR: signOut \(signOutError)")
        }
    }
    
    //비밀번호 변경하는 버튼
    @IBAction func tapResetPasswordButton(_ sender: UIButton) {
        let email = Auth.auth().currentUser?.email ?? ""
        
        Auth.auth().sendPasswordReset(withEmail: email, completion: {_ in 
            print("비밀번호 변경")
        })
    }
    
    @IBAction func tapProfileChangeButton(_ sender: UIButton) {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest() //프로필 데이터 수정할 수 있는 객체
        
        let alert = UIAlertController(title: "프로필 이름 설정", message: "이름을 입력하세요.", preferredStyle: .alert)
        let action = UIAlertAction(title: "완료", style: .default){[weak self] _ in
            guard let name = alert.textFields?[0].text else {return}
            changeRequest?.displayName = name
            
            changeRequest?.commitChanges(){_ in //변경된 사항을 커밋한다.
                let name = Auth.auth().currentUser?.displayName ?? Auth.auth().currentUser?.email ?? ""
                self?.welcomeLabel.text = """
    환영합니다.
    \(name)님
    """
            }
        }
        
        alert.addAction(action)
        alert.addTextField{textField in
            textField.placeholder = "이름을 입력하세요."
        }
        
        present(alert, animated: true)
    }
}
