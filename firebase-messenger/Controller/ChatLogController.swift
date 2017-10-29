//
//  ChatLogController.swift
//  firebase-messenger
//
//  Created by r3d on 28/10/2017.
//  Copyright © 2017 Alexandru Corut. All rights reserved.
//

import UIKit

class ChatLogController: UICollectionViewController {
    
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
        button.setTitle("Send", for: .normal)
        button.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter message"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Chat Log Controller"
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
        print(123)
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

