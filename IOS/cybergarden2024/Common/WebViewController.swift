//
//  WebViewController.swift
//  cybergarden2024
//
//  Created by Сергей Бекезин on 23.11.2024.
//

import UIKit
import WebKit
import TinyConstraints

class WebViewController: UIViewController {
    
    private var webView: WKWebView!
    private var url: URL
    
    init(url: URL) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupWebView()
        loadWebView()
    }
    
    private func setupNavigationBar() {
        let barButton = UIBarButtonItem.init(barButtonSystemItem: .close, target: self, action: #selector(backButtonTapped))
        navigationItem.rightBarButtonItem = barButton
        navigationItem.leftBarButtonItem?.tintColor = .black
        
        applyTransparentAppearance()
    }
    
    private func setupWebView() {
        webView = WKWebView(frame: .zero)
        view.addSubview(webView)
        webView.edgesToSuperview()
    }
    
    private func loadWebView() {
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    @objc private func backButtonTapped() {
        dismiss(animated: true)
    }
}
