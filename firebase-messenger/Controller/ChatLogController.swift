//
//  ChatLogController.swift
//  firebase-messenger
//
//  Created by r3d on 28/10/2017.
//  Copyright © 2017 Alexandru Corut. All rights reserved.
//

import UIKit
import Firebase

class ChatLogController: UICollectionViewController, UITextFieldDelegate, UICollectionViewDelegateFlowLayout {
    
    let cellId = "cellId"
    
    var user: User? {
        didSet {
            navigationItem.title = user?.name
            observeMessages()
        }
    }
    
    private func observeMessages() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let userMessagesRef = BASE_REF.child(USER_MESSAGES).child(uid)
        
        userMessagesRef.observe(.childAdded) { (snapshot) in
            let messageId = snapshot.key
            let messagesRef = BASE_REF.child(MESSAGES).child(messageId)
            messagesRef.observe(.value, with: { (snapshot) in
                guard let dictionary = snapshot.value as? [String: AnyObject] else { return }
                let message = Message(dictionary: dictionary)
                print(message.text)
            })
        }
    }
    
    private let bottomContainerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let separatorLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(SEND, for: .normal)
        button.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = ENTER_MESSAGE
        textField.delegate = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = .white
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        setupInputComponents()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath)
        cell.backgroundColor = .blue
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 80)
    }
    private func setupInputComponents() {
        
        view.addSubview(bottomContainerView)
        view.addSubview(sendButton)
        view.addSubview(inputTextField)
        view.addSubview(separatorLineView)
        
        setupBottomContainerView()
        setupSeparatorLineView(bottomContainerView: bottomContainerView)
        setupSendButton(bottomContainerView: bottomContainerView)
        setupInputTextField(bottomContainerView: bottomContainerView)
    }
    
    @objc private func handleSend() {
        let ref = Database.database().reference().child(MESSAGES)
        let childRef = ref.childByAutoId()
        guard let fromId = Auth.auth().currentUser?.uid else { return }
        guard let toId = user?.id else { return }
        let values = [TEXT: inputTextField.text as AnyObject,
                      FROM_ID : fromId as AnyObject,
                      TO_ID : toId as AnyObject,
                      TIMESTAMP : getTimestamp() as AnyObject]
        
        childRef.updateChildValues(values) { (error, ref) in
            if error != nil {
                print(error ?? "")
                return
            }
            
            let userMessagesRef = Database.database().reference().child(USER_MESSAGES).child(fromId)
            let messageid = childRef.key
            userMessagesRef.updateChildValues([messageid: 1])
            
            let recipientUserMessages = Database.database().reference().child(USER_MESSAGES).child(toId)
            recipientUserMessages.updateChildValues([messageid: 1])
        }
    }
    
    func getTimestamp() -> String {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:MM:ss"
        let convertedDate: String = dateFormatter.string(from: currentDate)
        return convertedDate
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }
    
    private func setupBottomContainerView() {
        bottomContainerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        bottomContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        bottomContainerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        bottomContainerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    private func setupSeparatorLineView(bottomContainerView: UIView) {
        separatorLineView.bottomAnchor.constraint(equalTo: bottomContainerView.topAnchor).isActive = true
        separatorLineView.widthAnchor.constraint(equalTo: bottomContainerView.widthAnchor).isActive = true
        separatorLineView.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
    }
    
    private func setupSendButton(bottomContainerView: UIView) {
        sendButton.rightAnchor.constraint(equalTo: bottomContainerView.rightAnchor).isActive = true
        sendButton.centerYAnchor.constraint(equalTo: bottomContainerView.centerYAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
    }
    
    private func setupInputTextField(bottomContainerView: UIView) {
        inputTextField.leftAnchor.constraint(equalTo: bottomContainerView.leftAnchor, constant: 10).isActive = true
        inputTextField.centerYAnchor.constraint(equalTo: bottomContainerView.centerYAnchor).isActive = true
        inputTextField.widthAnchor.constraint(equalTo: bottomContainerView.widthAnchor, constant: -80).isActive = true
    }
    
  
}

