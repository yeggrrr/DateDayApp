//
//  DetailViewController.swift
//  DateDayApp
//
//  Created by YJ on 8/26/24.
//

import UIKit

final class DetailViewController: UIViewController {
    // MARK: UI
    let detailView = DetailView()
    
    override func loadView() {
        view = detailView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    private func configure() {
        // navigation
        navigationItem.title = "상세페이지"
    }
}
