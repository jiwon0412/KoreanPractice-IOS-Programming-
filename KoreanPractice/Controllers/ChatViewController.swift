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
    
    // Claude API에 보낼 대화 기록 (역할, 내용)
        var conversationHistory: [[String: String]] = []
    
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
        tableView.reloadData()
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
        
        // Claude API 호출
        sendToClaudeAPI(userMessage: text)
    }
    
    // API 호출
    func sendToClaudeAPI(userMessage: String) {
        
        conversationHistory.append([
            "role": "user",
            "content": userMessage
        ])
        
        let systemPrompt = scenario.systemPrompt
        
        let requestBody: [String: Any] = [
            "model": "claude-sonnet-4-5",
            "max_tokens": 500,
            "system": systemPrompt,
            "messages": conversationHistory
        ]
        
        guard let url = URL(string: "https://api.anthropic.com/v1/messages") else {
            print("❌ URL 오류")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(Config.anthropicAPIKey, forHTTPHeaderField: "x-api-key")
        request.setValue("2023-06-01", forHTTPHeaderField: "anthropic-version")
        request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody)
        
        print("🚀 API 호출 시작")
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            
            if let error = error {
                print("❌ 에러: \(error.localizedDescription)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("📡 상태코드: \(httpResponse.statusCode)")
            }
            
            if let data = data {
                let raw = String(data: data, encoding: .utf8) ?? "없음"
                print("📦 응답: \(raw)")
            }
            
            guard let self = self,
                  let data = data,
                  error == nil else { return }
            
            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let content = json["content"] as? [[String: Any]],
               let firstContent = content.first,
               let aiText = firstContent["text"] as? String {
                
                self.conversationHistory.append([
                    "role": "assistant",
                    "content": aiText
                ])
                
                DispatchQueue.main.async {
                    self.messages.append((text: aiText, isUser: false))
                    self.tableView.reloadData()
                    self.scrollToBottom()
                }
            }
        }.resume()
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
