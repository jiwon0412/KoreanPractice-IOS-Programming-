# 🇰🇷 KoreanPractice (한국어 회화 연습 앱)

외국인 학습자를 위한 실상황 기반 AI 한국어 회화 연습 iOS 애플리케이션입니다.  
다양한 일상 및 행정 시나리오를 바탕으로 AI와 1:1 대화를 나누고, 자연스러운 한국어 표현을 학습할 수 있도록 도와줍니다.

---

## 🌟 주요 기능 (Key Features)

### 1. 상황별 회화 연습 (Scenarios)
실제 한국 생활에서 가장 자주 접하는 4가지 대표적인 시나리오를 제공합니다.
* **☕️ 카페 주문**: 카페 직원과의 대화를 통해 음료 및 디저트를 주문하는 연습을 진행합니다.
* **🏥 병원 진료**: 병원 접수처에서 진료를 접수하고 증상을 설명하는 연습을 진행합니다.
* **🚇 지하철 / 교통**: 길을 묻거나 교통카드를 구매 및 충전하는 연습을 진행합니다.
* **🏫 학교 / 행정**: 한성대학교 행정실 상황을 배경으로 유학생으로서 필요한 행정 업무를 처리하는 연습을 진행합니다.

### 2. 실시간 맞춤 피드백 (AI Feedback)
* 사용자가 입력한 대화 내용 중 어색하거나 문법적으로 틀린 부분이 있으면, AI가 문맥상 더 어울리는 자연스러운 표현을 제안합니다.
* **예시 피드백**:  
  > 💡 더 자연스러운 표현: 아이스 아메리카노 한 잔 주세요.

---

## 🛠 기술 스택 (Tech Stack)

* **Language**: Swift (5.x)
* **Framework**: UIKit
* **Architecture**: MVC (Model-View-Controller)
* **UI Layout**: Storyboard
* **Target OS**: iOS 15.0 이상

---

## 📂 프로젝트 구조 (Project Structure)

```text
KoreanPractice/
├── Controllers/
│   ├── CategoryViewController.swift  # 시나리오 카테고리 목록 화면 (UITableView)
│   └── ChatViewController.swift      # 1:1 AI 채팅 화면 (개발 중)
├── Models/
│   └── Scenario.swift                # 시나리오 데이터 모델 및 데이터셋 정의
├── Views/
│   └── ChatCell.swift                # 채팅 메시지 커스텀 셀 (개발 중)
├── Assets.xcassets/                  # 앱 아이콘 및 시나리오 이미지 리소스
├── Base.lproj/
│   └── Main.storyboard               # 앱의 전체 UI 흐름 및 화면 레이아웃
├── AppDelegate.swift                 # 앱의 생명주기 관리
└── SceneDelegate.swift               # UI의 생명주기 및 윈도우 설정
```

---

## 📈 현재 개발 현황 (Development Status)

* [x] **시나리오 데이터 정의**: 카페, 병원, 지하철, 학교 행정의 프롬프트 및 시나리오 메타데이터 구축 완료 (`Scenario.swift`)
* [x] **카테고리 화면 UI**: 시나리오 목록을 보여주는 테이블 뷰 레이아웃 및 데이터 연동 완료 (`CategoryViewController.swift`)
* [ ] **채팅 화면 UI 및 로직**: `ChatViewController`와 대화 기록을 표시할 `ChatCell` 구현 중
* [ ] **AI API 연동**: LLM API(예: OpenAI, Gemini 등) 연동을 통한 실시간 롤플레이 및 피드백 기능 추가 예정
