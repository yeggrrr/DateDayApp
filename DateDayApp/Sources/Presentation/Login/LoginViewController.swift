//
//  LoginViewController.swift
//  DateDayApp
//
//  Created by YJ on 8/16/24.
//

import UIKit

final class LoginViewController: UIViewController {
    
    // MARK: Properties
    let loginView = LoginView()
    
    // MARK: View Life Cycle
    override func loadView() {
        view = loginView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
