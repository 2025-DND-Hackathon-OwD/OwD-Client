//
//  StoreInfoInputViewController.swift
//  OwD-iOS
//
//  Created by 이인호 on 5/24/25.
//

import UIKit
import PhotosUI

struct CategoryItem {
    let title: String
    let icon: UIImage?
}

enum SectionType: Int, CaseIterable {
    case category
    case benefit
}

class StoreInfoInputViewController: UIViewController {
    private var selectedImage: UIImage?

    // ✅ 미리보기용 이미지 뷰 추가 (뷰 구성에 포함되어야 함)
    private let selectedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        imageView.backgroundColor = .systemGray5
        imageView.isHidden = true // ✅ 초기에는 숨김
        return imageView
    }()
    
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.text = "가게 정보를 입력해주세요"
        label.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        
        return label
    }()
    
    private let storeNameLabel: UILabel = {
       let label = UILabel()
        label.text = "가게 이름"
        
        return label
    }()
    
    private let storeNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "가게 이름을 입력해주세요"
        textField.layer.cornerRadius = 20
        textField.backgroundColor = .systemGray5
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        return textField
    }()
    
    private let branchNameLabel: UILabel = {
       let label = UILabel()
        label.text = "지점명"
        
        return label
    }()
    
    private let branchNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "지점명을 입력해주세요"
        textField.layer.cornerRadius = 20
        textField.backgroundColor = .systemGray5
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        return textField
    }()
    
    private let addressLabel: UILabel = {
       let label = UILabel()
        label.text = "주소"
        
        return label
    }()
    
    private let addressTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "주소를 입력해주세요"
        textField.layer.cornerRadius = 20
        textField.backgroundColor = .systemGray5
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 12, height: 0))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        return textField
    }()
    
    private let categoryLabel: UILabel = {
       let label = UILabel()
        label.text = "카테고리"
        
        return label
    }()
    
    private let benefitLabel: UILabel = {
       let label = UILabel()
        label.text = "제휴혜택"
        
        return label
    }()
    
    private var selectedCategoryIndex: Int = 0
    private var selectedBenefitIndex: Int = 0

       private let categories = [
           CategoryItem(title: "밥집", icon: UIImage(systemName: "takeoutbag.and.cup.and.straw.fill")),
           CategoryItem(title: "카페", icon: UIImage(systemName: "cup.and.saucer.fill")),
           CategoryItem(title: "1차술집", icon: UIImage(systemName: "wineglass")),
           CategoryItem(title: "2차술집", icon: UIImage(systemName: "wineglass"))
       ]

       private let benefits = [
           CategoryItem(title: "10%할인", icon: nil),
           CategoryItem(title: "20%할인", icon: nil),
           CategoryItem(title: "30%할인", icon: nil)
       ]

       private lazy var categoryCollectionView: UICollectionView = {
           let layout = UICollectionViewFlowLayout()
           layout.scrollDirection = .horizontal
           layout.minimumLineSpacing = 12
           layout.minimumInteritemSpacing = 8

           let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
           cv.delegate = self
           cv.dataSource = self
           cv.tag = 0
           cv.register(OptionCell.self, forCellWithReuseIdentifier: OptionCell.id)
           cv.backgroundColor = .clear
           return cv
       }()
    
    private lazy var benefitCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 20
        layout.minimumInteritemSpacing = 8

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        cv.tag = 1
        cv.register(OptionCell.self, forCellWithReuseIdentifier: OptionCell.id)
        cv.backgroundColor = .clear
        return cv
    }()
    
    private let imageLabel: UILabel = {
       let label = UILabel()
        label.text = "가게이미지"
        
        return label
    }()
    
    private lazy var imageButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "plus"), for: .normal)
            button.tintColor = .gray
            button.backgroundColor = .systemGray5 // ✅ 배경색 지정
            button.layer.cornerRadius = 30        // ✅ 아래에서 높이/너비를 60으로 줄 경우
            button.clipsToBounds = true
        
        button.addAction(UIAction { [weak self] _ in
            self?.showPHPicker()
        }, for: .touchUpInside)
        
        return button
    }()
    
    private lazy var submitButton: UIButton = {
        let button = UIButton()
        button.setTitle("확인", for: .normal)
            button.backgroundColor = .systemGray5 // ✅ 배경색 지정
            button.layer.cornerRadius = 12
            button.clipsToBounds = true
        button.isEnabled = false
        button.setTitleColor(.white, for: .normal)        // 활성 상태
        button.setTitleColor(.gray, for: .disabled)
        button.alpha = 0.5
        
        button.addAction(UIAction { [weak self] _ in
            UserDefaults.standard.set(true, forKey: "setupFinished")
            
            DispatchQueue.main.async {
                if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
                   let delegate = scene.delegate as? SceneDelegate {
                    delegate.showMainScreen()
                }
            }
        }, for: .touchUpInside)
        
        return button
    }()
    
    
    private lazy var storeNameStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [storeNameLabel, storeNameTextField])
        stack.axis = .vertical
        stack.spacing = 8
        return stack
    }()

    private lazy var branchNameStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [branchNameLabel, branchNameTextField])
        stack.axis = .vertical
        stack.spacing = 8
        return stack
    }()

    private lazy var addressStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [addressLabel, addressTextField])
        stack.axis = .vertical
        stack.spacing = 8
        return stack
    }()
    
    private lazy var categoryStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [categoryLabel, categoryCollectionView])
        stack.axis = .vertical
        stack.spacing = 8
        return stack
    }()
    
    private lazy var benefitStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [benefitLabel, benefitCollectionView])
        stack.axis = .vertical
        stack.spacing = 8
        return stack
    }()


    private lazy var formStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [storeNameStack, branchNameStack, addressStack, categoryStack, benefitStack])
        stack.axis = .vertical
        stack.spacing = 20
        return stack
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.tintColor = .black
        
        configureUI()
        setupTapGesture()
        
        storeNameTextField.addTarget(self, action: #selector(textFieldsDidChange), for: .editingChanged)
        branchNameTextField.addTarget(self, action: #selector(textFieldsDidChange), for: .editingChanged)
        addressTextField.addTarget(self, action: #selector(textFieldsDidChange), for: .editingChanged)
        
        textFieldsDidChange()
    }
    
    @objc private func textFieldsDidChange() {
        let isStoreNameEmpty = storeNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true
        let isBranchNameEmpty = branchNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true
        let isAddressEmpty = addressTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true

        let allFilled = !isStoreNameEmpty && !isBranchNameEmpty && !isAddressEmpty
        submitButton.isEnabled = allFilled
        submitButton.backgroundColor = allFilled ? .mainColor : .systemGray4
        submitButton.alpha = allFilled ? 1.0 : 0.5
    }
    
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    func configureUI() {
        view.backgroundColor = .systemBackground
        
        view.addSubview(titleLabel)
        view.addSubview(formStack)
        view.addSubview(imageLabel)
        view.addSubview(imageButton)
        view.addSubview(selectedImageView)
        view.addSubview(submitButton)
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.equalToSuperview().offset(16)
        }
        
        formStack.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        imageLabel.snp.makeConstraints {
            $0.top.equalTo(formStack.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(16)
        }
        
        imageButton.snp.makeConstraints {
            $0.top.equalTo(imageLabel.snp.bottom).offset(8)
            $0.leading.equalToSuperview().offset(16)
            $0.width.height.equalTo(60)
        }
        
        selectedImageView.snp.makeConstraints {
            $0.centerY.equalTo(imageButton) // 버튼과 수직 정렬
            $0.leading.equalTo(imageButton.snp.trailing).offset(12) // 버튼 오른쪽 12pt 간격
            $0.trailing.lessThanOrEqualToSuperview().offset(-16)
            $0.height.equalTo(60)
            $0.width.equalTo(100) // 원하는 미리보기 크기로 조절 가능
        }
        
        submitButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview().offset(-20)
            $0.height.equalTo(60)
        }
        [storeNameTextField, branchNameTextField, addressTextField, categoryCollectionView, benefitCollectionView].forEach {
            $0.snp.makeConstraints { $0.height.equalTo(54) }
        }
    }
    
    private func addPost() {
        guard let image = selectedImage,
                  let imageData = image.jpegData(compressionQuality: 0.8) else {
                return
            }
        
        Task {
            do {
                // 이미지 업로드
                let imageUrl = try await FirebaseManager.shared.saveImage(data: imageData)
                
                print(imageUrl)
                // 포스트 생성
//                try await postViewModel.createPost(
//                    token: authViewModel.getToken(),
//                    content: contentTextView.text,
//                    photoURL: imageUrl
//                )
//                
//                // 성공 후 화면 전환
//                DispatchQueue.main.async { [weak self] in
//                    guard let self = self else { return }
//                    self.delegate?.didCreatePost()
//                    self.navigationController?.popViewController(animated: true)
//                    self.delegate?.showToastMessage(NSLocalizedString("postSaved", comment: ""))
//                }
            } catch {
                print("❌ Failed to create post: \(error)")
            }
        }
    }
}

extension StoreInfoInputViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
            return 1
        }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return collectionView.tag == 0 ? categories.count : benefits.count
        }

        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: OptionCell.id, for: indexPath) as? OptionCell else { return UICollectionViewCell() }

            let isCategory = collectionView.tag == 0
            let item = isCategory ? categories[indexPath.item] : benefits[indexPath.item]
            let selected = isCategory ? (indexPath.item == selectedCategoryIndex) : (indexPath.item == selectedBenefitIndex)

            cell.configure(with: item, selected: selected)
            return cell
        }

        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            if collectionView.tag == 0 {
                selectedCategoryIndex = indexPath.item
                collectionView.reloadData()
            } else {
                selectedBenefitIndex = indexPath.item
                collectionView.reloadData()
            }
        }

        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: 90, height: 44)
        }
}

class OptionCell: UICollectionViewCell {
    static let id = "OptionCell"

    private let titleLabel = UILabel()
    private let iconView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 22
        backgroundColor = .systemGray5
        layer.borderWidth = 0

        titleLabel.font = .systemFont(ofSize: 12)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center

        iconView.contentMode = .scaleAspectFit
        iconView.tintColor = .darkGray

        let stack = UIStackView(arrangedSubviews: [iconView, titleLabel])
        stack.axis = .horizontal
        stack.spacing = 2
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(stack)
        stack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12).isActive = true
        stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12).isActive = true
    }

    func configure(with item: CategoryItem, selected: Bool) {
        titleLabel.text = item.title
        iconView.image = item.icon
        iconView.isHidden = item.icon == nil

        backgroundColor = selected ? .mainLightColor : .systemGray5
        layer.borderWidth = selected ? 2 : 0
        layer.borderColor = selected ? UIColor.mainColor?.cgColor : nil
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension StoreInfoInputViewController: PHPickerViewControllerDelegate {
    // MARK: - PHPickerViewControllerDelegate
    func showPHPicker() {
            var config = PHPickerConfiguration(photoLibrary: .shared())
            config.filter = .images
            config.selectionLimit = 1 // ✅ 한 장만 선택 가능
            config.preferredAssetRepresentationMode = .current

            let picker = PHPickerViewController(configuration: config)
            picker.delegate = self
            present(picker, animated: true, completion: nil)
        }

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)

            guard let result = results.first else { return }

            let itemProvider = result.itemProvider

            if itemProvider.canLoadObject(ofClass: UIImage.self) {
                itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                    guard let self = self, let image = image as? UIImage else { return }
                    DispatchQueue.main.async {
                        self.selectedImage = image
                        self.selectedImageView.image = image // ✅ 표시용 UIImageView에 이미지 세팅
                        self.selectedImageView.isHidden = false
                    }
                }
            }
        }
}
