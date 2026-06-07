//
//  MapViewController.swift
//  KoreanPractice
//
//  Created by 김지원 on 6/7/26.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController {
    
    // MARK: - UI 요소
    let mapView: MKMapView = {
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        map.showsUserLocation = true  // 내 위치 파란 점 표시
        return map
    }()
    
    // 위치 권한 및 현재 위치 담당
    let locationManager = CLLocationManager()
    
    // 현재 위치 기준으로 검색할 키워드와 시나리오 매핑
    let searchQueries: [(keyword: String, scenarioId: String)] = [
        ("카페", "cafe"),
        ("병원", "hospital"),
        ("지하철역", "subway"),
        ("대학교 행정", "school"),
    ]
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "주변 장소"
        setupUI()
        setupLocation()
    }
    
    // MARK: - UI 세팅
    func setupUI() {
        view.addSubview(mapView)
        mapView.delegate = self
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    // MARK: - 위치 설정
    func setupLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // 위치 권한 요청
        locationManager.requestWhenInUseAuthorization()
    }
    
    // MARK: - 현재 위치 기준으로 주변 장소 검색
    func searchNearbyPlaces(center: CLLocationCoordinate2D) {
        // 기존 핀 제거
        mapView.removeAnnotations(mapView.annotations.filter { !($0 is MKUserLocation) })
        
        // 검색 반경 1km
        let region = MKCoordinateRegion(
            center: center,
            latitudinalMeters: 1000,
            longitudinalMeters: 1000
        )
        
        // 각 키워드로 주변 장소 검색
        for query in searchQueries {
            let request = MKLocalSearch.Request()
            request.naturalLanguageQuery = query.keyword
            request.region = region
            
            MKLocalSearch(request: request).start { [weak self] response, error in
                guard let self = self,
                      let response = response else { return }
                
                // 검색 결과 최대 3개만 핀으로 추가
                for item in response.mapItems.prefix(3) {
                    let annotation = PlaceAnnotation(
                        title: item.name ?? query.keyword,
                        coordinate: item.placemark.coordinate,
                        scenarioId: query.scenarioId
                    )
                    DispatchQueue.main.async {
                        self.mapView.addAnnotation(annotation)
                    }
                }
            }
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension MapViewController: CLLocationManagerDelegate {
    
    // 위치 권한 상태 변경될 때
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            // 권한 허용 → 위치 추적 시작
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            // 권한 거부 → 서울 기본 위치로 표시
            let seoul = CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780)
            mapView.setRegion(MKCoordinateRegion(center: seoul, latitudinalMeters: 1000, longitudinalMeters: 1000), animated: false)
        default:
            break
        }
    }
    
    // 위치 업데이트될 때
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        // 첫 위치 받으면 지도 이동 후 검색
        let coordinate = location.coordinate
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        mapView.setRegion(region, animated: true)
        
        // 위치 한 번만 받고 멈추기 (배터리 절약)
        locationManager.stopUpdatingLocation()
        
        // 주변 장소 검색
        searchNearbyPlaces(center: coordinate)
    }
}

// MARK: - 커스텀 Annotation
class PlaceAnnotation: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var scenarioId: String
    
    init(title: String, coordinate: CLLocationCoordinate2D, scenarioId: String) {
        self.title = title
        self.coordinate = coordinate
        self.scenarioId = scenarioId
    }
}

// MARK: - MKMapViewDelegate
extension MapViewController: MKMapViewDelegate {
    
    // 카테고리별 핀 색상 및 이모지 설정
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? PlaceAnnotation else { return nil }
        
        let identifier = "PlacePin"
        var view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKMarkerAnnotationView
        
        if view == nil {
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view?.canShowCallout = true
            // 말풍선에 "연습하기" 버튼 추가
            view?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            view?.annotation = annotation
        }
        
        // 카테고리별 색상과 이모지
        switch annotation.scenarioId {
        case "cafe":
            view?.markerTintColor = .systemYellow
            view?.glyphText = "☕️"
        case "hospital":
            view?.markerTintColor = .systemRed
            view?.glyphText = "🏥"
        case "subway":
            view?.markerTintColor = .systemBlue
            view?.glyphText = "🚇"
        case "school":
            view?.markerTintColor = .systemGreen
            view?.glyphText = "🏫"
        default: break
        }
        
        return view
    }
    
    // 핀 말풍선의 "연습하기" 버튼 탭했을 때 ChatViewController로 이동
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let annotation = view.annotation as? PlaceAnnotation,
              let scenario = scenarios.first(where: { $0.id == annotation.scenarioId }) else { return }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let chatVC = storyboard.instantiateViewController(withIdentifier: "ChatVC") as! ChatViewController
        chatVC.scenario = scenario
        navigationController?.pushViewController(chatVC, animated: true)
    }
}
