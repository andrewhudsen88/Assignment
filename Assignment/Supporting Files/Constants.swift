//
//  Constants.swift
//  Assignment
//
//  Created by Andrew Hudsun on 07/07/24.
//

import Foundation
import UIKit

enum URLs:String{
    case string = "https://picsum.photos/v2/list/?page=%d&limit=20"
    
}

struct Constants {
    static let alert = "Alert"
    static let dialog = "Dialog"
    static let description = "Description"
    static let alertMessage = "CheckBox Unselected"
    static let networkError = "No Internet connections."
    static let error = "Error"
}

class CommonFunctions:NSObject{
    static func showAlert(_ title : String = "", message : String = "", completion:@escaping ( Bool) -> ()) {
        DispatchQueue.main.async{
            let alert = UIAlertController(title: message != "" ? title : "", message: message == "" ? title : message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
                completion(true)
            }))
            if var topController = UIWindow.keyWindow?.rootViewController {
                while let presentedViewController = topController.presentedViewController {
                    topController = presentedViewController
                }
                topController.present(alert, animated: true, completion: nil)
            }
        }
    }
}


