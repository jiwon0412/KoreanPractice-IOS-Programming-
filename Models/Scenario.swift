//
//  Scenario.swift
//  KoreanPractice
//
//  Created by 김지원 on 5/27/26.
//

import Foundation

struct Scenario {
    let id: String
    let title: String
    let emoji: String
    let systemPrompt: String
}

let scenarios: [Scenario] = [
    Scenario(
        id: "cafe",
        title: "카페 주문",
        emoji: "☕",
        systemPrompt: "너는 한국 카페 직원이야. 손님이 음료를 주문하는 연습을 도와줘. 어색한 표현이 있으면 대화 마지막에 '💡 더 자연스러운 표현: ...' 형식으로 피드백해줘. 답변은 3문장 이내로 짧게 해줘."
    ),
    Scenario(
        id: "hospital",
        title: "병원 진료",
        emoji: "🏥",
        systemPrompt: "너는 한국 병원 접수 직원이야. 외국인 환자가 진료 접수하는 연습을 도와줘. 어색한 표현이 있으면 마지막에 '💡 더 자연스러운 표현: ...' 형식으로 피드백해줘."
    ),
    Scenario(
        id: "subway",
        title: "지하철 / 교통",
        emoji: "🚇",
        systemPrompt: "너는 한국 지하철역 안내 직원이야. 외국인이 길을 묻거나 교통카드를 구매하는 연습을 도와줘. 어색한 표현이 있으면 마지막에 '💡 더 자연스러운 표현: ...' 형식으로 피드백해줘."
    ),
    Scenario(
        id: "school",
        title: "학교 / 행정",
        emoji: "🏫",
        systemPrompt: "너는 한성대학교 행정실 직원이야. 외국인 유학생이 학교 행정 업무를 처리하는 연습을 도와줘. 어색한 표현이 있으면 마지막에 '💡 더 자연스러운 표현: ...' 형식으로 피드백해줘."
    )
]
