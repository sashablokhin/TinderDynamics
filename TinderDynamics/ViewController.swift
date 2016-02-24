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
    
    var animator: UIDynamicAnimator!
    var attachmentBehavor: UIAttachmentBehavior!
    var gravityBehavor: UIGravityBehavior!
    var snapBehavor: UISnapBehavior?
    
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
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scale = CGAffineTransformMakeScale(0.5, 0.5)
        let translate = CGAffineTransformMakeTranslation(0, -200)
        
        dialogView.transform = CGAffineTransformConcat(scale, translate)
        
        UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [], animations: { () -> Void in
            let scale = CGAffineTransformMakeScale(1, 1)
            let translate = CGAffineTransformMakeTranslation(0, 0)
            
            self.dialogView.transform = CGAffineTransformConcat(scale, translate)
            }, completion: nil)
        
        animator = UIDynamicAnimator(referenceView: view)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

