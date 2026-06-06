//
//  ChatCell.swift
//  KoreanPractice
//
//  Created by 김지원 on 5/27/26.
//

import Foundation
import UIKit

class ChatCell: UITableViewCell {
    
    // 말풍선 배경 뷰 (파란색 or 회색 둥근 박스)
    let bubbleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 16  // 모서리 둥글게
        view.translatesAutoresizingMaskIntoConstraints = false  // 오토레이아웃 수동 설정
        return view
    }()
    
    // 말풍선 안에 들어갈 메시지 텍스트
    let messageLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0  // 줄 수 제한 없음 (긴 메시지 대응)
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    
    // 말풍선 왼쪽 고정 제약 (AI 메시지용)
    var bubbleLeading: NSLayoutConstraint?
    // 말풍선 오른쪽 고정 제약 (사용자 메시지용)
    var bubbleTrailing: NSLayoutConstraint?

    
    // Storyboard에서 셀 로드될 때 호출
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    // 코드로 셀 생성할 때 호출
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    // Storyboard 디코딩용
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        // awakeFromNib()에서 setupUI() 호출되므로 여기선 생략
    }

    
    func setupUI() {
        selectionStyle = .none   // 셀 탭해도 선택 효과 없애기
        backgroundColor = .clear // 셀 배경 투명
        
        // bubbleView를 셀에 추가, messageLabel을 bubbleView 안에 추가
        contentView.addSubview(bubbleView)
        bubbleView.addSubview(messageLabel)
        
        // messageLabel이 bubbleView 안쪽 여백 10/14pt 유지
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(equalTo: bubbleView.topAnchor, constant: 10),
            messageLabel.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor, constant: -10),
            messageLabel.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor, constant: 14),
            messageLabel.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor, constant: -14),
        ])
        
        // leading: 왼쪽 정렬 (AI), trailing: 오른쪽 정렬 (사용자)
        // configure()에서 둘 중 하나만 활성화
        bubbleLeading = bubbleView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16)
        bubbleTrailing = bubbleView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        
        // 말풍선 상하 여백 6pt, 최대 너비는 화면의 75%
        NSLayoutConstraint.activate([
            bubbleView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            bubbleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            bubbleView.widthAnchor.constraint(lessThanOrEqualTo: contentView.widthAnchor, multiplier: 0.75),
        ])
    }

    
    // 메시지 내용과 발신자에 따라 말풍선 스타일 설정
    func configure(text: String, isUser: Bool) {
        messageLabel.text = text
        
        if isUser {
            // 사용자 메시지: 오른쪽 정렬, 파란 배경, 흰 글씨
            bubbleView.backgroundColor = UIColor.systemBlue
            messageLabel.textColor = .white
            bubbleLeading?.isActive = false
            bubbleTrailing?.isActive = true
        } else {
            // AI 메시지: 왼쪽 정렬, 회색 배경, 검은 글씨
            bubbleView.backgroundColor = UIColor.systemGray5
            messageLabel.textColor = .black
            bubbleTrailing?.isActive = false
            bubbleLeading?.isActive = true
        }
    }
}
