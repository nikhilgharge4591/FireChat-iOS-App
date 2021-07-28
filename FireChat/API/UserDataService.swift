//
//  UserDataService.swift
//  FireChat
//
//  Created by Nikhil Gharge on 04/09/20.
//  Copyright © 2020 Nikhil Gharge. All rights reserved.
//

import Firebase

struct UserDataService {
    
    static func fetchUsers(completion: (@escaping([Users])-> Void)){
        Firestore.firestore().collection("users").getDocuments { (snapshot, error) in
            guard var users = snapshot?.documents.map({ Users(dictionary: $0.data())}) else {return}
            
            if let index = users.firstIndex(where: {$0.uid == Auth.auth().currentUser?.uid}){
                users.remove(at: index)
            }
            
            completion(users)
        }
    }
    
    static func fetchUser(withUid uid:String, completion: @escaping(Users) -> Void){
        Firestore.firestore().collection("users").document(uid).getDocument { (snapshot, error) in
            guard let dictionary = snapshot?.data() else { return }
            let user = Users(dictionary: dictionary)
            completion(user)
        }
            
    }
    
    static func fetchConversation(completion: @escaping([ConversationMessage]) -> Void){
        var conversations = [ConversationMessage]()
        guard let currentUid = Auth.auth().currentUser?.uid else {
            return
        }
        
        let query = Firestore.firestore().collection("messages").document(currentUid).collection("recent-messages").order(by: "timestamp")
        
        query.addSnapshotListener { (snapshot, error) in
            if let error = error {
                print("DEBUG: Error is \(error.localizedDescription)")
            }
            snapshot?.documentChanges.forEach({ (docChange) in
                let dictionary = docChange.document.data()
                let message = UserMessages(dictionary: dictionary)
                
                self.fetchUser(withUid: message.chatUser) { (user) in
                    let conversation = ConversationMessage(user: user, message: message)
                    conversations.append(conversation)
                    completion(conversations)
                }
            })
        }
    }
    
    static func fetchMessages(forUser user:Users, completion: @escaping([UserMessages]) -> Void){
        var messages = [UserMessages]()
        
        guard let currentId = Auth.auth().currentUser?.uid else {return}
        
        let query = Firestore.firestore().collection("messages").document(currentId).collection(user.uid).order(by: "timestamp")
        
        query.addSnapshotListener { (snapshot, error) in
            snapshot?.documentChanges.forEach({ (docChange) in
                if docChange.type == .added{
                    let dictionary =  docChange.document.data()
                    messages.append(UserMessages(dictionary: dictionary))
                    completion(messages)
                }
            })
        }
    }
    
    static func uploadMessages(_ message:String, to user:Users, completion: ((Error?) -> Void)?) {
        
        guard let currentId =  Auth.auth().currentUser?.uid else {
            return
        }

        let data = ["text":message,
                    "fromId":currentId,
                    "toId":user.uid,
        "timestamp":Timestamp(date: Date())] as [String:Any]
        
        Firestore.firestore().collection("messages").document(currentId).collection(user.uid).addDocument(data: data) {_ in
            Firestore.firestore().collection("messages").document(user.uid).collection(currentId).addDocument(data: data, completion: completion)
            
            //setData - Will overide messages and will display recent messages between current users
            Firestore.firestore().collection("messages").document(currentId).collection("recent-messages").document(user.uid).setData(data)
            
            Firestore.firestore().collection("messages").document(user.uid).collection("recent-messages").document(currentId).setData(data)
            
        }
        
    }
}
