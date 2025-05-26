//
//  SettingsViewController.swift
//  ChatGPTClone
//
//  Created by Ulgen on 15.05.2025.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var getPremiumView: UIView!
    @IBOutlet weak var settingsView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Settings"
        settingsView.layer.borderColor = UIColor( red : 74/255, green : 160/255, blue: 129/255, alpha: 0.32 ).cgColor
        settingsView.layer.borderWidth = 1
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(getPremiumViewTapped))
        getPremiumView.addGestureRecognizer(tapGesture)
        
    }
    

    @objc func getPremiumViewTapped() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let premiumVC = storyboard.instantiateViewController(withIdentifier: "PremiumViewController") as! PremiumViewController
        self.navigationController?.pushViewController(premiumVC, animated: true)
        
    }
}
