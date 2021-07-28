//
//  ConversationsController.swift
//  FireChat
//
//  Created by Nikhil Gharge on 18/08/20.
//  Copyright © 2020 Nikhil Gharge. All rights reserved.
//

import UIKit
import Firebase
private let reuseIdentifier = "ConversationCell"

class ConversationsController: UIViewController{
    
    // Mark:- Properties
    private let tableview = UITableView()
    
    private var conversationMessagesArr = [ConversationMessage]()
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var conversationDictionary = [String: ConversationMessage]()
    
    private let addUserButton: UIButton = {
        let userButton = UIButton(type: .system)
        userButton.setImage(UIImage(systemName: "plus"), for: .normal)
        userButton.backgroundColor = .systemPurple
        userButton.tintColor = .white
        userButton.imageView?.setDimensions(height: 24, width: 24)
        userButton.addTarget(self, action:#selector(showNewMessage), for: .touchUpInside)
        return userButton
    }()
    
    // Mark:- Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureSearchBar()
        authenticUser()
        fetchConversations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureNavigation()
    }
    
    // Selectors
    @objc func showProfile(){
        let profilecontroller = ProfileController(style: .insetGrouped)
        profilecontroller.delegate = self
        let nav = UINavigationController(rootViewController: profilecontroller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
       //logout()
    }
    
    @objc func showNewMessage(){
        let controller = NewMessageController()
        controller.delegate = self
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    //Mark: API
    func authenticUser(){
        if Auth.auth().currentUser?.uid == nil{
            print("DEBUG: User not logged in. Please Sign in")
            showLoginScreen()
        }
    }
    
    
    func fetchConversations(){
        showLoader(true)
        UserDataService.fetchConversation { (conversationMessagesArr) in
            
            conversationMessagesArr.forEach { (conversation) in
                let message = conversation.message
                self.conversationDictionary[message.chatUser] = conversation
            }
            
            self.showLoader(false)
            self.conversationMessagesArr = Array(self.conversationDictionary.values)
            self.tableview.reloadData()
        }
    }
    func showLoginScreen(){
        DispatchQueue.main.async {
            let loginController = LoginViewController()
            loginController.delegate = self
            let nav = UINavigationController(rootViewController: loginController)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        }
        
    }
    
    func logout(){
        do {
            try Auth.auth().signOut()
            showLoginScreen()
        } catch  {
            print("DEBUG: Error Signing out")
        }
    }
    
    // Mark:- Helpers
    func configureUI(){
        view.backgroundColor = .white
        
        configureNavigation()
        configureTableView()
        
        let image = UIImage(systemName: "person.circle.fill")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style:.plain, target:self, action: #selector(showProfile))
        
        view.addSubview(addUserButton)
        addUserButton.setDimensions(height: 56, width: 56)
        addUserButton.layer.cornerRadius = 56/2
        addUserButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingBottom: 16, paddingRight: 16)
        
    }
    
    func configureTableView(){
        tableview.backgroundColor = .white
        tableview.rowHeight = 80
        tableview.register(ConversationCell.self, forCellReuseIdentifier: reuseIdentifier)
        // Show separator line depedning upon the contents in tableview
        tableview.tableFooterView = UIView()
        
        // Conforming to datasource and delegate
        tableview.dataSource = self
        tableview.delegate = self
        
        view.addSubview(tableview)
        tableview.frame = view.frame
    }
    
    func configureNavigation(){
        configureNavigationBar(withText: "Messages", prefersLargeTitles: true)
    }
    
    func showChatUser(forUser user:Users){
        let chatVC = ChatViewController(user: user)
        navigationController?.pushViewController(chatVC, animated:true)
    }
    
    func configureSearchBar(){
        searchController.searchBar.showsCancelButton = true
        navigationItem.searchController = searchController
    }
    
}

//MARK: UITableViewDataSource

extension ConversationsController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversationMessagesArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier:reuseIdentifier, for: indexPath) as! ConversationCell
        cell.conversation = conversationMessagesArr[indexPath.row]
        return cell
    }
    
    
}

//MARK: UITableViewDelegate

extension ConversationsController: UITableViewDelegate{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = conversationMessagesArr[indexPath.row].user
        showChatUser(forUser: user)
    }
}

extension ConversationsController: NewMessageControllerDelegate{
    func controller(_ controller: NewMessageController, wantsToChatWith user: Users) {
        dismiss(animated:true, completion:nil)
        showChatUser(forUser: user)

    }
    
    
}

extension ConversationsController: ProfileControllerDelegate{
    func handleLogout() {
        logout()
    }
}

extension ConversationsController: AuthenticationDelegate{
    func handleAuthentication() {
        dismiss(animated: true, completion: nil)
        configureUI()
        fetchConversations()
    }
    
    
}
