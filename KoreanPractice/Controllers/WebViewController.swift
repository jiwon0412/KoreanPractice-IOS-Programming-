//
//  WebViewController.swift
//  KoreanPractice
//
//  Created by 김지원 on 6/6/26.
//

import Foundation
import UIKit
import WebKit

class WebViewController: UIViewController {
    
    // 웹 콘텐츠를 표시하는 WKWebView
    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "파파고 번역"
        
        // WKWebView 생성 및 화면 전체에 채우기
        webView = WKWebView(frame: view.bounds)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(webView)
        
        // 파파고 URL 로드
        if let url = URL(string: "https://papago.naver.com") {
            let request = URLRequest(url: url)
            webView.load(request)
        }
    }
}
