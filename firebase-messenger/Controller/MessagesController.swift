//
//  ViewController.swift
//  firebase-messenger
//
//  Created by r3d on 24/10/2017.
//  Copyright © 2017 Alexandru Corut. All rights reserved.
//

import UIKit
import Firebase

class MessagesController: UITableViewController {
    
    private var isLoggedIn = Auth.auth().currentUser?.uid != nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: LOGOUT, style: .plain, target: self, action: #selector(handleLogout))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "new_message_icon"), style: .plain, target: self, action: #selector(handleNewMessage))
        
        checkIfUserIsLoggedIn()
        
        observeMessages()
    }
    
    private func observeMessages() {
        let ref = Database.database().reference().child(MESSAGES)
        ref.observe(.childAdded) { (snapshot) in
            print(snapshot)
        }
    }
    
    @objc private func handleNewMessage() {
        let newMessageController = NewMessageController()
        newMessageController.messagesController = self
        let navController = UINavigationController(rootViewController: newMessageController)
        present(navController, animated: true, completion: nil)
    }
    
    private func checkIfUserIsLoggedIn() {
        if !isLoggedIn {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            fetchUserAndSetupNavBarTitles()
        }
    }
    
    func fetchUserAndSetupNavBarTitles() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child(USERS).child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let user = User(dictionary: dictionary)
                self.setupNavBarWithUser(user: user)
            }
            
        }, withCancel: nil)
    }
    
   
    
    @objc func showChatControllerForUser(user: User) {
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.user = user
        navigationController?.pushViewController(chatLogController, animated: true)
    }
    
    @objc private func handleLogout() {
        
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        let loginController = LoginController()
        loginController.messagesController = self
        present(loginController, animated: true, completion: nil)
    }
    
    func setupNavBarWithUser(user: User) {
        let titleButton = UIButton()
        titleButton.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        titleButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        let profileImageView = UIImageView()
        titleButton.addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 20
        profileImageView.clipsToBounds = true
        
        titleButton.addSubview(profileImageView)
        
        if let profileImageUrl = user.profileImageUrl {
            profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
        }
        
        profileImageView.leftAnchor.constraint(equalTo: titleButton.leftAnchor).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: titleButton.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        
        let nameLabel = UILabel()
        titleButton.addSubview(nameLabel)
        
        nameLabel.text = user.name
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        
        nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: titleButton.rightAnchor).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalTo: profileImageView.heightAnchor).isActive = true
        
        titleButton.centerXAnchor.constraint(equalTo: titleButton.centerXAnchor).isActive = true
        titleButton.centerYAnchor.constraint(equalTo: titleButton.centerYAnchor).isActive = true
        self.navigationItem.titleView = titleButton
    }
    
    
}
