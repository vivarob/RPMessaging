//
//  ChatCell.swift
//  Messaging
//
//  Created by Roberto Pirck Valdés on 19/9/17.
//  Copyright © 2017 Roberto Pirck Valdés. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell {
    
    var usernameLabel:  UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var lastMessageLabel:  UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(usernameLabel)
        usernameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 6).isActive = true
        usernameLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 16).isActive = true
        usernameLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        usernameLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        addSubview(lastMessageLabel)
        lastMessageLabel.topAnchor.constraint(equalTo: self.usernameLabel.bottomAnchor, constant: 4).isActive = true
        lastMessageLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        lastMessageLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        lastMessageLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
