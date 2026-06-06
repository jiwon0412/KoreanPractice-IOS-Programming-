//
//  StatisticsViewController.swift
//  KoreanPractice
//
//  Created by 김지원 on 6/6/26.
//

import Foundation
import UIKit

class StatisticsViewController: UIViewController {
    
    // 이번 주 연습 횟수 표시 레이블
    let weeklyCountLabel: UILabel = {
        let label = UILabel()
        label.text = "이번 주 연습 : 0회"
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // 카테고리별 통계 스택뷰
    let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 16
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "나의 학습"
        view.backgroundColor = .systemBackground
        setupUI()
    }
    
    // 화면 나타날 때마다 통계 갱신
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateStatistics()
    }
    
    func setupUI() {
        view.addSubview(weeklyCountLabel)
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            weeklyCountLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            weeklyCountLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            weeklyCountLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            stackView.topAnchor.constraint(equalTo: weeklyCountLabel.bottomAnchor, constant: 30),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
        ])
    }
    
    func updateStatistics() {
        // UserDefaults에서 각 카테고리 연습 횟수 불러오기
        let categories = ["카페 주문", "병원 진료", "지하철 / 교통", "학교 / 행정"]
        let keys = ["cafe", "hospital", "subway", "school"]
        let colors: [UIColor] = [.systemYellow, .systemGreen, .systemPink, .systemRed]
        
        // 총 횟수 계산
        let total = keys.reduce(0) { $0 + UserDefaults.standard.integer(forKey: $1) }

        weeklyCountLabel.text = "이번 주 연습 : \(total)회"
        
        // 기존 스택뷰 초기화
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // 카테고리별 행 추가
        for (i, category) in categories.enumerated() {
            let count = UserDefaults.standard.integer(forKey: keys[i])
            let row = makeStatRow(title: category, count: count, color: colors[i])
            stackView.addArrangedSubview(row)
        }
    }
    
    // 카테고리별 통계 행 만들기
    func makeStatRow(title: String, count: Int, color: UIColor) -> UIView {
        let container = UIView()
        
        // 카테고리 이름
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // 횟수
        let countLabel = UILabel()
        countLabel.text = "\(count)회"
        countLabel.font = UIFont.systemFont(ofSize: 15)
        countLabel.textAlignment = .right
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        
        // 프로그레스 바
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.progress = count == 0 ? 0 : Float(count) / 10.0
        progressView.progressTintColor = color
        progressView.translatesAutoresizingMaskIntoConstraints = false
        
        container.addSubview(titleLabel)
        container.addSubview(countLabel)
        container.addSubview(progressView)
        container.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: container.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            
            countLabel.topAnchor.constraint(equalTo: container.topAnchor),
            countLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            
            progressView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            progressView.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            progressView.bottomAnchor.constraint(equalTo: container.bottomAnchor),
        ])
        
        return container
    }
}
