//
//  NewChatController.swift
//  Messaging
//
//  Created by Roberto Pirck Valdés on 18/9/17.
//  Copyright © 2017 Roberto Pirck Valdés. All rights reserved.
//

import UIKit
import Firebase

class NewChatController: UITableViewController {
    
    var users = [User]()
    var usersIds = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "New chat"
        setUpTableView()
        setUpNavigationController()
        setUpInfo()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setUpTableView(){
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CellId")
        tableView.tableFooterView = UIView()
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
        navigationController?.popViewController(animated: true)
    }
    
    func setUpInfo(){
        guard let currentId = Auth.auth().currentUser?.uid else {
            print("Couldn't get current user uid")
            return
        }
        let ref = Database.database().reference()
        self.users.removeAll()
        self.usersIds.removeAll()
        self.tableView.reloadData()
        ref.child("Users").observe(.childAdded , with: { (snapshot) in
            // Get user value
            guard let value = snapshot.value as? NSDictionary else {
                print("Couldn't get value from snapshot")
                return
            }
            if !self.usersIds.contains((value["uid"] as? String)!) && value["uid"] as? String != currentId {
                
                //                if value.value(forKey: "userId") as? String == userID {
                self.usersIds.append((value["uid"] as? String)!)
                self.users.append(User(dictionary: value as! [String : Any]))
                //                }
            }
            self.tableView.reloadData()
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }

    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellId", for: indexPath)
        cell.textLabel?.text = self.users[indexPath.row].username
        return cell

    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chat = ChatController(collectionViewLayout: UICollectionViewFlowLayout())
        chat.user = self.users[indexPath.row]
        self.navigationController?.pushViewController(chat, animated: true)
    }

}
