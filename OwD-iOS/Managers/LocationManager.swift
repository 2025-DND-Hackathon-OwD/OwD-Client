//
//  LocationManager.swift
//  OwD-iOS
//
//  Created by 이인호 on 5/24/25.
//

import Foundation
import CoreLocation
import WebKit

final class LocationManager: NSObject, CLLocationManagerDelegate {
    weak var viewController: UIViewController?
    var webView: WKWebView?
    var locationManager = CLLocationManager()
    var status: CLAuthorizationStatus?

    init(viewController: UIViewController?, webView: WKWebView?) {
        super.init()
        
        self.viewController = viewController
        self.webView = webView
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }

    func presentLocationServicesAlert() {
        let alert = UIAlertController(title: "위치 정보", message: "위치 서비스를 사용할 수 없습니다.\n디바이스의 '설정 > 개인정보 보호'에서 위치 서비스를 켜주세요.", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "설정으로 이동", style: .destructive) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString),
               UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        })
        
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        viewController?.present(alert, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        let timestamp = location.timestamp
        
//        sendToServer()
        
        
//        print(latitude, longitude)
//        
//        let js = """
//        window.dispatchEvent(new CustomEvent('locationReceived', {
//            detail: { lat: \(latitude), lng: \(longitude), timestamp: \(timestamp) }
//        }));
//        """
//        
//        webView?.evaluateJavaScript(js)
    }
    
    func getLocation() {
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        print("Location fail: \(error.localizedDescription)")
    }
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
}
