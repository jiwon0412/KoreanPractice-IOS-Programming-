## 🎬 시연 영상
https://youtu.be/TAgxtGsFwXM

# 🇰🇷 하루 한국어 (한국어 회화 연습 앱)
> 외국인 학습자를 위한 실상황 기반 AI 한국어 회화 연습 iOS 애플리케이션
다양한 일상 및 행정 시나리오를 바탕으로 AI와 1:1 대화를 나누고, 자연스러운 한국어 표현을 학습할 수 있도록 도와줌

---

## 🎯 문제 정의

- 기존 한국어 학습 앱은 단어·문법 위주 학습만 제공
- 실제 대화 상황을 연습할 수 있는 환경 부재
- **"앱을 읽는 것"** 과 **"실제로 말하는 것"** 의 간극 존재

---

## 💡 해결 전략

Claude AI를 대화 파트너로 활용하여 실제 상황과 유사한 롤플레이 환경 제공  
어색한 표현은 AI가 즉시 교정해주고, 학습 통계로 진행 상황 확인 가능

---

## 🌟 주요 기능 
### 1. 상황별 AI 회화 연습 
Claude API 기반 실전 한국어 대화 
실제 한국 생활에서 가장 자주 접하는 4가지 대표적인 시나리오를 제공
* **☕️ 카페 주문**: 카페 직원과의 대화를 통해 음료 및 디저트를 주문하는 연습을 진행
* **🏥 병원 진료**: 병원 접수처에서 진료를 접수하고 증상을 설명하는 연습을 진행
* **🚇 지하철 / 교통**: 길을 묻거나 교통카드를 구매 및 충전하는 연습을 진행
* **🏫 학교 / 행정**: 행정실 상황을 배경으로 유학생으로서 필요한 행정 업무를 처리하는 연습을 진행
  
### 2. 실시간 맞춤 피드백 
* 사용자가 입력한 대화 내용 중 어색하거나 문법적으로 틀린 부분이 있으면, AI가 문맥상 더 어울리는 자연스러운 표현을 제안
* **예시 피드백**:  
  > 💡 더 자연스러운 표현: 아이스 아메리카노 한 잔 주세요.

### 3. 학습 통계
* 카테고리별 연습 횟수 및 진행률

### 4. 파파고 번역
*  WKWebView로 파파고 연결

### 5. 주변 장소 지도
*  MapKit으로 주변 카페/병원/지하철 표시

### 6. 힌트 버튼
* 상황별 유용한 표현 제공

### 7. 오늘의 표현
* 랜덤 한국어 표현 카드
---

## 🛠 기술 스택 
* **Language**: Swift (5.x)
* **Framework**: UIKit
* **Architecture**: MVC (Model-View-Controller)
* **UI Layout**: Storyboard
* **Target OS**: iOS 16.0 이상
---
## 📂 프로젝트 구조 (Project Structure)
```text
KoreanPractice/
├── Controllers/
│   ├── CategoryViewController.swift   # 카테고리 목록 화면
│   ├── ChatViewController.swift       # AI 채팅 화면
│   ├── StatisticsViewController.swift # 학습 통계 화면
│   ├── WebViewController.swift        # 파파고 번역 화면
│   └── MapViewController.swift        # 주변 장소 지도 화면
├── Models/
│   └── Scenario.swift                 # 시나리오 데이터
├── Views/
│   └── ChatCell.swift                 # 말풍선 셀
└── Config.swift                       # API 키 설정
```
---

## 📝 코드 설명

### CategoryViewController.swift
시나리오 카테고리 목록을 보여주는 메인 화면
- `UITableView` 기반 카드 스타일 셀 구현
- 각 셀에 시나리오 이미지, 제목, 부제목 표시
- 셀 탭 시 `performSegue`로 ChatViewController에 시나리오 데이터 전달
- `tableHeaderView`로 오늘의 추천 표현 카드 표시

### ChatViewController.swift
Claude AI와 1:1 대화를 나누는 채팅 화면
- `URLSession`으로 Anthropic Claude API 호출 (`claude-sonnet-4-5` 모델)
- `conversationHistory` 배열로 대화 맥락 유지
- 시나리오별 `systemPrompt`로 AI 역할 설정 
- `UserDefaults`로 시나리오별 연습 횟수 저장
- 힌트 버튼으로 상황별 유용한 표현 제공

### ChatCell.swift
채팅 말풍선 커스텀 셀
- 사용자 메시지: 오른쪽 정렬, 파란 배경
- AI 메시지: 왼쪽 정렬, 회색 배경
- `NSLayoutConstraint`로 말풍선 좌우 위치 동적 전환
- `awakeFromNib` + `setupUI()`로 Storyboard/코드 양쪽 초기화 대응

### StatisticsViewController.swift
학습 통계를 보여주는 화면
- `UserDefaults`에서 카테고리별 연습 횟수 불러오기
- 총 연습 횟수에 따라 응원 메시지 동적 변경
- `UIProgressView`로 카테고리별 진행률 시각화 (최대 10회 기준)
- `viewWillAppear`에서 매번 통계 갱신
- 랜덤 한국어 표현 카드 표시

### MapViewController.swift
현재 위치 기반 주변 장소를 지도에 표시하는 화면
- `CoreLocation`으로 현재 위치 권한 요청 및 좌표 획득
- `MKLocalSearch`로 주변 카페/병원/지하철역/학교 실시간 검색
- `MKMarkerAnnotationView`로 카테고리별 색상/이모지 핀 표시
- 핀 말풍선의 버튼 탭 시 해당 시나리오 채팅으로 바로 연결

### WebViewController.swift
파파고 번역 웹페이지를 보여주는 화면
- `WKWebView`로 `papago.naver.com` 로드

### Scenario.swift
시나리오 데이터 모델
- `id`, `title`, `imageName`, `systemPrompt` 프로퍼티 정의
- 카페/병원/지하철/학교 4개 시나리오 데이터 정의
- 각 시나리오별 Claude AI 역할 및 피드백 규칙 포함
 
## 👩‍💻 개발자
- 이름 : 김지원
- 학번 : 2371153
- 수업 : Ios 프로그래밍
