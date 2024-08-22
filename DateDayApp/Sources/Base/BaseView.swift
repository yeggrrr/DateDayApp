//
//  BaseView.swift
//  DateDayApp
//
//  Created by YJ on 8/18/24.
//

import UIKit

class BaseView: UIView, ViewRepresentable {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews()
        setConstraints()
        configureUI()
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func addSubviews() { }
    
    func setConstraints() { }
    
    func configureUI() {
        backgroundColor = .white
    }
}
