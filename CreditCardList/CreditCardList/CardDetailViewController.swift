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
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var periodLabel: UILabel!
    @IBOutlet weak var conditionLabel: UILabel!
    @IBOutlet weak var benefitConditionLabel: UILabel!
    @IBOutlet weak var benefitDetailLabel: UILabel!
    @IBOutlet weak var benefitDateLabel: UILabel!
    
    var promotionDetail: promotionDetail?
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let promotionDetail = promotionDetail else {return}
        
        titleLabel.text = """
        \(promotionDetail.companyName)카드 사용 시
        \(promotionDetail.amount)만원을 드려요!
        """
        periodLabel.text = promotionDetail.period
        conditionLabel.text = promotionDetail.benefitCondition
        benefitConditionLabel.text = promotionDetail.benefitCondition
        benefitDetailLabel.text = promotionDetail.benefitDetail
        benefitDateLabel.text = promotionDetail.benefitDate
    }
}
