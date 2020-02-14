//
//  RegisterViewController.swift
//  Sorag
//
//  Created by Resul on 09.02.20.
//  Copyright © 2020 Resulkary Saparov. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController, UITextFieldDelegate {
    
    private final let TOKEN = "token"
    private final let TOKEN_EXPIRATION = "expiry"
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        emailTextField.delegate = self

        
        let myColor = UIColor(red:0.16, green:0.81, blue:0.94, alpha:1.0)
        usernameTextField.layer.borderColor = myColor.cgColor
        passwordTextField.layer.borderColor = myColor.cgColor
        confirmPasswordTextField.layer.borderColor = myColor.cgColor
        firstNameTextField.layer.borderColor = myColor.cgColor
        lastNameTextField.layer.borderColor = myColor.cgColor
        emailTextField.layer.borderColor = myColor.cgColor

        usernameTextField.layer.borderWidth = 0.5
        passwordTextField.layer.borderWidth = 0.5
        confirmPasswordTextField.layer.borderWidth = 0.5
        firstNameTextField.layer.borderWidth = 0.5
        lastNameTextField.layer.borderWidth = 0.5
        emailTextField.layer.borderWidth = 0.5

        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height / 3
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
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func login(username: String, password: String) {
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
    
    func validateEmail(enteredEmail:String) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: enteredEmail)
    }
    
    func register() {
        let username = usernameTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        let cpassword = confirmPasswordTextField.text ?? ""
        let email = emailTextField.text ?? ""
        let firstName = firstNameTextField.text ?? ""
        let lastName = lastNameTextField.text ?? ""

        if !(username.isEmpty || password.isEmpty || cpassword.isEmpty || email.isEmpty || firstName.isEmpty || lastName.isEmpty) {
            if password != cpassword {
                showInfo(view: self, title: "Error", info: "Your passwords are not matching!")
                return
            }
            if !validateEmail(enteredEmail: email) {
                showInfo(view: self, title: "Error", info: "Enter a valid email!")
                return
            }
            
            self.showSpinner(onView: self.view)
            attemptRegister(username: username, password: password, email: email, firstName: firstName, lastName: lastName) { result in
                switch result
                {
                case .failure(let error):
                    showInfo(view: self, title: "Error", info: error.localizedDescription)
                    print(error)
                case .success(let success):
                    print(success)
                    self.login(username: username, password: password)
                }
                self.removeSpinner()
            }
        }
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == usernameTextField {
            passwordTextField.becomeFirstResponder()
        } else if textField == passwordTextField {
            confirmPasswordTextField.becomeFirstResponder()
        } else if textField == confirmPasswordTextField {
            emailTextField.becomeFirstResponder()
        } else if textField == emailTextField {
            firstNameTextField.becomeFirstResponder()
        } else if textField == firstNameTextField {
            lastNameTextField.becomeFirstResponder()
        } else if textField == lastNameTextField {
            register()
            print("REGISTER")
        }
        return true
    }
    
    @IBAction func registerClicked(_ sender: UIButton) {
        register()
    }
}
