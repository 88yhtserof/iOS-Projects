//
//  CardDetailViewController.swift
//  CreditCardList
//
//  Created by 임윤휘 on 2022/06/24.
//

import UIKit
import Lottie

class CardDetailViewController: UIViewController {
    @IBOutlet weak var lottieView: LottieView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Lottie 라이브러리 사용
        //움직이는 애니메이션 뷰.
        let animationView = AnimationView(name: "money")
        lottieView.contentMode = .scaleAspectFit
        lottieView.addSubview(animationView)
        animationView.frame = lottieView.bounds
        animationView.loopMode = .loop
        animationView.play()
    }
}
