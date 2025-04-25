//
//  OnBoardingCell.swift
//  ChatGPTClone
//
//  Created by Ulgen on 16.03.2025.
//

import UIKit

class OnBoardingCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var subTitleLabel: UILabel!
    
    
    
    public func configure(onboarding : Onboarding){
        imageView.image = onboarding.image
        titleLabel.text = onboarding.title
        subTitleLabel.text = onboarding.subtitle
    }
    
    
}
