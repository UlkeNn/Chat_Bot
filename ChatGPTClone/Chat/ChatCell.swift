//
//  ChatCell.swift
//  ChatGPTClone
//
//  Created by Ulgen on 18.03.2025.
//

import UIKit

class ChatCell: UITableViewCell {

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var bubbleView: UIView!
    
    @IBOutlet weak var leftConstraint: NSLayoutConstraint!
    @IBOutlet weak var rightConstraint: NSLayoutConstraint!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(message: Message){//public olmasın
        messageLabel.text = message.content
        
        let text = message.content
        
        if !text.isEmpty {
            let widthWalue = text.estimateFrameForText(text).width
            
        if widthWalue < 35 {
            widthConstraint.constant = 65
            }else {
                widthConstraint.constant = widthWalue + 30
        }
            
        }
        
        if message.role == "user"{
            bubbleView.backgroundColor = .ligthGreen
            rightConstraint.constant = 20
            leftConstraint.constant = UIScreen.main.bounds.width - widthConstraint.constant - rightConstraint.constant
            messageLabel.textColor = .white
            
            
        }else{
            bubbleView.backgroundColor = UIColor(red: 1,green: 1, blue: 1,alpha: 0.1)
            leftConstraint.constant = 20
            rightConstraint.constant = UIScreen.main.bounds.width - widthConstraint.constant - leftConstraint.constant
            messageLabel.textColor = .white
            
        }
        
        
    }
    
    
    
    
    

}
