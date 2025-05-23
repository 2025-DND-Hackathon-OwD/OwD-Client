//
//  HomeWebViewController.swift
//  OwD-iOS
//
//  Created by 이인호 on 5/24/25.
//

import UIKit
import WebKit
import SwiftQRCodeScanner

class HomeWebViewController: CustomWebViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func getURL() -> URL? {
        return URL(string: "https://8a5dd12a1ef8.ngrok.app/")
    }
    
    override func registerJSHandlers(controller: WKUserContentController) {
        controller.add(self, name: "goToQRAuth")
    }
    
    override func handleMessage(_ message: WKScriptMessage) {
        print(message.name, type(of: message.body))
        scanQRCode()
    }
    
    func scanQRCode() {
        let scanner = QRCodeScannerController()
        scanner.delegate = self
        self.present(scanner, animated: true, completion: nil)
    }
    
    func presentLocationServicesAlert() {
        let alert = UIAlertController(title: "인증이 완료되었어요!", message: nil, preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "확인", style: .default) { _ in
            let js = "window.QRSuccess('success');"
            self.webView?.evaluateJavaScript(js)
        }
        
        confirmAction.setValue(UIColor.mainColor, forKey: "titleTextColor")
        
        alert.addAction(confirmAction)
        present(alert, animated: true)
    }
}


extension HomeWebViewController: QRScannerCodeDelegate {
    func qrScanner(_ controller: UIViewController, didScanQRCodeWithResult result: String) {
        print("result:\(result)")
        
        controller.dismiss(animated: true) {
            DispatchQueue.main.async {
                self.presentLocationServicesAlert()
            }
        }
    }
    
    func qrScanner(_ controller: UIViewController, didFailWithError error: SwiftQRCodeScanner.QRCodeError) {
        print("error:\(error.localizedDescription)")
        
        let js = "window.QRSuccess('fail');"
        self.webView?.evaluateJavaScript(js)
    }
    
    func qrScannerDidCancel(_ controller: UIViewController) {
        print("SwiftQRScanner did cancel")
    }
}
