//
//  ChatViewController.swift
//  FireChat
//
//  Created by Nikhil Gharge on 06/09/20.
//  Copyright © 2020 Nikhil Gharge. All rights reserved.
//

import Foundation
import UIKit

class ChatViewController: UICollectionViewController {
    
    //MARK: Properties
    
    private let user: Users
    
    private var usersMessage = [UserMessages]()
    
    private let resueIdentifier = "ChatCell"
    
    var currentUser = false
    
    private lazy var customInputView: CustomInputAccessoryView = {
        let iv  = CustomInputAccessoryView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
        iv.delegate = self
        return iv
    }()
    
    //Mark: Lifecycle
    
    init(user:Users) {
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchMessages()
    }
    
    override var inputAccessoryView: UIView? {
        get { return customInputView }
    }
    
    override var canBecomeFirstResponder: Bool{
        return true
    }
    
    //Mark: API
    
    func fetchMessages(){
        
        showLoader(true)
        UserDataService.fetchMessages(forUser: user) { (userMessages) in
            self.showLoader(false)
            self.usersMessage = userMessages
            self.collectionView.reloadData()
            self.collectionView.scrollToItem(at: [0, userMessages.count - 1], at:.bottom, animated: true)
        }
    }
    //Mark: Helpers
        
    func configureUI(){
        collectionView.backgroundColor = .white
        configureNavigationBar(withText: user.username, prefersLargeTitles:false)
        
        collectionView.register(MessageCell.self, forCellWithReuseIdentifier: resueIdentifier)
        collectionView.alwaysBounceVertical = true
        
        collectionView.keyboardDismissMode = .interactive
    }
    
}

extension ChatViewController{
        
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return usersMessage.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: resueIdentifier, for: indexPath) as! MessageCell
        cell.message = usersMessage[indexPath.row]
        cell.message?.user = user
        return cell
    }
}

extension ChatViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 16, left: 0, bottom: 16, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let estimatedSizeCell = MessageCell(frame: frame)
        estimatedSizeCell.message = usersMessage[indexPath.row]
        estimatedSizeCell.layoutIfNeeded()
        
        let targetSize = CGSize(width: view.frame.width, height: 1000)
        let estimateSize = estimatedSizeCell.systemLayoutSizeFitting(targetSize)
        
        return .init(width: view.frame.width, height: estimateSize.height)
    }

}

extension ChatViewController: CustomInputAccessoryViewDelegate{
    func inputView(_ inputView: CustomInputAccessoryView, wantsToSend message: String) {
        print("DEBUG: Handle Chat Messages here:")
        print("DEBUG: UserId")
        UserDataService.uploadMessages(message, to: user) { (error) in
            if let error = error{
                print("DEBUG: Upload message is \(error.localizedDescription)")
                return
            }
            
            inputView.clearMessageText()
        }
    }
    
    
}
