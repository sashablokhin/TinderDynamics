//
//  ViewController.swift
//  TinderDynamics
//
//  Created by Alexander Blokhin on 24.02.16.
//  Copyright © 2016 Alexander Blokhin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var panRecognizer: UIPanGestureRecognizer!
    @IBOutlet var dialogView: UIView!
    @IBOutlet var avatarImageView: UIImageView!
    
    var animator: UIDynamicAnimator!
    var attachmentBehavor: UIAttachmentBehavior!
    var gravityBehavor: UIGravityBehavior!
    var snapBehavor: UISnapBehavior?
    
    let images = ["user1", "user2", "user3", "user4"]
    var number = 0
    
    @IBAction func handleGesture(sender: UIPanGestureRecognizer) {
        let location = sender.locationInView(view)
        let boxLocation = sender.locationInView(dialogView)
        
        if sender.state == .Began {
            
            if snapBehavor != nil {
                animator.removeBehavior(snapBehavor!)
            }
            
            let centerOffset = UIOffsetMake(boxLocation.x - CGRectGetMidX(dialogView.bounds), boxLocation.y - CGRectGetMidY(dialogView.bounds))
            
            attachmentBehavor = UIAttachmentBehavior(item: dialogView, offsetFromCenter: centerOffset, attachedToAnchor: location)
            attachmentBehavor.frequency = 0
            
            animator.addBehavior(attachmentBehavor)
            
        } else if sender.state == .Changed {
            
            attachmentBehavor.anchorPoint = location
            
        } else if sender.state == .Ended {
            animator.removeBehavior(attachmentBehavor)
            
            snapBehavor = UISnapBehavior(item: dialogView, snapToPoint: view.center)
            
            animator.addBehavior(snapBehavor!)
            
            let translation = sender.translationInView(view)
            
            if translation.y > 100 {
                animator.removeAllBehaviors()
                
                let gravity = UIGravityBehavior(items: [dialogView])
                gravity.gravityDirection = CGVectorMake(0, 10)
                
                animator.addBehavior(gravity)
                
                delay(0.3) {
                    self.refreshView()
                }
            }
        }
    }
    
    
    
    func refreshView() {
        number++
        
        if number == images.count {
            number = 0
        }
        
        animator.removeAllBehaviors()
        
        snapBehavor = UISnapBehavior(item: self.dialogView, snapToPoint: self.view.center)
        attachmentBehavor.anchorPoint = self.view.center
        
        dialogView.center = self.view.center
        viewDidAppear(true)
    }
    
    
    func delay(delay: Double, closure: () -> ()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let scale = CGAffineTransformMakeScale(0.5, 0.5)
        let translate = CGAffineTransformMakeTranslation(0, -200)
        
        dialogView.transform = CGAffineTransformConcat(scale, translate)
        
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [], animations: { () -> Void in
            let scale = CGAffineTransformMakeScale(1, 1)
            let translate = CGAffineTransformMakeTranslation(0, 0)
            
            self.dialogView.transform = CGAffineTransformConcat(scale, translate)
            }, completion: nil)
        
        avatarImageView.image = UIImage(named: images[number])
        
        dialogView.alpha = 1
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        animator = UIDynamicAnimator(referenceView: view)
        
        dialogView.alpha = 0
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

