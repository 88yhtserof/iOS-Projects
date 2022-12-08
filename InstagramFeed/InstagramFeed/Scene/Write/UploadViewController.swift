//
//  UploadViewController.swift
//  InstagramFeed
//
//  Created by 임윤휘 on 2022/12/08.
//

import UIKit

class UploadViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
        configureView()
    }
}

private extension UploadViewController {
    func configureNavigationBar(){
        navigationItem.title = "새 게시물"
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "취소",
            style: .plain,
            target: self,
            action: #selector(didTapLeftButton)
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "공유",
            style: .plain,
            target: self,
            action: #selector(didTapRightButton)
        )
    }
    
    @objc func didTapLeftButton(){
        print("Did Tap LeftButton")
        
        dismiss(animated: true)
    }
    
    @objc func didTapRightButton(){
        print("Did Tap RightButton")
        
        dismiss(animated: true)
    }
    
    func configureView(){
        view.backgroundColor = .systemBackground
    }
}
