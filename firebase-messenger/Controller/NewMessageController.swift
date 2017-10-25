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
    
    let users = []()

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "NEW MESSAGE"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: CANCEL, style: .plain, target: self, action: #selector(handleCancel))
        
        fetchUser()
      
    }
    
    private func fetchUser() {
        Database.database().reference().child(USERS).observe(.childAdded, with: { (snapshot) in
            print(snapshot)
        }, withCancel: nil)
    }
    
    @objc private func handleCancel() {
        dismiss(animated: true, completion: nil)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: NEW_MESSAGE_CELL_ID)
        cell.textLabel?.text = "test test test"
        return cell
    }

}
