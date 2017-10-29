//
//  ChatLogController.swift
//  firebase-messenger
//
//  Created by r3d on 28/10/2017.
//  Copyright © 2017 Alexandru Corut. All rights reserved.
//

import UIKit
import Firebase

class ChatLogController: UICollectionViewController, UITextFieldDelegate {
    
    var user: User? {
        didSet {
            navigationItem.title = user?.name
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
        setupInputComponents()
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
        let fromId = Auth.auth().currentUser?.uid
        let toId = user?.id
        let values = [TEXT: inputTextField.text!,
                      FROM_ID : fromId,
                      TO_ID : toId,
                      TIMESTAMP : getTimestamp()]
        childRef.updateChildValues(values)
        
    }
    
    func getTimestamp() -> String {
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:MM"
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

