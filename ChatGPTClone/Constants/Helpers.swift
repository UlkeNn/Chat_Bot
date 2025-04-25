//
//  Helpers.swift
//  ChatGPTClone
//
//  Created by Ulgen on 18.03.2025.
//

import UIKit

extension String {
    func estimateFrameForText(_ text: String)->CGRect{
        let size = CGSize(width: 300, height: 1000)
        let options: NSStringDrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading]
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17)], context: nil)
        
    }
}
