//
//  DetailWebViewController.swift
//  DateDayApp
//
//  Created by YJ on 8/27/24.
//

import UIKit
import SnapKit
import WebKit

final class DetailWebViewController: UIViewController {
    // MARK: UI
    private let webView = WKWebView()
    
    // MARK: Properties
    var detailLink: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    func configureUI() {
        view.addSubview(webView)
        
        webView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        guard let detailLink = detailLink else { return }
        guard let detailURL = URL(string: detailLink) else { return }
        let request = URLRequest(url: detailURL)
        webView.load(request)
    }
}
