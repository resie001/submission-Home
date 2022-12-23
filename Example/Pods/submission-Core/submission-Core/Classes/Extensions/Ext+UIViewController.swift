//
//  Ext+UIViewController.swift
//  submission-Core
//
//  Created by Ade Resie on 23/12/22.
//

import Foundation

public extension UIViewController {
    var viewController: UIViewController {
        get {
            return self
        }
    }
    
    var nav: UINavigationController? {
        get {
            return self.navigationController
        }
    }
    
    @objc func back() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func setupNavBar(title: String, isBorderless: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationItem.title = title
        self.navigationItem.backButtonTitle = ""
        self.navigationController?.navigationBar.tintColor = .white
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .systemBlue
            appearance.backButtonAppearance.normal.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            self.navigationController?.navigationBar.standardAppearance = appearance
            self.navigationController?.navigationBar.scrollEdgeAppearance = self.navigationController?.navigationBar.standardAppearance
        } else {
            self.navigationController?.navigationBar.barTintColor = .blue
        }
        
        if isBorderless {
            self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.navigationBar.layoutIfNeeded()
        } else {
            self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
            self.navigationController?.navigationBar.shadowImage = nil
            self.navigationController?.navigationBar.layoutIfNeeded()
        }
    }
    
    func alert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in
            self.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func alert(title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: {_ in
            self.dismiss(animated: true, completion: nil)
            if let completion = completion {
                completion()
            }
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func alert(title: String, message: String, positiveTitle: String = "OK", negativeTitle: String? = nil, positiveAction: (() -> Void)? = nil, negativeAction: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: positiveTitle, style: .default, handler: {_ in
            self.dismiss(animated: true, completion: nil)
            if let positiveAction = positiveAction {
                positiveAction()
            }
        }))
        alert.addAction(UIAlertAction(title: negativeTitle, style: .cancel, handler: {_ in
            self.dismiss(animated: true, completion: nil)
            if let negativeAction = negativeAction {
                negativeAction()
            }
        }))
        present(alert, animated: true, completion: nil)
    }
}
