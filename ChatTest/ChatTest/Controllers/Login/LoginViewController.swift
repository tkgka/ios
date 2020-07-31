//
//  LoginViewController.swift
//  ChatTest
//
//  Created by 김수환 on 2020/07/22.
//  Copyright © 2020 김수환. All rights reserved.
//

import UIKit
import FirebaseAuth
import FBSDKLoginKit
import JGProgressHUD
import GoogleSignIn

class LoginViewController: UIViewController {
    
    private let spinner = JGProgressHUD(style: .dark)
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "logo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let emailField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "Email Address......"
        
        field.leftView = UIView(frame: CGRect(x:0, y:0 , width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        return field
    }()
    
    private let passwordField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .done
        field.layer.cornerRadius = 12
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "password"
        
        field.leftView = UIView(frame: CGRect(x:0, y:0 , width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        field.isSecureTextEntry = true
        return field
    }()
    
    private let loginButton : UIButton = {
        let button = UIButton()
        button.setTitle("log in", for: .normal)
        button.backgroundColor = .link
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    
    private let FacebookloginButton:FBLoginButton = {
        let button = FBLoginButton()
        button.permissions = ["email,public_profile"]
        return button
    }()
    private let googleLogInButton = GIDSignInButton()
    
    private var loginObserver: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginObserver = NotificationCenter.default.addObserver(forName: .didLogInNotification, object: nil, queue: .main, using: {[weak self]_ in
            guard let strongself = self else {
                return
            }
            strongself.navigationController?.dismiss(animated: true, completion: nil)
        })
        
        GIDSignIn.sharedInstance()?.presentingViewController = self
        
        title = "Log in"
        view.backgroundColor = .white
        
        // Do any additional setup after loading the view.
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register", style: .done, target: self, action: #selector(didTapRegister))
        
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        
        
        emailField.delegate = self
        passwordField.delegate = self
        
        FacebookloginButton.delegate = self
        
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(loginButton)
        scrollView.addSubview(FacebookloginButton)
        scrollView.addSubview(googleLogInButton)
        
        
        
    }
    
    deinit {
        if let observer = loginObserver{
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        let size = scrollView.width/3
        imageView.frame = CGRect(x: (scrollView.width-size)/2,
                                 y: 20,
                                 width: size,
                                 height: size)
        
        emailField.frame = CGRect(x:30,
                                  y: imageView.bottom+10,
                                  width: scrollView.width-60,
                                  height: 52)
        passwordField.frame = CGRect(x:30,
                                     y: emailField.bottom+10,
                                     width: scrollView.width-60,
                                     height: 52)
        loginButton.frame = CGRect(x:30,
                                   y: passwordField.bottom+10,
                                   width: scrollView.width-60,
                                   height: 52)
        FacebookloginButton.frame = CGRect(x:30,
                                           y: loginButton.bottom+10,
                                           width: scrollView.width-60,
                                           height: 52)
        
        
        googleLogInButton.frame = CGRect(x:30,
                                         y: FacebookloginButton.bottom+10,
                                         width: scrollView.width-60,
                                         height: 52)
        
    }
    
    @objc private func loginButtonTapped(){
        
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
        guard let email = emailField.text, let password = passwordField.text,
            !email.isEmpty, !password.isEmpty, password.count>=6 else{
                alertUserLoginError()
                return
        }
        
        spinner.show(in: view)
        
        //firebase login
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: {[weak self] authResult, error in
            
            guard let StrongSelf = self else{
                return
            }
            
            //스피너 제거
            DispatchQueue.main.async {
                StrongSelf.spinner.dismiss()
            }
            
            
            guard let result = authResult ,error == nil else{
                print("Fail to log in : \(email)")
                return
            }
            
            let user = result.user
            
            let safeEmail = DatabaseManager.safeEmail(emailAddress: email)
            DatabaseManager.shared.getDataFor(path: safeEmail, completion: { result in
                switch result {
                case .success(let data):
                    guard let userData = data as? [String: Any],
                        let firstName = userData["first_name"] as? String,
                        let lastName = userData["last_name"] as? String else {
                            return
                    }
                    UserDefaults.standard.set("\(firstName) \(lastName)", forKey: "name")
                case .failure(let error):
                    print("failed to read data")
                }
            })
            UserDefaults.standard.set(email, forKey: "email")
            
            
            
            print("log in user: \(user)")
            StrongSelf.navigationController?.dismiss(animated: true, completion: nil)
        })
        
        
    }
    func alertUserLoginError() {
        let alert = UIAlertController(title: "woops", message: "please enter all information", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    @objc private func didTapRegister(){
        let vc = RegisterViewController()
        vc.title = "create Account"
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension LoginViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == emailField{
            passwordField.becomeFirstResponder()
        }
        else if textField == passwordField{
            loginButtonTapped()
        }
        
        return true
    }
}

extension LoginViewController: LoginButtonDelegate{
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        //no operation
    }
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        guard let token = result?.token?.tokenString else {
            print("User Failed to log in with Facebook")
            return
            
        }
        
        let facebookRequest = FBSDKLoginKit.GraphRequest(graphPath: "me", parameters: ["fields":"email,name"], tokenString: token, version: nil, httpMethod: .get)
        
        facebookRequest.start(completionHandler: { _, result, error in
            guard let result = result as? [String:Any], error == nil else{
                print("failed to make facebook graph request")
                return
            }
            
            print("\(result)")
            
            guard let userName = result["name"] as? String,
                let email = result["email"]as? String else{
                    print("fail to get from result")
                    return
            }
            let nameComponents = userName.components(separatedBy: " ")
            guard nameComponents.count == 2 else{
                return
            }
            
            let firstName = nameComponents[0]
            let lastName = nameComponents[1]
            
            DatabaseManager.shared.userExists(with: email, completion: {exists in
                if !exists{
                    let chatUser = ChatAppUser(firstName: firstName, lastName: lastName, emailAddress: email)
                    DatabaseManager.shared.insertUser(with: chatUser, completion: {success in
                        if success {
                            // upload image
                            
                        }
                    })
                }
            })
            
            
            let credential = FacebookAuthProvider.credential(withAccessToken: token)
            FirebaseAuth.Auth.auth().signIn(with: credential, completion: {[weak self] authResult , error in
                guard let StrongSelf = self else{
                    return
                }
                guard authResult != nil, error == nil else{
                    print("Facebook credential login Failed")
                    return
                }
                
                print("Log in Success")
                StrongSelf.navigationController?.dismiss(animated: true, completion: nil)
                
            })
            
            
        })
        
        
    }
    
    
}
