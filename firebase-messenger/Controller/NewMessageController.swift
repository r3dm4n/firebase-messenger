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

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "NEW MESSAGE"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: CANCEL, style: .plain, target: self, action: #selector(handleCancel))
        
        fetchUser()
      
    }
    
    private func fetchUser() {
        Database.database().reference().child(USERS).observe(.childAdded, with: { (snapshot) in
            if let dictionary = snapshot.value as? [String: Any] {
                let user = User()
                user.name = dictionary["name"] as? String
                user.email = dictionary["email"] as? String
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
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: NEW_MESSAGE_CELL_ID)
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        return cell
    }

}
