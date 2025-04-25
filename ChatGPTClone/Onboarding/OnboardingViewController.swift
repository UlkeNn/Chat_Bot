//
//  ViewController.swift
//  ChatGPTClone
//
//  Created by Ulgen on 6.03.2025.
//

import UIKit

class OnboardingViewController: UIViewController {


    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    var onboardings: [Onboarding] = []
    
    var currentPage = 0 {
        didSet {
            if currentPage == onboardings.count - 1  {
                nextButton.setTitle( "Get Started", for: .normal)
            }else {
                nextButton.setTitle( "Next", for: .normal)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        onboardings = [Onboarding(image: UIImage(named: "onb1")!,title:"Welcome", subtitle: "its easy to talking to AI with CHAT GPT Clone"),Onboarding(image: UIImage(named: "onb2")!,title:"Let's go!", subtitle: "Chat GPT Clone ready to grow your life for next level")]
        
        
        
        
        
    }
    

    @IBAction func nextButtonDidTapped(_ sender: Any) {
        let nextPage = currentPage + 1
        
        if nextPage < onboardings.count {
            let indexPath = IndexPath(item: nextPage, section: 0)
            currentPage = nextPage
            pageControl.currentPage = nextPage
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }else {
            //deneme
            //print("GO TO CHATVC")
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let chatVC = storyboard.instantiateViewController(withIdentifier: "ChatViewController") as! ChatViewController
            self.navigationController?.pushViewController(chatVC, animated: true)
        }
        
    }
    
}

extension OnboardingViewController: UICollectionViewDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return onboardings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnBoardingCell", for: indexPath) as! OnBoardingCell
        let onboarding = onboardings[indexPath.row]
        cell.configure (onboarding: onboarding)//dikkat burada kaldın
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.frame.size
        return CGSize(width: size.width, height: size.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
        pageControl.currentPage = currentPage
    }
    
    //bunu ne ara ekledik ekleyecektik hatırlamaıyom
    func collectionView(_collectionView: UICollectionView,layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
