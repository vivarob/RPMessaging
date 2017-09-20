//
//  ChatController.swift
//  Messaging
//
//  Created by Roberto Pirck Valdés on 18/9/17.
//  Copyright © 2017 Roberto Pirck Valdés. All rights reserved.
//

import UIKit
import Firebase

class ChatController: UICollectionViewController, UICollectionViewDelegateFlowLayout, UITextFieldDelegate{
    
    var writtingViewBottomConstraint: NSLayoutConstraint?
    
    var messages = [Message]()
    var messagesIds = [String]()
    var timer = Timer()
    var user: User? {
        didSet {
            self.title = user?.username
        }
    }
    var chat: Chat?
    
    var writtingTextfield: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter your text here!"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.contentInset = UIEdgeInsetsMake(8, 0, 58, 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        collectionView?.backgroundColor = .white
        collectionView?.register(CurrentMessageCell.self, forCellWithReuseIdentifier: "CellId")
        collectionView?.register(OtherMessageCell.self, forCellWithReuseIdentifier: "CellId2")
        setUpNavigationController()
        setUpView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        chat = Chat(dictionary: [:])
        getChat()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setUpNavigationController(){
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "HelveticaNeue-Bold", size: 20)!]

        let backButton = UIButton.init(type: .custom)
        backButton.setImage(#imageLiteral(resourceName: "backArrow"), for: UIControlState.normal)
        backButton.frame = CGRect.init(x: 0, y: 0, width: 12, height: 20)
        backButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        //
        
        let leftButtonItem = UIBarButtonItem.init(customView: backButton)
        navigationItem.leftBarButtonItem = leftButtonItem
    }
    
    func dismissVC(){
        navigationController?.popToRootViewController(animated: true)
    }
    
    func getChat(){
        let ref = Database.database().reference()
        ref.child("Chats").observe(.childAdded , with: { (snapshot) in
            // Get user value
            guard let value = snapshot.value as? NSDictionary else {
                print("Couldn't get value from snapshot")
                return
            }
            guard let currentId = Auth.auth().currentUser?.uid else {
                print("Couldn't get current user uid")
                return
            }
            
            guard let userId = self.user?.uid else {
                print("Couldn't get current user uid")
                return
            }
            
            if (value["users"] as? [String])!.contains(userId) && (value["users"] as? [String])!.contains(currentId) {
                self.chat = Chat(dictionary: value  as! [String : Any])
                self.timer.invalidate()
                self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.getChat), userInfo: nil, repeats: false)
                self.getMessages()
            }
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func getMessages(){
        let ref = Database.database().reference()
        self.collectionView?.reloadData()
        ref.child("Messages").observe(.childAdded , with: { (snapshot) in
            // Get user value
            guard let value = snapshot.value as? NSDictionary else {
                print("Couldn't get value from snapshot")
                return
            }
            if !self.messagesIds.contains((value["id"] as? String)!) && (self.chat?.messages.contains((value["id"] as? String)!))! {
                    
                //                if value.value(forKey: "userId") as? String == userID {
                self.messagesIds.append((value["id"] as? String)!)
                self.messages.append(Message(dictionary: value as! [String : Any]))
                self.collectionView?.reloadData()
                let item = self.collectionView(self.collectionView!, numberOfItemsInSection: 0) - 1
                let lastItemIndex = IndexPath(item: item, section: 0)
                self.collectionView?.scrollToItem(at: lastItemIndex, at: UICollectionViewScrollPosition.top, animated: false)

                                //                }
            }
            
            
            

            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    func setUpView(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let writtingView = UIView()
        writtingView.backgroundColor = .white
        writtingView.translatesAutoresizingMaskIntoConstraints  = false
        
        view.addSubview(writtingView)
        writtingView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        writtingView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        writtingViewBottomConstraint = writtingView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        writtingViewBottomConstraint?.isActive = true
        writtingView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let sendButton = UIButton(type: .system)
        sendButton.setTitle("Send", for: .normal)
        sendButton.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        
        writtingView.addSubview(sendButton)
        sendButton.centerYAnchor.constraint(equalTo: writtingView.centerYAnchor).isActive = true
        sendButton.rightAnchor.constraint(equalTo: writtingView.rightAnchor).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        sendButton.heightAnchor.constraint(equalTo: writtingView.heightAnchor).isActive = true
    
        writtingTextfield.delegate = self
        
        writtingView.addSubview(writtingTextfield)
        writtingTextfield.centerYAnchor.constraint(equalTo: writtingView.centerYAnchor).isActive = true
        writtingTextfield.leftAnchor.constraint(equalTo: writtingView.leftAnchor, constant: 8).isActive = true
        writtingTextfield.rightAnchor.constraint(equalTo: sendButton.leftAnchor).isActive = true
        writtingTextfield.heightAnchor.constraint(equalTo: writtingView.heightAnchor).isActive = true
        
        
        let separatorView = UIView()
        separatorView.backgroundColor = UIColor(red: 220/245, green: 220/245, blue: 220/245, alpha: 1)
        separatorView.translatesAutoresizingMaskIntoConstraints  = false
        
        view.addSubview(separatorView)
        separatorView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        separatorView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        separatorView.bottomAnchor.constraint(equalTo: writtingView.topAnchor).isActive = true
        separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    func dismissKeyboard(){
        self.view.endEditing(true)
    }
    
    func handleSend(){
        guard let textToSend =  writtingTextfield.text?.trimmingCharacters(in: .whitespacesAndNewlines), textToSend != "" else {
            print("The message is empty")

            return
        }
        
        writtingTextfield.text = ""
        guard let currentId = Auth.auth().currentUser?.uid else {
            print("Couldn't get current user uid")
            return
        }
        
        guard let user = self.user else {
            print("Couldn't get current user uid")
            return
        }
        
        let messageRef = Database.database().reference().child("Messages").childByAutoId()
        let messageValues = ["text": textToSend, "id": messageRef.key, "userId": currentId, "timestamp": ServerValue.timestamp()] as [String : Any]
        messageRef.updateChildValues(messageValues)
        
        var chatRef = Database.database().reference().child("Chats")
        var chatId = ""
        if chat?.id == "Invalid id" {
            chatRef = chatRef.childByAutoId()
            chatId = chatRef.key
        } else {
            chatRef = chatRef.child((chat?.id)!)
            chatId = (chat?.id)!
        }
        
        var messagesArray = chat?.messages
        messagesArray?.append(messageRef.key)
        let chatValues = ["messages": messagesArray!, "id":chatId, "users": [currentId, user.uid], "lastMessage": textToSend] as [String : Any]
        chat = Chat(dictionary: chatValues)
        chatRef.updateChildValues(chatValues)

        let userRef = Database.database().reference().child("Users").child((user.uid))
        var chatsArray = user.chats
        if !(chatsArray.contains(chatRef.key)) {
            chatsArray.append(chatRef.key)
        }
        let userValues = ["chats": chatsArray]
        userRef.updateChildValues(userValues)

        
        let currentUserRef = Database.database().reference().child("Users").child(currentId)
        
        let ref = Database.database().reference().child("Users")
        ref.observe(.childAdded , with: { (snapshot) in
            // Get user value
            guard let value = snapshot.value as? NSDictionary else {
                print("Couldn't get value from snapshot")
                return
            }
            if value["uid"] as? String == currentId {
                let currentUser = User(dictionary: value  as! [String : Any])
                var myChatsArray = currentUser.chats
                if !(myChatsArray.contains(chatRef.key)) {
                    myChatsArray.append(chatRef.key)
                }
                let currentUserValues = ["chats": myChatsArray]
                currentUserRef.updateChildValues(currentUserValues)
            }
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue  else {
            print("Couldn't get keyboard size")
            return
        }
        
        collectionView?.contentInset = UIEdgeInsetsMake(8, 0, 58 + keyboardSize.height, 0)
        writtingViewBottomConstraint?.constant = -keyboardSize.height
        let item = self.collectionView(self.collectionView!, numberOfItemsInSection: 0) - 1
        let lastItemIndex = IndexPath(item: item, section: 0)
        self.collectionView?.scrollToItem(at: lastItemIndex, at: UICollectionViewScrollPosition.top, animated: false)

    }
    
    func keyboardWillHide(notification: NSNotification) {
        collectionView?.contentInset = UIEdgeInsetsMake(8, 0, 58, 0)
        writtingViewBottomConstraint?.constant = 0
    }
    
    func heightForText(text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 16)], context: nil)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var height: CGFloat = 50
        
        height = heightForText(text: messages[indexPath.row].text).height + 20
        
        return CGSize(width: collectionView.frame.width, height: height)

        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        if messages[indexPath.row].userId != Auth.auth().currentUser?.uid {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellId2", for: indexPath) as! OtherMessageCell
            cell.cellBackgroundWidthConstraint?.constant = heightForText(text: messages[indexPath.row].text).width + 32
            cell.messageTextView.text = messages[indexPath.row].text
            cell.dateLabel.text = dateFormatter.string(from: messages[indexPath.row].date)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CellId", for: indexPath) as! CurrentMessageCell
            cell.cellBackgroundWidthConstraint?.constant = heightForText(text: messages[indexPath.row].text).width + 32
            cell.messageTextView.text = messages[indexPath.row].text
            cell.dateLabel.text = dateFormatter.string(from: messages[indexPath.row].date)
            return cell
        }
    }

}
