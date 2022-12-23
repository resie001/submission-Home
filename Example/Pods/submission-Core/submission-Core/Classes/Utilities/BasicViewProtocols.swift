//
//  BasicViewProtocols.swift
//  submission-Core
//
//  Created by Ade Resie on 24/12/22.
//

import Foundation
import UIKit

public protocol BasicViewProtocols: AnyObject {
    var nav: UINavigationController? {get}
    func alert(title: String, message: String)
    func alert(title: String, message: String, completion: (() -> Void)?)
}
