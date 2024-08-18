//
//  FeedViewController.swift
//  DateDayApp
//
//  Created by YJ on 8/17/24.
//

import UIKit

final class FeedViewController: UIViewController {
    // MARK: UI
    let feedView = FeedView()
    
    // MARK: Properties
    
    override func loadView() {
        view = feedView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showToast(message: "로그인 성공! :)")
    }
}
