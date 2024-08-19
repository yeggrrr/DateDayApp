//
//  WriteViewController.swift
//  DateDayApp
//
//  Created by YJ on 8/19/24.
//

import UIKit

final class WriteViewController: UIViewController {
    // MARK: UI
    let writeView = WriteView()
    
    // MARK: View Life Cycle
    override func loadView() {
        view = writeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
