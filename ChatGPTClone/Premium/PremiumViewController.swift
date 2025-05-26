//
//  PremiumViewController.swift
//  ChatGPTClone
//
//  Created by Ulgen on 15.05.2025.
//

import UIKit

class PremiumViewController: UIViewController {
    @IBOutlet weak var weeklyView: UIView!
    @IBOutlet weak var monthlyView: UIView!
    @IBOutlet weak var yearlyView: UIView!
    private var indexPurchases = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
       
        switch indexPurchases{
        case 0:
            unSelectedView(view: weeklyView)
            unSelectedView(view: monthlyView)
            unSelectedView(view: yearlyView)
        case 1:
            selectedView(view: weeklyView)
            unSelectedView(view: monthlyView)
            unSelectedView(view: yearlyView)
        case 2:
            selectedView(view: monthlyView)
            unSelectedView(view: weeklyView)
            unSelectedView(view: yearlyView)
        case 3:
            selectedView(view: yearlyView)
            unSelectedView(view: weeklyView)
            unSelectedView(view: monthlyView)
        default:
            print ("layout error")
            break
        }
    }
    
    func setupUI(){
        unSelectedView(view: weeklyView)
        unSelectedView(view: monthlyView)
        unSelectedView(view: yearlyView)
    }
    
    func selectedView(view: UIView){
        addBorderViewBorderColor(view: view)
        view.backgroundColor = .none
    }
    
    func unSelectedView(view: UIView){
        view.layer.borderColor = UIColor(red: 1, green:1, blue: 1, alpha: 0.1 ).cgColor
        view.layer.borderWidth = 1
        view.backgroundColor = .none
    }
    func addBorderViewBorderColor(view: UIView){
        let gradient = UIImage.gradientImage(bounds: view.bounds, colors: [
            UIColor(red: 65/255, green: 109/255, blue: 25/255, alpha: 1.0),
            UIColor(red: 155/255, green: 207/255, blue: 83/255, alpha: 1.0)
        ])
        let gradientColor = UIColor(patternImage: gradient!)
        view.layer.borderColor = gradientColor.cgColor
        view.layer.borderWidth = 3
        
    }
    
    @IBAction func weeklyButtonDidTapped(_ sender: Any) {
        indexPurchases = 1
    }
    @IBAction func monthlyButtonDidTapped(_ sender: Any) {
        indexPurchases = 2
    }
    @IBAction func yearlyButtonDidTapped(_ sender: Any) {
        indexPurchases = 3
    }
    
}
