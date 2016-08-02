//
//  ViewController.swift
//  FaceIt2.0
//
//  Created by Laura Calinoiu on 30/07/16.
//  Copyright © 2016 3smurfs. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  var facialExpression = FacialExpression(eyes: .Open, eyebrows: .Furrowed, mouth: .Smile){
    didSet{
      updateUI()
    }
  }
  
  var mouthCurvature: [FacialExpression.Mouth : CGFloat] = [.Frown: -1,
                                                            .Smirk : -0.5, .Neutral: 0.0, .Grin: 0.5, .Smile: 1.0]
  var eyebrowsDict: [FacialExpression.Eyebrows : Float] = [.Relaxed: 1, .Neutral: 0, .Furrowed: -1]
  
  @IBOutlet weak var faceView: FaceView!{
    didSet{
      faceView.addGestureRecognizer(UIPinchGestureRecognizer(target: faceView, action: #selector(FaceView.changeScale(_:))))
      
      let happierGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.increaseHappiness))
      happierGestureRecognizer.direction = .Up
      faceView.addGestureRecognizer(happierGestureRecognizer)
      
      let sadderGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(ViewController.decreaseHappiness))
      sadderGestureRecognizer.direction = .Down
      faceView.addGestureRecognizer(sadderGestureRecognizer)
      
      updateUI()
    }
  }
  
  func increaseHappiness(){
    facialExpression.mouth = facialExpression.mouth.moreHappiness()
  }
  
  func decreaseHappiness(){
    facialExpression.mouth = facialExpression.mouth.moreSaddness()
  }
  
  @IBAction func toggleEyes(recognizer: UITapGestureRecognizer) {
    switch facialExpression.eyes{
    case .Open: facialExpression.eyes = .Close
    case .Close: facialExpression.eyes = .Open
    default: break
    }
  }
  
  func updateUI(){
    switch facialExpression.eyes {
    case .Open: faceView.eyesClosed = false
    case .Close: faceView.eyesClosed = true
    case .Squinting: faceView.eyesClosed = true
    }
    
    faceView.eyebrowsTilt = eyebrowsDict[facialExpression.eyebrows] ?? 0.0
    faceView.mouthCourvature = mouthCurvature[facialExpression.mouth] ?? 0.0
  }
}

