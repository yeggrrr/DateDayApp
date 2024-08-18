//
//  FeedView.swift
//  DateDayApp
//
//  Created by YJ on 8/18/24.
//

import UIKit
import SnapKit

final class FeedView: UIView, ViewRepresentable {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews()
        setConstraints()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubviews() {
        print("")
    }
    
    func setConstraints() {
        print("")
    }
    
    func configureUI() {
        backgroundColor = .white
    }
}
