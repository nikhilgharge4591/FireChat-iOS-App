//
//  RegistrationController.swift
//  FireChat
//
//  Created by Nikhil Gharge on 18/08/20.
//  Copyright © 2020 Nikhil Gharge. All rights reserved.
//

import UIKit
import Firebase
import JGProgressHUD

class RegistrationViewController: UIViewController {
    
    // Mark:- Properties
    
    private var registrationViewModel = RegistrationViewModel()
    
    private var profileImage: UIImage?
    
    weak var delegate:AuthenticationDelegate?
    
    private let plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "plus_photo"), for: .normal)
        button.tintColor = .white
        button.clipsToBounds = true
        button.imageView?.contentMode = .scaleAspectFill
        button.addTarget(self, action:#selector(handleSelectPhoto), for:.touchUpInside)
        return button
    }()
    
    private lazy var emailContainerView: InputContainerView = {
        return InputContainerView(image:UIImage(systemName:"envelope")!, textfield:emailTextField)
    }()
    
    private lazy var passwordContainerView: InputContainerView = {
        return InputContainerView(image: UIImage(systemName:"lock")!, textfield: passwordTextField)
    }()
    
    private lazy var fullNameContainerView: InputContainerView = {
        return InputContainerView(image: #imageLiteral(resourceName: "ic_person_outline_white_2x"),
                                  textfield: fullNameTextField)
    }()
    
    private lazy var userNameContainerView: InputContainerView  = {
        return InputContainerView(image: #imageLiteral(resourceName: "ic_person_outline_white_2x"),
                                  textfield: userNameTextField)
    }()
    
    private let emailTextField = CustomTextField(placeholder: "Email")
    
    private let passwordTextField: CustomTextField = {
        let passWordTxtField = CustomTextField(placeholder: "Password")
        passWordTxtField.isSecureTextEntry = true
        return passWordTxtField
    }()
    
    private let fullNameTextField = CustomTextField(placeholder: "FullName")
    
    private let userNameTextField = CustomTextField(placeholder: "Username")
    


    // Mark:- lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNotificationObservers()

    }
    
    private let signUpbutton: UIButton = {
           let button = UIButton(type: .system)
           button.setTitle("Sign Up", for: .normal)
           button.setHeight(height: 50)
           button.layer.cornerRadius = 5
           button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
           button.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
           button.isEnabled = false
           button.setTitleColor(.white, for: .normal)
           button.addTarget(self, action:#selector(handleRegistration), for:.touchUpInside)
           return button
       }()
       
       private let alreadyHaveAccButton: UIButton = {
           let button = UIButton(type: .system)
           let attributedTitle = NSMutableAttributedString(string: "Already have an account? ", attributes: [.font: UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor.white])
           
           attributedTitle.append(NSMutableAttributedString(string: "Sign Up" , attributes: [.font: UIFont.boldSystemFont(ofSize: 16), .foregroundColor: UIColor.white]))
           
           button.setAttributedTitle(attributedTitle, for: .normal)
           
           button.addTarget(self, action: #selector(handleAccHolders), for: .touchUpInside)
           return button
           
       }()
    // Mark: Helper Methods
    func configureUI(){
        configureGradientLayer()
        
        view.addSubview(plusPhotoButton)
        plusPhotoButton.centerX(inView:view)
        plusPhotoButton.anchor(top:view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        plusPhotoButton.setDimensions(height: 200, width: 200)
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView, fullNameContainerView,userNameContainerView,passwordContainerView, signUpbutton])
        
        stack.axis = .vertical
        stack.spacing = 16
        
        view.addSubview(stack)
        stack.anchor(top:plusPhotoButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 32, paddingLeft: 32, paddingRight: 32)
        
       view.addSubview(alreadyHaveAccButton)
        alreadyHaveAccButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 32, paddingRight: 32)
        
        
    }
    
    func configureNotificationObservers(){
        emailTextField.addTarget(self, action:#selector(textDidChange), for: .editingChanged)
        fullNameTextField.addTarget(self, action:#selector(textDidChange), for: .editingChanged)
        userNameTextField.addTarget(self, action:#selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action:#selector(textDidChange), for: .editingChanged)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

    }
    
    func checkStatus(){
        if registrationViewModel.formIsValid() == true{
            signUpbutton.isEnabled = true
            signUpbutton.backgroundColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1)
        }else{
            signUpbutton.isEnabled = false
            signUpbutton.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        }
    }
    
    //Mark: Selector Method
    @objc func handleSelectPhoto(){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func handleAccHolders(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc func textDidChange(sender: UITextField){
        if sender == emailTextField{
            registrationViewModel.email = sender.text
        }else if sender == fullNameTextField{
            registrationViewModel.fullname = sender.text
        }else if sender == userNameTextField{
            registrationViewModel.username = sender.text
        }else{
            registrationViewModel.password = sender.text
        }
        
        checkStatus()
    }
    
    @objc func keyboardWillShow(){
        if view.frame.origin.y == 0{
            view.frame.origin.y = -88
        }
    }
    
    @objc func keyboardWillHide(){
        if view.frame.origin.y == -88{
            view.frame.origin.y = 0
        }
    }
    
    @objc func handleRegistration(){
        //1. Authentication of users 2. Adding images into storage 3. Storing Data for each user i db.
        guard let email = emailTextField.text, let password = passwordTextField.text, let fullname = fullNameTextField.text, let username = userNameTextField.text, let profImage = profileImage else {
            return
        }
        // Note: ProfileImageURL cant exist if we dont have image in storage(db).
        let credentials = ResidentialCredentials(email: email, password: password, fullname: fullname, username: username, profileImage: profImage)
        
        showLoader(true, withText: "Logging in")
        
        AuthService.shared.createUser(credentials: credentials) { error in
            if let error = error{
                print("DEBUG: Print error details \(error.localizedDescription)")
                self.showLoader(false)
                self.showError(error.localizedDescription)
                return
            }
            
            self.showLoader(false)
            self.dismiss(animated: true, completion:nil)
            //self.delegate?.handleAuthentication()
            
        }

   }
}


extension RegistrationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
        profileImage = image
        plusPhotoButton.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        plusPhotoButton.layer.borderColor = UIColor(white:1, alpha: 0.7).cgColor
        plusPhotoButton.layer.borderWidth = 3.0
        plusPhotoButton.layer.cornerRadius = 200 / 2
        
        
        dismiss(animated: true, completion:nil)
        
    }
}
