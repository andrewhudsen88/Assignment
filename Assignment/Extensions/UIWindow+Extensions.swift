//
//  UIWindow+Extensions.swift
//  Assignment
//
//  Created by Andrew Hudsun on 08/07/24.
//

import Foundation
import UIKit

extension UIWindow {
    static var keyWindow: UIWindow? {
        if #available(iOS 13, *) {
            return UIApplication.shared.windows.first
        } else {
            return UIApplication.shared.keyWindow
        }
    }
}
