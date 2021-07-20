//
//  TransactionCell.swift
//  Spent
//
//  Created by Дарья Яровая on 17.07.2021.
//

import UIKit

class TransactionCell: UITableViewCell {
    
    var transaction : Transaction? {
        didSet {
            amountLabel.text = transaction?.amount
            commentLabel.text = transaction?.comment
            if let comment = commentLabel.text {
                commentLabel.text = comment
            }
            
            timeLabel.text = transaction?.time
        }
    }
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = .left
        return label
    }()
    
    private let commentLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .left
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .right
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(amountLabel)
        addSubview(commentLabel)
        addSubview(timeLabel)
        
        let stackView = UIStackView(arrangedSubviews: [amountLabel,commentLabel])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 5
        addSubview(stackView)
        stackView.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: timeLabel.leftAnchor, paddingTop: 10, paddingLeft: 20, paddingBottom: 5, paddingRight: -20, width: 0, height: 60, enableInsets: false)
        
        timeLabel.anchor(top: topAnchor, left: nil, bottom: bottomAnchor, right: rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 5, paddingRight: 5, width: 90, height: 0, enableInsets: false)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
