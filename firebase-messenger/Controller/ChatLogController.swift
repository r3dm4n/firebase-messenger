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
    
    private var containerViewBottomAnchor: NSLayoutConstraint?
    private let cellId = "cellId"
    private var messages = [Message]()
    
    var user: User? {
        didSet {
            navigationItem.title = user?.name
            observeMessages()
        }
    }
    
    private let bottomContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
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
        
        collectionView?.keyboardDismissMode = .interactive
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 58, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = .white
        collectionView?.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
        
        //        setupKeyboardObservers()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    private lazy var inputContainerView: UIView = {
        let containerView = UIView()
        containerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
        containerView.backgroundColor = .white
        
        setupInputComponents()
        return containerView
    }()
    
    override var inputAccessoryView: UIView? {
        get {
            return inputContainerView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func handleKeyboardWillShow(_ notification: Notification) {
        let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
        let keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
        
        containerViewBottomAnchor?.constant = -keyboardFrame!.height
        UIView.animate(withDuration: keyboardDuration!, animations: { self.view.layoutIfNeeded() })
    }
    
    @objc func handleKeyboardWillHide(_ notification: Notification) {
        containerViewBottomAnchor?.constant = 0
        
        let keyboardDuration = (notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as AnyObject).doubleValue
        
        containerViewBottomAnchor?.constant = 0
        UIView.animate(withDuration: keyboardDuration!, animations: { self.view.layoutIfNeeded() })
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
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatMessageCell
        let message = messages[indexPath.item]
        cell.textView.text = message.text
        
        //modify buuble's view width
        cell.bubbleViewWidthAnchor?.constant = estimatedFrameForText(text: message.text!).width + 32
        setupCell(cell: cell, message: message)
        
        return cell
    }
    
    private func setupCell(cell: ChatMessageCell, message: Message) {
        
        guard let profileImageUrl = self.user?.profileImageUrl else { return }
        cell.profileImageView.loadImageUsingCacheWithUrlString(profileImageUrl)
        
        if message.fromId == CURRENT_USER?.uid {
            //outgoing blue messages
            cell.bubbleView.backgroundColor = BLUE_MESSAGE_COLOR
            cell.textView.textColor = .white
            cell.profileImageView.isHidden = true
            cell.bubbleViewRightAnchor?.isActive = true
            cell.bubbleViewLeftAnchor?.isActive = false
            
        } else {
            //incoming grey messages
            cell.profileImageView.isHidden = false
            cell.bubbleViewRightAnchor?.isActive = false
            cell.bubbleViewLeftAnchor?.isActive = true
            cell.bubbleView.backgroundColor = GRAY_MESSAGE_COLOR
            cell.textView.textColor = .black
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 80
        if let text = messages[indexPath.item].text {
            height = estimatedFrameForText(text: text).height + 20
        }
        return CGSize(width: view.frame.width, height: height)
    }
    
    private func estimatedFrameForText(text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)], context: nil)
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
                
                if message.chatPartnerId() == self.user?.id {
                    self.messages.append(message)
                    self.collectionView?.reloadData()
                }
                
            })
        }
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
            
            self.inputTextField.text = nil
            
            let userMessagesRef = Database.database().reference().child(USER_MESSAGES).child(fromId)
            let messageid = childRef.key
            userMessagesRef.updateChildValues([messageid: 1])
            
            let recipientUserMessages = Database.database().reference().child(USER_MESSAGES).child(toId)
            recipientUserMessages.updateChildValues([messageid: 1])
        }
    }
    
    private func getTimestamp() -> String {
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
        containerViewBottomAnchor = bottomContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        containerViewBottomAnchor?.isActive = true
        
        bottomContainerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
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

