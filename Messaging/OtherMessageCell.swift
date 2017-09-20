//
//  OtherMessageCell.swift
//  Messaging
//
//  Created by Roberto Pirck Valdés on 19/9/17.
//  Copyright © 2017 Roberto Pirck Valdés. All rights reserved.
//

import UIKit

class OtherMessageCell: UICollectionViewCell {
    
    var cellBackgroundWidthConstraint: NSLayoutConstraint?
    
    var cellBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 229/255, green: 229/255, blue: 234/255, alpha: 1)
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var messageTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .clear
        textView.textColor = .black
        textView.isEditable = false
        textView.isSelectable = false
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    
    var dateLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(cellBackgroundView)
        cellBackgroundView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        cellBackgroundView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        cellBackgroundView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        cellBackgroundWidthConstraint = cellBackgroundView.widthAnchor.constraint(equalToConstant: 200)
        cellBackgroundWidthConstraint?.isActive = true
        
        addSubview(messageTextView)
        messageTextView.rightAnchor.constraint(equalTo: cellBackgroundView.rightAnchor, constant: -8).isActive = true
        messageTextView.leftAnchor.constraint(equalTo: cellBackgroundView.leftAnchor, constant: 8).isActive = true
        messageTextView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        messageTextView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        
        addSubview(dateLabel)
        dateLabel.leftAnchor.constraint(equalTo: cellBackgroundView.rightAnchor, constant: 4).isActive = true
        dateLabel.bottomAnchor.constraint(equalTo: self.cellBackgroundView.bottomAnchor).isActive = true
        dateLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        dateLabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
