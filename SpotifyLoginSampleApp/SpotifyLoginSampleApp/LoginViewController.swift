//
//  LoginViewController.swift
//  SpotifyLoginSampleApp
//
//  Created by 임윤휘 on 2022/05/24.
//

import UIKit
import Firebase
import GoogleSignIn

class LoginViewController: UIViewController {
    @IBOutlet weak var emailSignInButton: UIButton!
    @IBOutlet weak var googleSignInButton: UIButton!
    @IBOutlet weak var appleSignInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        [emailSignInButton, googleSignInButton,appleSignInButton].forEach{
            $0?.layer.borderWidth = 1
            $0?.layer.borderColor = UIColor.white.cgColor
            $0?.layer.cornerRadius = 30
        }
    }
    
    @IBAction func tapEmailSignInButton(_ sender: UIButton) {
        let EnterEmail = UIStoryboard(name: "EnterEmail", bundle: nil)
        guard let enterEmailViewController = EnterEmail.instantiateViewController(withIdentifier: "EnterEmailViewController") as? EnterEmailViewController else {return}
        
        self.navigationController?.pushViewController(enterEmailViewController, animated: true)
    }
    
    @IBAction func tapGoogleSignInButton(_ sender: UIButton) {
        //구글 로그인  Firebase개발 문서
        //https://firebase.google.com/docs/auth/ios/google-signin?hl=ko#swift_3
        
        guard let clientID = FirebaseApp.app()?.options.clientID else { return }
        
        // Create Google Sign In configuration object.
        let config = GIDConfiguration(clientID: clientID)
        
        // Start the sign in flow!
        //구글 로그인
        GIDSignIn.sharedInstance.signIn(with: config, presenting: self) { [unowned self] user, error in
            
            if let error = error {
                print("ERROR: \(error.localizedDescription)")
                return
            }
            
            guard let authentication = user?.authentication,
                  let idToken = authentication.idToken
            else {return}
            
            let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                           accessToken: authentication.accessToken)
            
            //Firebase에 사용자 정보 등록하기
            Auth.auth().signIn(with: credential){_, _ in
                self.showMainViewController()
            }
        }
    }
    
    @IBAction func tapAppleSignInButton(_ sender: UIButton) {
    }
    
    //메인 화면으로 이동
    private func showMainViewController(){
        let main = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        guard let mainViewController = main.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController else {return}
        
        self.navigationController?.pushViewController(mainViewController, animated: true)
                
    }
}
