 //
 //  NewMessageController.swift
 //  firebase-messenger
 //
 //  Created by r3d on 25/10/2017.
 //  Copyright © 2017 Alexandru Corut. All rights reserved.
 //
 
 import UIKit
 import Firebase
 
 class NewMessageController: UITableViewController {
    
    private var users = [User]()
    
    var messagesController : MessagesController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        fetchUser()
        tableView.register(UserCell.self, forCellReuseIdentifier: NEW_MESSAGE_CELL_ID)

    }
    
    private func setupNavBar() {
        navigationItem.title = NEW_MESSAGE
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: CANCEL, style: .plain, target: self, action: #selector(handleCancel))
    }
    
    private func fetchUser() {
        Database.database().reference().child(USERS).observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject] {
                let user = User(dictionary: dictionary)
                user.id = snapshot.key
                self.users.append(user)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
            }
        }, withCancel: nil)
        
    }
    
    @objc private func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NEW_MESSAGE_CELL_ID, for: indexPath) as! UserCell
        
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        if let profileImageUrl = user.profileImageUrl {
            cell.profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true) {
            let user = self.users[indexPath.row]
            self.messagesController?.showChatControllerForUser(user: user)
            print(user.name)
        }
    }
    
 }
 
