//
//  EmotionViewController.swift
//  FaceIt2.0
//
//  Created by Laura Calinoiu on 02/08/16.
//  Copyright © 2016 3smurfs. All rights reserved.
//

import UIKit

class EmotionViewController: UIViewController {
  
  let expressions: [String: FacialExpression] = [
    "angry": FacialExpression(eyes: .Close, eyebrows: .Furrowed, mouth: .Frown),
    "happy": FacialExpression(eyes: .Open, eyebrows: .Neutral, mouth: .Smile),
    "worried": FacialExpression(eyes: .Open, eyebrows: .Relaxed, mouth: .Smirk),
    "mischievious": FacialExpression(eyes: .Open, eyebrows: .Furrowed, mouth: .Grin)]
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    var destination = segue.destinationViewController
    if let navCon = destination as? UINavigationController{
      destination = navCon.visibleViewController!
    }
    if let facevc = destination as? ViewController{
      if let identifier = segue.identifier{
        facevc.facialExpression = expressions[identifier]!
        if let button = sender as? UIButton{
          facevc.navigationItem.title = button.currentTitle
        }
      }
    }
  }
  
}
