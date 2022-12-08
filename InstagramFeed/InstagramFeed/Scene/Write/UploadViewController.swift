//
//  UploadViewController.swift
//  InstagramFeed
//
//  Created by 임윤휘 on 2022/12/08.
//

import UIKit

class UploadViewController: UIViewController {
    private let uploadImage: UIImage
    
    private let imageView = UIImageView()
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.text = "문구 입력..."
        textView.textColor = .secondaryLabel
        textView.font = .systemFont(ofSize: 15.0, weight: .regular)
        
        textView.delegate = self
        
        return textView
    }()
    
    required init(uploadImage: UIImage) {
        self.uploadImage = uploadImage
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureNavigationBar()
        configureView()
        
        imageView.image = uploadImage
    }
}

extension UploadViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        guard textView.textColor == .secondaryLabel else { return }
        
        textView.text = nil
        textView.textColor = .label
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
        
        [ imageView, textView ].forEach{ view.addSubview($0) }
        //소수점이 Double인지, CGFloat인지 구분하지 못해 컴파일 시간이 약간 더 소요될 수도 있고 컴파일 에러가 되는 원인이 되기도 한다.
        //동일하게 Int 사용 시에도 Int인지 UInt 등과 구분하기 위해 명시해주는 것이 좋다.
        let imageViewInset: CGFloat = 16.0
        
        imageView.snp.makeConstraints{ make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(imageViewInset)
            make.leading.equalToSuperview().inset(imageViewInset)
            make.width.equalTo(100.0)
            make.height.equalTo(imageView.snp.width)
        }
        
        textView.snp.makeConstraints{ make in
            make.leading.equalTo(imageView.snp.trailing).offset(imageViewInset)
            make.trailing.equalToSuperview().inset(imageViewInset)
            make.verticalEdges.equalTo(imageView.snp.verticalEdges)
            
        }
    }
}
