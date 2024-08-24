//
//  ReusableProtocol.swift
//  DateDayApp
//
//  Created by YJ on 8/18/24.
//

import UIKit

protocol ReusableProtocol: AnyObject {
    static var id: String { get }
}

extension UICollectionViewCell: ReusableProtocol {
    static var id: String {
        return String(describing: self)
    }
}

extension UITableViewCell: ReusableProtocol {
    static var id: String {
        return String(describing: self)
    }
}

