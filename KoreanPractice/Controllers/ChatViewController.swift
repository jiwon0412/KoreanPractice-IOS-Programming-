//
//  ChatViewController.swift
//  KoreanPractice
//
//  Created by 김지원 on 5/27/26.
//

import Foundation
import UIKit

class ChatViewController: UIViewController {
    
    // 말풍선 목록
    @IBOutlet weak var tableView: UITableView!
    // 사용자가 메시지 입력하는 텍스트필드
    @IBOutlet weak var messageTextField: UITextField!
    
    // CategoryViewConntroller에서 전달받은 시나리오
    var scenario: Scenario!
    
    // 채팅 메시지 (텍스트, 사용자 여부)
    // isUser: true -> 사용자 말풍선 (오른쪽)
    // isUser: false -> AI 말풍선 (왼쪽)
    var messages: [(text: String, isUser: Bool)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = scenario.title
        
        // 테이블뷰를 ViewController 담당
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        
        // AI 첫 메시지
        let greeting = "안녕하세요! \(scenario.title) 상황을 연습해봐요 !!"
        messages.append((text: greeting, isUser: false))
    }
    
    // 전송 버튼 눌렀을 때 호출
    @IBAction func sendButtonTapped(_ sender: UIButton) {
        // 텍스트필드 비어있으면 아무것도 안 함
        guard let text = messageTextField.text, !text.isEmpty else { return }
        
        // 사용자 메시지 배열에 추가
        messages.append((text: text, isUser: true))
        
        // 전송 후 텍스트필드 비우기
        messageTextField.text = ""
        
        tableView.reloadData()
        scrollToBottom()
    }
    
    // 테이블뷰 맨 아래로 스크롤
    func scrollToBottom() {
        let lastRow = messages.count - 1
        let indexPath = IndexPath(row: lastRow, section: 0)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    // 표시할 메시지 개수 반환
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    // 각 행에 표시할 셀 구성
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath)
        let message = messages[indexPath.row]
        
        // 메시지 텍스트 설정
        cell.textLabel?.text = message.text
        
        // 긴 메시지도 줄바꿈되도록 여러 줄 허용
        cell.textLabel?.numberOfLines = 0
        
        // 사용자 메시지는 오른쪽, AI 메시지는 왼쪽 정렬
        cell.textLabel?.textAlignment = message.isUser ? .right : .left
        
        return cell
    }
}
