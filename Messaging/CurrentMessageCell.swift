//
//  CurrentMessageCell.swift
//  Messaging
//
//  Created by Roberto Pirck Valdés on 19/9/17.
//  Copyright © 2017 Roberto Pirck Valdés. All rights reserved.
//

import UIKit

class CurrentMessageCell: UICollectionViewCell {
    var cellBackgroundWidthConstraint: NSLayoutConstraint?
    
    var cellBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 14/255, green: 136/255, blue: 244/255, alpha: 1)
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var messageTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.textColor = .white
        textView.isEditable = false
        textView.isSelectable = false
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(cellBackgroundView)
        cellBackgroundView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        cellBackgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        cellBackgroundView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        cellBackgroundWidthConstraint = cellBackgroundView.widthAnchor.constraint(equalToConstant: 200)
        cellBackgroundWidthConstraint?.isActive = true
        
        addSubview(messageTextView)
        messageTextView.leftAnchor.constraint(equalTo: cellBackgroundView.leftAnchor, constant: 8).isActive = true
        messageTextView.rightAnchor.constraint(equalTo: cellBackgroundView.rightAnchor).isActive = true
        messageTextView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        messageTextView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
