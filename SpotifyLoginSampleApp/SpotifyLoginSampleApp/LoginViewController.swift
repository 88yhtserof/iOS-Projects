//
//  LoginViewController.swift
//  SpotifyLoginSampleApp
//
//  Created by 임윤휘 on 2022/05/24.
//

import UIKit

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
    }
    
    @IBAction func tapAppleSignInButton(_ sender: UIButton) {
    }
}
