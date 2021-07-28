//
//  ProfileController.swift
//  FireChat
//
//  Created by Nikhil Gharge on 16/09/20.
//  Copyright © 2020 Nikhil Gharge. All rights reserved.
//

import Foundation
import UIKit
import Firebase

private let resueIdentifier = "ProfileCell"

protocol ProfileControllerDelegate: class {
    func handleLogout()
}

class ProfileController: UITableViewController {
    
    //Mark: - Properties
    
    private lazy var headerView = ProfileHeader(frame: .init(x: 0, y: 0, width: view.frame.width, height:380))
    
    private let footerView =  ProfileFooter()
    
    weak var delegate: ProfileControllerDelegate?
    
    private var user: Users? {
        didSet{headerView.user = user}
    }
    
    //Mark: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchUser()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
    }
    //Mark: - Selectors
    
    //Mark: - API
    func fetchUser(){
        
        showLoader(true)
        guard let uid = Auth.auth().currentUser?.uid else {
            return
        }
        UserDataService.fetchUser(withUid: uid) { (user) in
            self.showLoader(false)
            self.user = user
            print("DEBUG: User is \(user.fullname)")
        }
    }
    
    //Mark: - Helpers
    func configureUI(){
        tableView.backgroundColor = .white
        
        tableView.tableHeaderView = headerView
        headerView.delegate = self
        footerView.delegate = self
        
        tableView.register(ProfileCell.self, forCellReuseIdentifier: resueIdentifier)
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.rowHeight = 64
        tableView.backgroundColor = .systemGroupedBackground
        
        footerView.frame = .init(x: 0, y: 0, width: view.frame.width, height: 100)
        tableView.tableFooterView = footerView
    }
    
}


//Mark: - UITableviewDelegate
extension ProfileController{
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let value = ProfileViewModel(rawValue: indexPath.row)
        
        switch value {
        case .accountInfo:
            print("Account Info")
        case .settings:
            print("Settings")
        case .none:
            print("Didnt click any")
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
}


//Mark: - UITableviewDatasource

extension ProfileController{
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ProfileViewModel.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: resueIdentifier, for: indexPath) as! ProfileCell
        
        let viewModel = ProfileViewModel(rawValue: indexPath.row)
        cell.viewModel = viewModel
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}


extension ProfileController: ProfileHeaderDelegate{
    func dismissController() {
        dismiss(animated: true, completion: nil)
    }
}

extension ProfileController: ProfileFooterDelegate{
    func handleLogout() {
        
        let alert = UIAlertController(title: nil, message: "Are you sure you want to logout", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title:"Logout", style:.destructive, handler: { _ in
            self.dismiss(animated: true) {
                self.delegate?.handleLogout()
            }

        }))
        
        alert.addAction(UIAlertAction(title:"Cancel", style:.cancel, handler:nil))
        
        present(alert, animated: true, completion: nil)
        
    }
    
}
