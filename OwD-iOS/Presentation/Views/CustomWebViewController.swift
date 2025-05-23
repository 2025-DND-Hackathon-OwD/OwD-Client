//
//  CustomWebViewController.swift
//  OwD-iOS
//
//  Created by 이인호 on 5/24/25.
//

import UIKit
import WebKit
import SnapKit

class CustomWebViewController: UIViewController {
    private lazy var locationManager = LocationManager(viewController: self, webView: webView)
    
    private let webContainerView = UIView()
    
    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createWebView()
        configureUI()
        loadWebView()
    }
    
    func createWebView() {
        let contentController = WKUserContentController()
        registerJSHandlers(controller: contentController)
        
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = contentController
        
        let preferences = WKPreferences()
        let webPagePreferences = WKWebpagePreferences()
        preferences.javaScriptCanOpenWindowsAutomatically = true
        
        if #available(iOS 14.0, *) {
            webPagePreferences.allowsContentJavaScript = true
            configuration.defaultWebpagePreferences = webPagePreferences
        } else {
            preferences.javaScriptEnabled = true
            configuration.preferences = preferences
        }
        
        webView = WKWebView(frame: .zero, configuration: configuration)
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(reloadWebView(_:)), for: .valueChanged)
        refreshControl.tintColor = .secondaryLabel
        
        webView.scrollView.refreshControl = refreshControl
        webView.scrollView.alwaysBounceVertical = true
        webView.scrollView.bounces = true
        
        webView.navigationDelegate = self
        webView.uiDelegate = self
    }
    
    func loadWebView() {
        guard let url = getURL() else { return }
        webView.load(URLRequest(url: url))
    }
    
    func configureUI() {
        view.backgroundColor = .systemBackground
        
        webContainerView.addSubview(webView)
        view.addSubview(webContainerView)
        
        webContainerView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        webView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    @objc func reloadWebView(_ sender: UIRefreshControl) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
            self.webView.reload()
            sender.endRefreshing()
        }
    }
    
    // MARK: - Override functions
    func registerJSHandlers(controller: WKUserContentController) {}
    func handleMessage(_ message: WKScriptMessage) {}
    func getURL() -> URL? {
        return nil
    }
}

extension CustomWebViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        handleMessage(message)
    }
}

extension CustomWebViewController: WKNavigationDelegate {
    
}

extension CustomWebViewController: WKUIDelegate {
    public func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo) async {
        
    }
}
