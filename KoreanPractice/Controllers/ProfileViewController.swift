//
//  ProfileViewController.swift
//  KoreanPractice
//
//  Created by 김지원 on 6/14/26.
//

import Foundation
import UIKit

class ProfileViewController: UIViewController {
    
    
    // 프로필 이모지 버튼 (탭하면 변경)
    let emojiButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("🙂", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 70)
        btn.backgroundColor = UIColor.systemGray6
        btn.layer.cornerRadius = 60
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    // 이름 입력 필드
    let nameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "이름을 입력하세요"
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    // 국적 선택 레이블
    let nationalityLabel: UILabel = {
        let label = UILabel()
        label.text = "국적"
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 국적 선택 버튼들 스택뷰
    let nationalityStack: UIStackView = {
        let sv = UIStackView()
        sv.axis = .horizontal
        sv.spacing = 10
        sv.distribution = .fillEqually
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    // 선택된 국적
    var selectedNationality = "영어권" {
        didSet { updateNationalityButtons() }
    }
    
    // 국적 목록
    let nationalities = ["🇺🇸 영어권", "🇨🇳 중국", "🇻🇳 베트남", "🇯🇵 일본"]
    var nationalityButtons: [UIButton] = []
    
    // 이모지 목록
    let emojis = ["🙂", "😊", "🧑‍🎓", "👩‍🎓", "🧑", "👩", "🐱", "🐶"]
    var currentEmojiIndex = 0
    
    // 저장 버튼
    let saveButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("저장", for: .normal)
        btn.backgroundColor = .systemBlue
        btn.layer.cornerRadius = 12
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "프로필"
        view.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1)
        setupUI()
        loadProfile()
    }
    
    func setupUI() {
        // 국적 버튼 생성
        for (i, nation) in nationalities.enumerated() {
            let btn = UIButton()
            btn.setTitle(nation, for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            btn.layer.cornerRadius = 8
            btn.layer.borderWidth = 1.5
            btn.layer.borderColor = UIColor.systemGray3.cgColor
            btn.backgroundColor = .white
            btn.setTitleColor(.black, for: .normal)
            btn.tag = i
            btn.addTarget(self, action: #selector(nationalityTapped(_:)), for: .touchUpInside)
            nationalityStack.addArrangedSubview(btn)
            nationalityButtons.append(btn)
        }
        
        emojiButton.addTarget(self, action: #selector(emojiTapped), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(saveTapped), for: .touchUpInside)
        
        // 이름 섹션 레이블
        let nameLabel = UILabel()
        nameLabel.text = "이름"
        nameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(emojiButton)
        view.addSubview(nameLabel)
        view.addSubview(nameTextField)
        view.addSubview(nationalityLabel)
        view.addSubview(nationalityStack)
        view.addSubview(saveButton)
        
        NSLayoutConstraint.activate([
            // 이모지 버튼
            emojiButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            emojiButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emojiButton.widthAnchor.constraint(equalToConstant: 120),
            emojiButton.heightAnchor.constraint(equalToConstant: 120),
            
            // 이름 레이블
            nameLabel.topAnchor.constraint(equalTo: emojiButton.bottomAnchor, constant: 30),
            nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            // 이름 입력 필드
            nameTextField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nameTextField.heightAnchor.constraint(equalToConstant: 44),
            
            // 국적 레이블
            nationalityLabel.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 24),
            nationalityLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            
            // 국적 버튼 스택
            nationalityStack.topAnchor.constraint(equalTo: nationalityLabel.bottomAnchor, constant: 8),
            nationalityStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nationalityStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nationalityStack.heightAnchor.constraint(equalToConstant: 44),
            
            // 저장 버튼
            saveButton.topAnchor.constraint(equalTo: nationalityStack.bottomAnchor, constant: 40),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            saveButton.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        updateNationalityButtons()
    }
    
    
    // 이모지 탭 → 다음 이모지로 변경
    @objc func emojiTapped() {
        currentEmojiIndex = (currentEmojiIndex + 1) % emojis.count
        emojiButton.setTitle(emojis[currentEmojiIndex], for: .normal)
    }
    
    // 국적 버튼 탭
    @objc func nationalityTapped(_ sender: UIButton) {
        let nation = nationalities[sender.tag]
        selectedNationality = nation
    }
    
    // 저장 버튼 탭
    @objc func saveTapped() {
        let name = nameTextField.text ?? ""
        let emoji = emojis[currentEmojiIndex]
        
        // UserDefaults에 저장
        UserDefaults.standard.set(name, forKey: "userName")
        UserDefaults.standard.set(emoji, forKey: "userEmoji")
        UserDefaults.standard.set(selectedNationality, forKey: "userNationality")
        
        // 저장 완료 알림
        let alert = UIAlertController(title: "저장 완료", message: "프로필이 저장됐어요 😊", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
    
    func loadProfile() {
        nameTextField.text = UserDefaults.standard.string(forKey: "userName") ?? ""
        let savedEmoji = UserDefaults.standard.string(forKey: "userEmoji") ?? "🙂"
        emojiButton.setTitle(savedEmoji, for: .normal)
        currentEmojiIndex = emojis.firstIndex(of: savedEmoji) ?? 0
        selectedNationality = UserDefaults.standard.string(forKey: "userNationality") ?? "🇺🇸 영어권"
    }
    
    // 선택된 국적 버튼 강조
    func updateNationalityButtons() {
        for (i, btn) in nationalityButtons.enumerated() {
            if nationalities[i] == selectedNationality {
                btn.backgroundColor = .systemBlue
                btn.setTitleColor(.white, for: .normal)
                btn.layer.borderColor = UIColor.systemBlue.cgColor
            } else {
                btn.backgroundColor = .white
                btn.setTitleColor(.black, for: .normal)
                btn.layer.borderColor = UIColor.systemGray3.cgColor
            }
        }
    }
}
