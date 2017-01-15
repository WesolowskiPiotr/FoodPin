//
//  ReviewViewController.swift
//  FoodPin
//
//  Created by Piotr Wesołowski on 28/12/16.
//  Copyright © 2016 Piotr Wesołowski. All rights reserved.
//

import UIKit

class ReviewViewController: UIViewController {

    @IBOutlet var backgroundImageView: UIImageView!
    @IBOutlet var restaurantImageView: UIImageView!
    @IBOutlet var containerView: UIView!
    
    @IBOutlet var closeButton: UIButton!
    
    var restaurantImage: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        backgroundImageView.addSubview(blurEffectView)
        
        //containerView.transform = CGAffineTransform.init(scaleX: 0, y: 0)
        //containerView.transform = CGAffineTransform.init(scaleX: 0, y: -1000)
        
        let scaleTransform = CGAffineTransform.init(scaleX: 0, y: 0)
        let translateTransform = CGAffineTransform.init(translationX: 0, y: -1000)
        let combineTransform = scaleTransform.concatenating(translateTransform)
        containerView.transform = combineTransform
        
        restaurantImageView.image = restaurantImage
        
        let closeButtonTransform = CGAffineTransform.init(translationX: 1000, y: 0)

        closeButton.transform = closeButtonTransform
    }

    override func viewDidAppear(_ animated: Bool) {
        // 1 transition
         UIView.animate(withDuration: 0.3, animations: {
           self.containerView.transform = CGAffineTransform.identity
         })
        
        UIView.animate(withDuration: 1.0, animations: {
            self.closeButton.transform = CGAffineTransform.identity
        })
        
        // UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.2, options: .curveEaseInOut, animations: {
        //    self.containerView.transform = CGAffineTransform.identity
        //    }, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
