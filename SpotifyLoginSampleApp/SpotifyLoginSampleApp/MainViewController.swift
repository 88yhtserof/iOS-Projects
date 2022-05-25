//
//  MainViewController.swift
//  SpotifyLoginSampleApp
//
//  Created by 임윤휘 on 2022/05/24.
//

import UIKit
import FirebaseAuth

class MainViewController: UIViewController {
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
    }
    
    @IBAction func tapSignOutButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
