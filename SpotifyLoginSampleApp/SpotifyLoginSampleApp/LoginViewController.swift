//
//  LoginViewController.swift
//  SpotifyLoginSampleApp
//
//  Created by 임윤휘 on 2022/05/24.
//

import UIKit
import Firebase
import GoogleSignIn
import AuthenticationServices
import CryptoKit

class LoginViewController: UIViewController {
    @IBOutlet weak var emailSignInButton: UIButton!
    @IBOutlet weak var googleSignInButton: UIButton!
    @IBOutlet weak var appleSignInButton: UIButton!
    
    // Unhashed nonce.
    fileprivate var currentNonce: String?
    
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
        startSignInWithAppleFlow()
    }
    
    //메인 화면으로 이동
    private func showMainViewController(){
        let main = UIStoryboard(name: "Main", bundle: Bundle.main)
        
        guard let mainViewController = main.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController else {return}
        
        self.navigationController?.pushViewController(mainViewController, animated: true)
        
    }
}

//nonce를 암호화하는 함수 모음 extension
//Firebase 공식문서https://firebase.google.com/docs/auth/ios/apple?authuser=0
extension LoginViewController {
    /*
     nonce란?
     - 암호화된 임의의 난수
     - 단 한번만 사용할 수 있는 값
     - 주로 암호화 통신을 할 때 활용
     - 동일한 요청을 짧은 시간에 여러 번 보내는 릴레이 공격 방지
     - 정보 탈취 없이 안전한 인증 정보 전달을 위한 안전장치
     - SecRandomCopyBytes(_:_:_)를 통해 안전한 nonce를 생성할 수 있다.
     */
    // Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
    //랜덤한 값의 nonce를 생성
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError(
                        "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
                    )
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 {
                    return
                }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        
        return result //nonce 반환
    }
    
    //로그인 요청에 nonce를 보내는데, Apple에서는 이 값을 그대로 응답과 함께 보낼 것이다.
    //Firebase는 원래 nonce와 응답으로 받은 nonce 값을 비교하고 해싱하여 검증한다.
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    //Apple의 로그인 flow 시작하기
    //cryptoKit 사용
    func startSignInWithAppleFlow() {
        let nonce = randomNonceString() //랜덤한 값으로 암화화된 nonce
        currentNonce = nonce //해싱되지 않은 nonce값 할당
        let appleIDProvider = ASAuthorizationAppleIDProvider() //요청을 생성하는 메카니즘
        let request = appleIDProvider.createRequest()  //이 request에 nonce가 추가되어 릴레이 공격을 방지하고 추후 firebase에서 무결성을 확인할 수 있게 된다.
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])//authorization requests 관리하는 컨트롤러
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
}

@available(iOS 13.0, *)
//ASAuthorizationControllerDelegate를 사용하여 Apple의 응답을 다루어라
//로그인에 성공한다면 Firebase에 인증하기 위해 Apple의 응답으로 오는 ID토큰과 해싱되지 않은 nonce(전역 변수 currentNonce)를 사용해라
extension LoginViewController: ASAuthorizationControllerDelegate {
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
            //ASAuthorizationController을 통해 인증정보를 전달해서 appleIDCredential를 받게 되면 토큰을 얻게 된다.
            //앱에서 애플 계정으로, fireblase로 nonce는 안전하게 인증정보가 전달되도록 도운다
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            guard let appleIDToken = appleIDCredential.identityToken else {
                print("Unable to fetch identity token")
                return
            }
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            // Initialize a Firebase credential.
            let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                      idToken: idTokenString,
                                                      rawNonce: nonce)
            // Sign in with Firebase.
            Auth.auth().signIn(with: credential) { (authResult, error) in
                if let error = error {
                    // Error. If error.code == .MissingOrInvalidNonce, make sure
                    // you're sending the SHA256-hashed nonce as a hex string with
                    // your request to Apple.
                    print(error.localizedDescription)
                    return
                }
                // User is signed in to Firebase with Apple.
                // ...
                //로그인 성공 시
                let main = UIStoryboard(name: "Main", bundle: Bundle.main.self)
                guard let mainViewController = main.instantiateViewController(withIdentifier: "MainViewController") as? MainViewController else {return}
                self.navigationController?.pushViewController(mainViewController, animated: true)
            }
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
        print("Sign in with Apple errored: \(error)")
    }
    
}

extension LoginViewController:  ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window! //로그인 창이 띄워지는 곳
    }
}
