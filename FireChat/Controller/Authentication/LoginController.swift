//
//  LoginController.swift
//  FireChat
//
//  Created by Nikhil Gharge on 18/08/20.
//  Copyright © 2020 Nikhil Gharge. All rights reserved.
//


import UIKit
import Firebase

protocol AuthenticationDelegate: class {
    func handleAuthentication()
}

class LoginViewController: UIViewController {
    
    // Mark:- Properties
    
    private var viewModel  = LoginViewModel()
    
    weak var delegate: AuthenticationDelegate?
    
    private let iconImage:UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "bubble.right")
        iv.tintColor = .white
        return iv
    }()
    
    private lazy var emailContainerView: InputContainerView = {
       return InputContainerView(image: UIImage(systemName: "envelope")!,
                                                     textfield: emailTextField)       //containerView.backgroundColor = .cyan
       
//       let messageEmailView = UIImageView()
//       messageEmailView.image = UIImage(systemName: "envelope")
//       messageEmailView.tintColor = .white
//
//       containerView.addSubview(messageEmailView)
//       messageEmailView.centerY(inView: containerView)
//       messageEmailView.anchor(left: containerView.leftAnchor, paddingLeft: 8)
//       messageEmailView.setDimensions(height: 24, width: 28)
//
//        containerView.addSubview(emailTextField)
//        emailTextField.centerY(inView: containerView)
//        emailTextField.anchor(left: messageEmailView.rightAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingLeft: 8, paddingBottom: -8)
//
//       containerView.setHeight(height: 50)
       //return containerView
    }()
    
    private lazy var passwordContainerView: InputContainerView = {
        return InputContainerView(image: UIImage(systemName: "lock")!,
                                               textfield: passwordTextField)
        
        
//
//        let passwordImageView = UIImageView()
//        passwordImageView.image = UIImage(systemName: "lock")
//        passwordImageView.tintColor = .white
//
//        containerView.addSubview(passwordImageView)
//        passwordImageView.centerY(inView: containerView)
//        passwordImageView.anchor(left: containerView.leftAnchor, paddingLeft: 8)
//        passwordImageView.setDimensions(height: 28, width: 28)
//
//
//        containerView.addSubview(passwordTextField)
//        passwordTextField.centerY(inView: containerView)
//        passwordTextField.anchor(left: passwordImageView.rightAnchor, bottom: containerView.bottomAnchor, right: containerView.rightAnchor, paddingLeft: 8, paddingBottom: -8)
//
//        containerView.setHeight(height: 50)
        //containerView.backgroundColor = .yellow
    }()
    
    private let logInbutton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log In", for: .normal)
        button.setHeight(height: 50)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        button.isEnabled = false
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action:#selector(handleAuthenticationProcess), for:.touchUpInside)
        return button
    }()
    
    
    private let emailTextField = CustomTextField(placeholder: "Email")
    
    private let passwordTextField: CustomTextField = {
        let passWordTxtField = CustomTextField(placeholder: "Password")
        passWordTxtField.isSecureTextEntry = true
        return passWordTxtField
    }()
    
    private let dontHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "dont have an account? ", attributes: [.font: UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor.white])
        
        attributedTitle.append(NSMutableAttributedString(string: "Sign Up" , attributes: [.font: UIFont.boldSystemFont(ofSize: 16), .foregroundColor: UIColor.white]))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        
        return button
        
    }()
    
    // Mark:- lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // Mark: Selectors
    
    @objc func handleSignUp(){
        print("Sign Up page...")
        let signUpPageController = RegistrationViewController()
        signUpPageController.delegate = delegate
        navigationController?.pushViewController(signUpPageController, animated: true)
    }
    
    @objc func handleAuthenticationProcess(){
        print("DEBUG : Authentication Process....")
        guard let email = emailTextField.text else {
            return
        }
        guard let password = passwordTextField.text else {
            return
        }
        
        self.showLoader(true, withText: "Signing you up")

        AuthService.shared.handleLogin(withEmail: email, password: password) { (result, error) in
            if let error = error{
                print("DEBUG: Error is \(error.localizedDescription)")
                self.showLoader(false)
                self.showError(error.localizedDescription)
                return
            }
            
            self.showLoader(false)
            self.dismiss(animated: true, completion: nil)
            //self.delegate?.handleAuthentication()
            
        }
    }
    
    @objc func textDidChange(sender: UITextField){
        if sender == emailTextField{
            viewModel.email = sender.text
        }else{
            viewModel.password = sender.text
        }
               
        checkLoginStatus()
        
    }
    
    //Mark:- Helper Functions
    func configureUI(){
        
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        
        configureGradientLayer()
        
        view.addSubview(iconImage)
        iconImage.centerX(inView:view)
        iconImage.anchor(top:view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        iconImage.setDimensions(height: 120, width: 120)
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView, passwordContainerView,logInbutton])
        
        stack.axis = .vertical
        stack.spacing = 16
        
        view.addSubview(stack)
        stack.anchor(top:iconImage.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 32, paddingLeft: 32, paddingRight: 32)
        
        
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 32, paddingRight: 32)
        
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)

//        // Programatically activate autolayout
//        iconImage.translatesAutoresizingMaskIntoConstraints = false
//        iconImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        iconImage.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
//        iconImage.heightAnchor.constraint(equalToConstant: 120).isActive = true
//        iconImage.widthAnchor.constraint(equalToConstant: 120).isActive = true

    }
    
    func checkLoginStatus(){
        if viewModel.formIsValid() == true{
            logInbutton.isEnabled = true
            logInbutton.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        }else{
            logInbutton.isEnabled = false
            logInbutton.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        }
        
    }

    func handleAuthentication(){
        
    }
   
}


