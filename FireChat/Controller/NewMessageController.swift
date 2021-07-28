//
//  NewMessageController.swift
//  FireChat
//
//  Created by Nikhil Gharge on 03/09/20.
//  Copyright © 2020 Nikhil Gharge. All rights reserved.
//

import Foundation
import UIKit

protocol NewMessageControllerDelegate: class {
    func controller(_ controller: NewMessageController, wantsToChatWith user: Users)
}

class NewMessageController: UITableViewController {
    
    //Mark: Properties
    private let reuseIdentifier = "UserCell"
    private var users = [Users]()
    weak var delegate: NewMessageControllerDelegate?
    
    var filteredUsers = [Users]()
    
    private var inSearchMode: Bool{
        return searchBar.isActive && !searchBar.searchBar.text!.isEmpty
    }
    
    private let searchBar = UISearchController(searchResultsController: nil)
    
    //Mark: Selector
    @objc func dismissCurrentView(){
        dismiss(animated: true, completion:nil)
    }
    
    //Mark: API
    func fetchUsers(){
        showLoader(true)
        UserDataService.fetchUsers { (users) in
            self.showLoader(false)
            self.users = users
            
            print("DEBUG: Print users \(users)")
            self.tableView.reloadData()
        }
        
    }
    
    //Mark: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureSearchBar()
        fetchUsers()
    }
    
    //Mark: - Helpers
    
    func configureUI(){
        configureNavigationBar(withText:"New Message", prefersLargeTitles:false)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action:#selector(dismissCurrentView))
        
        tableView.tableFooterView = UIView()
        tableView.register(UserCell.self, forCellReuseIdentifier:reuseIdentifier)
        tableView.rowHeight = 80
    }
    
      func configureSearchBar(){
        
        searchBar.searchResultsUpdater = self
        searchBar.searchBar.showsCancelButton = false
        navigationItem.searchController = searchBar
        searchBar.obscuresBackgroundDuringPresentation = false
        searchBar.hidesNavigationBarDuringPresentation = false
        searchBar.searchBar.placeholder = "Search for a user"
        definesPresentationContext = false
        
        if let textField = searchBar.searchBar.value(forKey:"searchField") as? UITextField{
            textField.textColor = .systemPurple
            textField.backgroundColor = .white
        }
        
      }
    
    
}


//Mark: UITableViewDataSource


extension NewMessageController{
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  inSearchMode ? filteredUsers.count : users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UserCell
        cell.user = inSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row]
        return cell
    }
}

extension NewMessageController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("DEBUG: Did select row \(users[indexPath.row].username)")
        let user = inSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row]
        delegate?.controller(self, wantsToChatWith: user)
    }
}

extension NewMessageController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else {
            return
        }
        
        filteredUsers = users.filter({ (user) -> Bool in
            return user.username.contains(searchText) || user.fullname.contains(searchText)
        })
        
        self.tableView.reloadData()
    }
}
