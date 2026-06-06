//
//  StatisticsViewController.swift
//  KoreanPractice
//
//  Created by 김지원 on 6/6/26.
//

import Foundation
import UIKit

class StatisticsViewController: UIViewController {
    
    // 상단 총 연습 횟수 카드 (파란 배경)
    let summaryCard: UIView = {
        let v = UIView()
        v.backgroundColor = .systemBlue
        v.layer.cornerRadius = 20
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    // 소제목
    let summaryTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "이번 주 연습"
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = UIColor.white.withAlphaComponent(0.8)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 총 횟수 숫자
    let summaryCountLabel: UILabel = {
        let label = UILabel()
        label.text = "0회"
        label.font = UIFont.boldSystemFont(ofSize: 48)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 횟수에 따라 바뀌는 응원 메시지
    let summarySubLabel: UILabel = {
        let label = UILabel()
        label.text = "첫 연습을 시작해봐요! 🌱"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.white.withAlphaComponent(0.8)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // "카테고리별 연습" 섹션 타이틀
    let sectionTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "카테고리별 연습"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 카테고리 카드들을 담는 세로 스택뷰
    let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 12
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "나의 학습"
        view.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1)
        setupUI()
    }
    
    // 탭 전환할 때마다 최신 통계 반영
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateStatistics()
    }
    
    func setupUI() {
        summaryCard.addSubview(summaryTitleLabel)
        summaryCard.addSubview(summaryCountLabel)
        summaryCard.addSubview(summarySubLabel)
        view.addSubview(summaryCard)
        view.addSubview(sectionTitleLabel)
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            // 상단 요약 카드
            summaryCard.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            summaryCard.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            summaryCard.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            summaryCard.heightAnchor.constraint(equalToConstant: 150),
            
            // 카드 안 레이블
            summaryTitleLabel.topAnchor.constraint(equalTo: summaryCard.topAnchor, constant: 24),
            summaryTitleLabel.leadingAnchor.constraint(equalTo: summaryCard.leadingAnchor, constant: 24),
            summaryCountLabel.topAnchor.constraint(equalTo: summaryTitleLabel.bottomAnchor, constant: 8),
            summaryCountLabel.leadingAnchor.constraint(equalTo: summaryCard.leadingAnchor, constant: 24),
            summarySubLabel.bottomAnchor.constraint(equalTo: summaryCard.bottomAnchor, constant: -20),
            summarySubLabel.trailingAnchor.constraint(equalTo: summaryCard.trailingAnchor, constant: -24),
            
            // 섹션 타이틀
            sectionTitleLabel.topAnchor.constraint(equalTo: summaryCard.bottomAnchor, constant: 28),
            sectionTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            
            // 카테고리 스택뷰
            stackView.topAnchor.constraint(equalTo: sectionTitleLabel.bottomAnchor, constant: 12),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }
    
    // 통계 업데이트
    func updateStatistics() {
        let categories = ["카페 주문", "병원 진료", "지하철 / 교통", "학교 / 행정"]
        let keys = ["cafe", "hospital", "subway", "school"]
        let colors: [UIColor] = [.systemYellow, .systemGreen, .systemPink, .systemRed]
        let emojis = ["☕️", "🏥", "🚇", "🏫"]
        
        // 총 연습 횟수
        let total = keys.reduce(0) { $0 + UserDefaults.standard.integer(forKey: $1) }
        summaryCountLabel.text = "\(total)회"
        
        // 횟수에 따라 응원 메시지 변경
        switch total {
        case 0: summarySubLabel.text = "첫 연습을 시작해봐요! 🌱"
        case 1...4: summarySubLabel.text = "잘 하고 있어요! 계속해봐요 😊"
        default: summarySubLabel.text = "대단해요! 꾸준히 연습 중이에요 🔥"
        }
        
        // 기존 카드 초기화 후 다시 생성
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        for (i, category) in categories.enumerated() {
            let count = UserDefaults.standard.integer(forKey: keys[i])
            stackView.addArrangedSubview(makeStatCard(emoji: emojis[i], title: category, count: count, color: colors[i]))
        }
    }
    
    // 카테고리 카드
    func makeStatCard(emoji: String, title: String, count: Int, color: UIColor) -> UIView {
        let card = UIView()
        card.backgroundColor = .white
        card.layer.cornerRadius = 16
        card.layer.shadowColor = UIColor.black.cgColor
        card.layer.shadowOpacity = 0.06
        card.layer.shadowOffset = CGSize(width: 0, height: 2)
        card.layer.shadowRadius = 6
        card.translatesAutoresizingMaskIntoConstraints = false
        card.heightAnchor.constraint(equalToConstant: 90).isActive = true
        
        // 왼쪽 색상 포인트 바
        let colorBar = UIView()
        colorBar.backgroundColor = color
        colorBar.layer.cornerRadius = 3
        colorBar.translatesAutoresizingMaskIntoConstraints = false
        
        let emojiLabel = UILabel()
        emojiLabel.text = emoji
        emojiLabel.font = UIFont.systemFont(ofSize: 28)
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 15)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // 프로그레스 바 (최대 10회 기준)
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.progress = min(Float(count) / 10.0, 1.0)
        progressView.progressTintColor = color
        progressView.trackTintColor = .systemGray5
        progressView.translatesAutoresizingMaskIntoConstraints = false
        
        // 오른쪽 횟수 (색상으로 강조)
        let countLabel = UILabel()
        countLabel.text = "\(count)회"
        countLabel.font = UIFont.boldSystemFont(ofSize: 20)
        countLabel.textColor = color
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        
        card.addSubview(colorBar)
        card.addSubview(emojiLabel)
        card.addSubview(titleLabel)
        card.addSubview(progressView)
        card.addSubview(countLabel)
        
        NSLayoutConstraint.activate([
            colorBar.leadingAnchor.constraint(equalTo: card.leadingAnchor, constant: 16),
            colorBar.centerYAnchor.constraint(equalTo: card.centerYAnchor),
            colorBar.widthAnchor.constraint(equalToConstant: 4),
            colorBar.heightAnchor.constraint(equalToConstant: 50),
            
            emojiLabel.leadingAnchor.constraint(equalTo: colorBar.trailingAnchor, constant: 12),
            emojiLabel.centerYAnchor.constraint(equalTo: card.centerYAnchor),
            
            titleLabel.leadingAnchor.constraint(equalTo: emojiLabel.trailingAnchor, constant: 12),
            titleLabel.topAnchor.constraint(equalTo: card.topAnchor, constant: 20),
            
            progressView.leadingAnchor.constraint(equalTo: emojiLabel.trailingAnchor, constant: 12),
            progressView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            progressView.trailingAnchor.constraint(equalTo: countLabel.leadingAnchor, constant: -12),
            
            countLabel.trailingAnchor.constraint(equalTo: card.trailingAnchor, constant: -16),
            countLabel.centerYAnchor.constraint(equalTo: card.centerYAnchor),
        ])
        
        return card
    }
}
