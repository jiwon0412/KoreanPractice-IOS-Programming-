//
//  ViewController.swift
//  KoreanPractice
//
//  Created by 김지원 on 5/27/26.
//

import UIKit

class CategoryViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "한국어 연습"
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // 셀 사이 구분선 제거
        tableView.separatorStyle = .none
        
        // 테이블뷰 배경 연한 회색
        tableView.backgroundColor = UIColor(red: 0.97, green: 0.97, blue: 0.97, alpha: 1)
    }
    
    // CategoryViewController → ChatViewController 로 넘어갈 때 데이터 전달
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "GoToChat" {
            let chatVC = segue.destination as! ChatViewController
            // sender로 전달받은 Scenario 객체를 ChatViewController에 주입
            let scenario = sender as! Scenario
            chatVC.scenario = scenario
        }
    }
}

extension CategoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    // 카테고리 개수 반환
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scenarios.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 기본 셀 대신 매번 새로 만드는 카드 스타일 셀
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "card")
        let scenario = scenarios[indexPath.row]
        
        // 셀 탭 시 회색 선택 효과 제거
        cell.selectionStyle = .none
        // 셀 자체 배경은 투명
        cell.backgroundColor = .clear
        
        // 카드 뷰 (흰색 둥근 박스)
        let cardView = UIView()
        cardView.backgroundColor = .white
        cardView.layer.cornerRadius = 16          // 모서리 둥글게
        cardView.layer.shadowColor = UIColor.black.cgColor  // 그림자 색
        cardView.layer.shadowOpacity = 0.08       // 그림자 투명도 (0~1)
        cardView.layer.shadowOffset = CGSize(width: 0, height: 2)  // 그림자 방향 (아래)
        cardView.layer.shadowRadius = 8           // 그림자 퍼짐 정도
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cell.contentView.addSubview(cardView)
        
        // 카테고리 이미지 (Assets에 저장된 이미지)
        let imageView = UIImageView()
        imageView.image = UIImage(named: scenario.id)  // id가 이미지 파일명과 동일
        imageView.contentMode = .scaleAspectFill   // 비율 유지하며 꽉 채우기
        imageView.clipsToBounds = true             // 둥근 모서리 밖으로 이미지 안 나오게
        imageView.layer.cornerRadius = 12
        imageView.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(imageView)
        
        // 카테고리 제목 레이블
        let titleLabel = UILabel()
        titleLabel.text = scenario.title
        titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(titleLabel)
        
        // 부제목 레이블 (연습 유도 문구)
        let subtitleLabel = UILabel()
        subtitleLabel.text = "탭해서 연습 시작하기 →"
        subtitleLabel.font = UIFont.systemFont(ofSize: 13)
        subtitleLabel.textColor = .systemGray
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        cardView.addSubview(subtitleLabel)
        
        // 오토레이아웃 제약 설정
        NSLayoutConstraint.activate([
            // 카드뷰: 셀 안에서 상하 8pt, 좌우 16pt 여백
            cardView.topAnchor.constraint(equalTo: cell.contentView.topAnchor, constant: 8),
            cardView.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor, constant: -8),
            cardView.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16),
            
            // 이미지: 카드 왼쪽에 붙이고 세로 중앙 정렬, 70x70pt
            imageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            imageView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: 100),
            imageView.heightAnchor.constraint(equalToConstant: 100),
            
            // 제목: 이미지 오른쪽에서 16pt 떨어져, 카드 위에서 24pt
            titleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16),
            titleLabel.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            
            // 부제목: 제목 아래 6pt
            subtitleLabel.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 16),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
        ])
        
        return cell
    }
    
    // 셀 높이: 이미지(70) + 상하 여백 = 110pt
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 160
    }
    
    // 셀 탭 시 해당 시나리오로 ChatViewController 이동
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let scenario = scenarios[indexPath.row]
        // sender에 scenario 전달 → prepare()에서 받아서 ChatViewController에 주입
        performSegue(withIdentifier: "GoToChat", sender: scenario)
        print("선택: \(scenario.title)")
    }
}
