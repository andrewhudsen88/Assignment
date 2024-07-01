//
//  ProgressHud.swift
//  Assignment
//
//  Created by Andrew Hudsun on 07/07/24.
//

import UIKit

var kScreenSize : CGRect {
    UIScreen.main.bounds
}
var kScreenWidth : CGFloat {
    UIScreen.main.bounds.width
}
var kScreenHeight : CGFloat {
    UIScreen.main.bounds.height
}

class ProgressHud:UIView {
    static let shared = ProgressHud()
    
    
    var container:UIView!
    var subContainer : UIView!
    var activityIndicatorView : UIActivityIndicatorView!
    var blurEffectView : UIVisualEffectView!
    
    init() {
        //Main Container
        super.init(frame: CGRect())
        
        self.backgroundColor = .black.withAlphaComponent(0.7)
        subContainer = UIView(frame: CGRect(x: 0, y: 0, width: kScreenWidth / 3.0, height: kScreenWidth / 4.0))
        container = UIView()
        blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        activityIndicatorView = UIActivityIndicatorView()
        container.backgroundColor = UIColor.clear
        container.translatesAutoresizingMaskIntoConstraints = false
        //Sub Container
        subContainer.layer.cornerRadius = 5.0
        subContainer.layer.masksToBounds = true
        subContainer.backgroundColor = UIColor.clear
        
        //Activity Indicator
        activityIndicatorView.hidesWhenStopped = true
        
        //Blur Effect
        //always fill the view
        blurEffectView.frame = container.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        fatalError("init(coder:) has not been implemented")
    }
    
    func showWithBlurView() {
        
        DispatchQueue.main.async {[weak self] in
            
            //only apply the blur if the user hasn't disabled transparency effects
            if !UIAccessibility.isReduceTransparencyEnabled {
                self?.addSubview(self!.container)
                self?.container.backgroundColor = UIColor.clear.withAlphaComponent(0.5)
                self?.container.centerXAnchor.constraint(equalTo: self!.centerXAnchor).isActive = true
                self?.container.centerYAnchor.constraint(equalTo: self!.centerYAnchor).isActive = true
                self?.container.addSubview(self!.blurEffectView)
                self?.blurEffectView.centerXAnchor.constraint(equalTo: self!.container.centerXAnchor).isActive = true
                self?.blurEffectView.centerYAnchor.constraint(equalTo: self!.container.centerYAnchor).isActive = true

            } else {
                self?.container.backgroundColor = UIColor.black.withAlphaComponent(0.0)
            }
            
            self?.container.addSubview(self!.activityIndicatorView)
            self?.activityIndicatorView.color = UIColor.white
            
            self?.activityIndicatorView.centerXAnchor.constraint(equalTo: self!.container.centerXAnchor).isActive = true
            self?.activityIndicatorView.centerYAnchor.constraint(equalTo: self!.container.centerYAnchor).isActive = true
            self?.activityIndicatorView.startAnimating()
            
            
            if let window = self?.getKeyWindow() {
                window.addSubview(self!)
                self?.leadingAnchor.constraint(equalTo: window.leadingAnchor).isActive = true
                self?.trailingAnchor.constraint(equalTo: window.trailingAnchor).isActive = true
                self?.topAnchor.constraint(equalTo: window.topAnchor).isActive = true
                self?.bottomAnchor.constraint(equalTo: window.bottomAnchor).isActive = true
            }
            self?.container.alpha = 0.0
            self?.alpha = 0.0
            UIView.animate(withDuration: 0.5, animations: {
                self?.container.alpha = 1.0
                self?.alpha = 1.0
            })
        }
    }
    
    func hide() {
        DispatchQueue.main.async {[weak self] in
            UIView.animate(withDuration: 0.5, animations: {
                self?.container.alpha = 0.0
                self?.alpha = 0.0
            }) { finished in
                self?.removeFromSuperview()
                self?.activityIndicatorView.stopAnimating()
                
                self?.activityIndicatorView.removeFromSuperview()
//                self?.textLabel.removeFromSuperview()
                self?.subContainer.removeFromSuperview()
                self?.blurEffectView.removeFromSuperview()
                self?.container.removeFromSuperview()
                
            }
        }
    }
    
    private func getKeyWindow() -> UIWindow? {
        guard #available(iOS 13.0, *),
            let window = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.windows
                .filter({$0.isKeyWindow}).first
         else {
            // Fallback on earlier versions
            return nil
        }
        
        return window
    }
}

