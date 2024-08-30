//
//  EditProfileViewController.swift
//  DateDayApp
//
//  Created by YJ on 8/30/24.
//

import UIKit
import RxSwift
import RxCocoa

final class EditProfileViewController: UIViewController {
    
    let editProfileView = EditProfileView()
    
    override func loadView() {
        view = editProfileView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}
