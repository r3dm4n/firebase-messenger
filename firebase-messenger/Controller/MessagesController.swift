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
    }
    
    @objc private func handleNewMessage() {
        let newMessageController = NewMessageController()
        let navController = UINavigationController(rootViewController: newMessageController)
        present(navController, animated: true, completion: nil)
    }
    
    private func checkIfUserIsLoggedIn() {
        if !isLoggedIn {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        } else {
            fetchUsersAndSetupNavBarTitles()
        }
    }
    
    func fetchUsersAndSetupNavBarTitles() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child(USERS).child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: Any] {
                self.navigationItem.title = dictionary["name"] as? String
            }
            
        }, withCancel: nil)
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
    
    
}
