//
//  AuthService.swift
//  FireChat
//
//  Created by Nikhil Gharge on 03/09/20.
//  Copyright © 2020 Nikhil Gharge. All rights reserved.
//

import Foundation
import Firebase

struct ResidentialCredentials {
    let email: String
    let password: String
    let fullname: String
    let username: String
    let profileImage: UIImage
}

struct AuthService {
    
    static let shared = AuthService()
    
    func handleLogin(withEmail email: String, password: String, completion: AuthDataResultCallback?) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    func createUser(credentials: ResidentialCredentials, completion: ((Error?) -> Void)?){
            //Compressed the size of the photo
        guard let imageData = credentials.profileImage.jpegData(compressionQuality: 0.5) else {
                return
            }
            
            // Creates folder of images with different unique identifiers.
            
            let fileName = NSUUID().uuidString
            let ref = Storage.storage().reference(withPath: "/profile_images/\(fileName)")
            
            //Put data in above-mentioned reference.
            
            ref.putData(imageData, metadata: nil){ (meta, error) in
                if let error = error{
                    print("DEBUG: Failed to upload the error: \(error.localizedDescription)")
                    return
                }
                
                ref.downloadURL { (url, error) in
                    if let error = error{
                        print("DEBUG: Failed to upload the error: \(error.localizedDescription)")
                        return
                    }
                    guard let profileImageURL = url?.absoluteString else{return}
                    
                    //Create a new user with specified credentials.
                    
                    Auth.auth().createUser(withEmail: credentials.email, password: credentials.password) { (result, error) in
                        if let error = error {
                            print("DEBUG: Failed to create a user \(error.localizedDescription)")
                        }
                        
                        guard let uid = result?.user.uid else {return}
                        
                        //Store the user data in db.
                        
                        let data = ["email" : credentials.email,
                                    "password": credentials.password,
                                    "ProfileImageURL": profileImageURL,
                                    "uid": uid,
                                    "username": credentials.username,
                                    "fullname": credentials.fullname] as [String:Any]
                        
                        // Access the db.
                        
                        Firestore.firestore().collection("users").document(uid).setData(data, completion: completion)
//
//                        Firestore.firestore().collection("users").document(uid).setData(data){
//                            error in
//                            if let error = error {
//                            print("DEBUG: Failed to create a user \(error.localizedDescription)")
//                             }
//                            print("DEBUG: Created User successfully")
//
//                            self.dismiss(animated: true, completion: nil)
//                        }
                        
                    }
                    
                }
                
            }
            
        }
    }

