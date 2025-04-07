//
//  ReviewViewController.swift
//  FoodPin
//
//  Created by Ken on 2025/4/3.
//

import UIKit

class ReviewViewController: UIViewController {
    
    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var closeButton: UIButton!
    
    @IBOutlet var rateButtons: [UIButton]!
    
    var restaurant = Restaurant()

    override func viewDidLoad() {
        super.viewDidLoad()
        backgroundImageView.image = restaurant.image
        
        //Applying the blur effect
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        backgroundImageView.addSubview(blurEffectView)
        
        let moveRightTransform = CGAffineTransform.init(translationX: 600, y: 0)
        let scaleUpTransform = CGAffineTransform.init(scaleX: 5.0, y: 5.0)
        let moveScaleTransform = scaleUpTransform.concatenating(moveRightTransform)
        
        for rateButton in rateButtons {
            rateButton.transform = moveScaleTransform
            rateButton.alpha = 0
        }
        
        let moveTopTransform = CGAffineTransform.init(translationX: 0, y: -600)
        closeButton.transform = moveTopTransform
    }
    
    override func viewWillAppear(_ animated: Bool) {
        for i in 0..<rateButtons.count {
            UIView.animate(withDuration: 0.4, delay: 0.1 + (0.05 * Double(i)), options: [], animations: {
            self.rateButtons[i].alpha = 1.0
            self.rateButtons[i].transform = .identity
            }, completion: nil)
        }
//        UIView.animate(withDuration: 0.4, delay: 0.1, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.3,options: [], animations: {
//        self.rateButtons[0].alpha = 1.0
//        self.rateButtons[0].transform = .identity
//        }, completion: nil)
//        UIView.animate(withDuration: 0.4, delay: 0.15, options: [], animations: {
//        self.rateButtons[1].alpha = 1.0
//            self.rateButtons[1].transform = .identity
//        }, completion: nil)
//        UIView.animate(withDuration: 0.4, delay: 0.2, options: [], animations: {
//        self.rateButtons[2].alpha = 1.0
//            self.rateButtons[2].transform = .identity
//        }, completion: nil)
//        UIView.animate(withDuration: 0.4, delay: 0.25, options: [], animations: {
//        self.rateButtons[3].alpha = 1.0
//            self.rateButtons[3].transform = .identity
//        }, completion: nil)
//        UIView.animate(withDuration: 0.4, delay: 0.3, options: [], animations: {
//        self.rateButtons[4].alpha = 1.0
//            self.rateButtons[4].transform = .identity
//        }, completion: nil)
        
        UIView.animate(withDuration: 0.4, delay: 0.2, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.6) {
            self.closeButton.transform = .identity
        }
    }

}
