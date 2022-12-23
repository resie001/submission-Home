//
//  Ext+UIView.swift
//  submission-Core
//
//  Created by Ade Resie on 23/12/22.
//

import Foundation

public extension UIView {
    static var identifier: String {
        return NSStringFromClass(self).components(separatedBy: ".").last!
    }
}
