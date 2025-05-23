//
//  LoginViewController.swift
//  OwD-iOS
//
//  Created by 이인호 on 5/24/25.
//

import UIKit
import SnapKit

class LoginViewController: UIViewController {
    
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "loginBackground")
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private let label1: UILabel = {
        let label = UILabel()
        label.text = "이웃과 함께"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .white
        return label
    }()

    private let label2: UILabel = {
        let label = UILabel()
        label.text = "살아나는 골목상권"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private lazy var kakaoLoginButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "kakao_login"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        
        button.addAction(UIAction { [weak self] _ in
            LoginManager.shared.kakaoLogin()
        }, for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }

    func configureUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(logoImageView)
        view.addSubview(label1)
        view.addSubview(label2)
        view.addSubview(kakaoLoginButton)
        
        logoImageView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
        
        label1.snp.makeConstraints {
            $0.centerY.equalToSuperview().offset(-70)
            $0.leading.equalToSuperview().offset(65)
        }
        
        label2.snp.makeConstraints { make in
            make.top.equalTo(label1.snp.bottom).offset(4)
            make.leading.equalTo(label1)
        }
        kakaoLoginButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
            $0.bottom.equalToSuperview().offset(-70)
            $0.height.equalTo(80)
        }
    }
}
