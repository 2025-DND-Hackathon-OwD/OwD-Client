//
//  ProfileSetupViewController.swift
//  OwD-iOS
//
//  Created by 이인호 on 5/24/25.
//

import UIKit

class ProfileSetupViewController: UIViewController {
    
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.text = "반가워요!\n어떤 역할이신가요?"
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        
        return label
    }()
    
    private lazy var ownerButton: UIButton = {
        let button = UIButton()
        button.setTitle("가게 사장", for: .normal)
        button.setTitleColor(.systemGray2, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.tintColor = .clear
        button.backgroundColor = .systemGray5
        button.layer.cornerRadius = 27
        
        button.addTarget(self, action: #selector(ownerButtonTapped(_:)), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var customerButton: UIButton = {
       let button = UIButton()
        button.setTitle("동네 손님", for: .normal)
        button.setTitleColor(.systemGray2, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.tintColor = .clear
        button.backgroundColor = .systemGray5
        button.layer.cornerRadius = 27
        
        button.addTarget(self, action: #selector(customerButtonTapped(_:)), for: .touchUpInside)
        
        return button
    }()
    
    @objc func ownerButtonTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1, animations: {
            sender.backgroundColor = .mainLightColor // 누른 느낌 색
            sender.layer.borderWidth = 1
            sender.layer.borderColor = UIColor.mainColor?.cgColor
        }) { _ in
            // 다시 원래 색상으로
            UIView.animate(withDuration: 0.1) {
                sender.backgroundColor = UIColor.systemGray5 // 원래 색
                sender.layer.borderWidth = 0
            }
            
            // 화면 전환
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                let vc = StoreInfoInputViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    @objc func customerButtonTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.1, animations: {
            sender.backgroundColor = .mainLightColor // 누른 느낌 색
            sender.layer.borderWidth = 1
            sender.layer.borderColor = UIColor.mainColor?.cgColor
        }) { _ in
            // 다시 원래 색상으로
            UIView.animate(withDuration: 0.1) {
                sender.backgroundColor = UIColor.systemGray5 // 원래 색
                sender.layer.borderWidth = 0
            }
            
            // 화면 전환
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let delegate = scene.delegate as? SceneDelegate {
                    delegate.showMainScreen()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.backButtonTitle = ""
        configureUI()
    }
    
    func configureUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(titleLabel)
        view.addSubview(ownerButton)
        view.addSubview(customerButton)
        
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(40)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(100)
        }
        
        ownerButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
            $0.bottom.equalTo(customerButton.snp.top).offset(-10)
            $0.height.equalTo(80)
        }
        
        customerButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
            $0.bottom.equalToSuperview().offset(-100)
            $0.height.equalTo(80)
        }
    }
}
