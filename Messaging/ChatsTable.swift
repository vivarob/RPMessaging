//
//  ChatsTable.swift
//  Messaging
//
//  Created by Roberto Pirck Valdés on 18/9/17.
//  Copyright © 2017 Roberto Pirck Valdés. All rights reserved.
//

import UIKit
import Firebase

class ChatsTable: UITableViewController {
    
    var chats = [Chat]()
    var chatsIds = [String]()
    var chatUsernames = [String:User]()


    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Chats"
        setUpNavigationController()
        setUpTableView()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpInfo()
    }


    func setUpNavigationController(){
        navigationController?.navigationBar.barTintColor = .blue
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white, NSFontAttributeName: UIFont(name: "HelveticaNeue-Bold", size: 20)!]
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(goToNewChat))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Log out", style: .plain, target: self, action: #selector(logOut))
    }
    
    func setUpTableView(){
        tableView.register(ChatCell.self, forCellReuseIdentifier: "CellId")
        tableView.tableFooterView = UIView()
    }
    
    func setUpInfo(){
        guard let currentId = Auth.auth().currentUser?.uid else {
            print("Couldn't get current user uid")
            return
        }
        
        let ref = Database.database().reference()
        self.chats.removeAll()
        self.chatsIds.removeAll()
        self.tableView.reloadData()
        ref.child("Chats").observe(.childAdded , with: { (snapshot) in
            // Get user value
            guard let value = snapshot.value as? NSDictionary else {
                print("Couldn't get value from snapshot")
                return
            }
            if !self.chatsIds.contains((value["id"] as? String)!) && (value["users"] as! [String]).contains(currentId){
                
                //                if value.value(forKey: "userId") as? String == userID {
                self.chatsIds.append((value["id"] as? String)!)
                self.chats.append(Chat(dictionary: value as! [String : Any]))
                let userId = (value["users"] as? [String])!.filter { $0 != currentId }
                let ref = Database.database().reference().child("Users")
                ref.observe(.childAdded , with: { (snapshot) in
                    // Get user value
                    guard let userValue = snapshot.value as? NSDictionary else {
                        print("Couldn't get value from snapshot")
                        return
                    }
                    if userValue["uid"] as? String == userId[0] {
                        self.chatUsernames[userId[0]] = User(dictionary: userValue as! [String : Any])
                        self.tableView.reloadData()
                    }
                    // ...
                }) { (error) in
                    print(error.localizedDescription)
                }
                //                }
            }
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    
    func logOut(){
        let savedAlert = UIAlertController(title: "Log out", message: "Do you really want to log out?", preferredStyle: .alert)
        savedAlert.addAction(UIAlertAction(title: "Log out", style: .destructive, handler: { (UIAlertAction) in
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                self.present(HomeView(), animated: false, completion: nil)
            } catch let signOutError as NSError {
                print ("Error signing out: \(signOutError)")
            } catch {
                print("Unknown error.")
            }
        }))
        savedAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (UIAlertAction) in
            
        }))
        self.present(savedAlert, animated: true){
            
        }
        
    }
    
    func goToNewChat(){
        navigationController?.pushViewController(NewChatController(), animated: true)
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellId", for: indexPath) as! ChatCell
        guard let currentId = Auth.auth().currentUser?.uid else {
            print("Couldn't get current user uid")
            return cell
        }
        let userId = chats[indexPath.row].users.filter { $0 != currentId }
        cell.usernameLabel.text = chatUsernames[userId[0]]?.username
        cell.lastMessageLabel.text = chats[indexPath.row].lastMessage
        cell.textLabel?.textColor = .black
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chat = ChatController(collectionViewLayout: UICollectionViewFlowLayout())
        let usersId = chats[indexPath.row].users
        guard let currentId = Auth.auth().currentUser?.uid else {
            print("Couldn't get current user uid")
            return
        }
        let userId = usersId.filter { $0 != currentId }
        let ref = Database.database().reference().child("Users")
        ref.observe(.childAdded , with: { (snapshot) in
            // Get user value
            guard let value = snapshot.value as? NSDictionary else {
                print("Couldn't get value from snapshot")
                return
            }
            if value["uid"] as? String == userId[0] {
                chat.user = User(dictionary: value  as! [String : Any])
                chat.chat = self.chats[indexPath.row]
                self.navigationController?.pushViewController(chat, animated: true)
            }
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
}

