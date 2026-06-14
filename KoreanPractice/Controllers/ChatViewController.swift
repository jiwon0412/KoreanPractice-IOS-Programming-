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
    
    // 힌트 표시 여부
    var isHintVisible = false
    
    // 힌트 뷰 (말풍선 형태)
    let hintView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.systemYellow.withAlphaComponent(0.15)
        v.layer.cornerRadius = 12
        v.layer.borderWidth = 1
        v.layer.borderColor = UIColor.systemYellow.cgColor
        v.isHidden = true
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    // 힌트 텍스트 레이블
    let hintLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .systemOrange
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = scenario.title
        
        // 테이블뷰를 ViewController 담당
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        
        // AI 첫 메시지
        let name = UserDefaults.standard.string(forKey: "userName") ?? ""
        let greeting = name.isEmpty
            ? "안녕하세요! \(scenario.title) 상황을 연습해봐요 😊"
            : "\(name)님, 안녕하세요! \(scenario.title) 상황을 연습해봐요 😊"
        messages.append((text: greeting, isUser: false))
        
        // 힌트 뷰 세팅
        setupHintView()
    }
    
    @IBAction func hintButtonTapped(_ sender: UIButton) {
        isHintVisible.toggle()
        
        if isHintVisible {
            // 시나리오별 힌트 표현
            let hints: [String: String] = [
                "cafe": "💡 이런 표현 써봐요!\n• 아이스 아메리카노 한 잔 주세요\n• 따뜻한 라떼 주세요\n• 테이크아웃으로 해주세요",
                "hospital": "💡 이런 표현 써봐요!\n• 배가 아파서 왔어요\n• 진료 예약을 하고 싶어요\n• 처방전 주세요",
                "subway": "💡 이런 표현 써봐요!\n• 강남역 어떻게 가요?\n• 환승하려면 어디서 내려요?\n• 교통카드 어디서 사요?",
                "school": "💡 이런 표현 써봐요!\n• 수강 신청은 어떻게 해요?\n• 휴학 신청서 주세요\n• 장학금 신청 기간이 언제예요?",
            ]
            hintLabel.text = hints[scenario.id] ?? "💡 자유롭게 대화해봐요!"
            sender.setTitle("힌트 숨기기 ∧", for: .normal)
        } else {
            sender.setTitle("💡 힌트 보기 ∨", for: .normal)
        }
        
        UIView.animate(withDuration: 0.3) {
            self.hintView.isHidden = !self.isHintVisible
        }
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
                    
                    // 연습 횟수 저장
                    let key = self.scenario.id
                    let current = UserDefaults.standard.integer(forKey: key)
                    UserDefaults.standard.set(current + 1, forKey: key)
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
    
    func setupHintView() {
        hintView.addSubview(hintLabel)
        view.addSubview(hintView)
        
        NSLayoutConstraint.activate([
            // 힌트뷰: 텍스트필드 바로 위
            hintView.bottomAnchor.constraint(equalTo: messageTextField.topAnchor, constant: -8),
            hintView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            hintView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            hintLabel.topAnchor.constraint(equalTo: hintView.topAnchor, constant: 12),
            hintLabel.bottomAnchor.constraint(equalTo: hintView.bottomAnchor, constant: -12),
            hintLabel.leadingAnchor.constraint(equalTo: hintView.leadingAnchor, constant: 12),
            hintLabel.trailingAnchor.constraint(equalTo: hintView.trailingAnchor, constant: -12),
        ])
    }
    
}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    // 표시할 메시지 개수 반환
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    // 각 행에 표시할 셀 구성
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as! ChatCell
        let message = messages[indexPath.row]
        cell.configure(text: message.text, isUser: message.isUser)
        return cell
    }
}
