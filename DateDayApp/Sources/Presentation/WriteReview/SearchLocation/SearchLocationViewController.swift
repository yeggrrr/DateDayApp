//
//  SearchLocationViewController.swift
//  DateDayApp
//
//  Created by YJ on 8/24/24.
//

import UIKit

final class SearchLocationViewController: UIViewController {
    // MARK: UI
    let searchLocationView = SearchLocationView()
    
    // MARK: View Life Cycle
    override func loadView() {
        view = searchLocationView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
