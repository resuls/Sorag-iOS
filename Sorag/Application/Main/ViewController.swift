//
//  ViewController.swift
//  Sorag
//
//  Created by Resul on 06.02.20.
//  Copyright © 2020 Resulkary Saparov. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    private final let TOKEN = "token"
    private final let TOKEN_EXPIRATION = "expiry"
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if isLoggedIn() {
//            DispatchQueue.main.async {
//                self.performSegue(withIdentifier: "feed", sender: self)
//            }
//        }
        
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        
        let myColor = UIColor(red:0.16, green:0.81, blue:0.94, alpha:1.0)
        usernameTextField.layer.borderColor = myColor.cgColor
        passwordTextField.layer.borderColor = myColor.cgColor
        usernameTextField.layer.borderWidth = 1.0
        passwordTextField.layer.borderWidth = 1.0
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func isLoggedIn() -> Bool {
        let expiry = UserDefaults.standard.object(forKey: TOKEN_EXPIRATION)
        
        if let expiry = expiry {
            let expiry = expiry as! Date
            
            if expiry < Date() {
                UserDefaults.standard.removeObject(forKey: TOKEN)
                UserDefaults.standard.removeObject(forKey: TOKEN_EXPIRATION)
                print("expired")
            } else {
                print("Signed in:")
                let token = UserDefaults.standard.string(forKey: TOKEN)
                if let token = token {
                    print(token)
                    return true
                }
            }
        }
        print("Nah, not in!")
        return false
    }
    
    func login() {
        let username = usernameTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        
        if !(username.isEmpty || password.isEmpty) {
            self.showSpinner(onView: self.view)
            attemptLogin(username: username, password: password) { result in
                switch result
                {
                case .failure(let error):
                    showInfo(view: self.self, title: "Error", info: error.localizedDescription)
                    print(error)
                case .success(let token):
                    UserDefaults.standard.set(token.token, forKey: self.TOKEN)
                    UserDefaults.standard.set(token.expiry, forKey: self.TOKEN_EXPIRATION)
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "feed", sender: self)
                    }
                }
                self.removeSpinner()
            }
        }
    }
    
    @IBAction func loginPressed(_ sender: UIButton) {
        login()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.returnKeyType == .next {
            passwordTextField.becomeFirstResponder()
        } else if textField.returnKeyType == .go {
            login()
        }
        return true
    }
}
