//
//  FaceView.swift
//  FaceIt2.0
//
//  Created by Laura Calinoiu on 30/07/16.
//  Copyright © 2016 3smurfs. All rights reserved.
//

import UIKit

@IBDesignable
class FaceView: UIView {
  
  @IBInspectable
  var scale: CGFloat = 0.9 { didSet { setNeedsDisplay() } }
  
  @IBInspectable
  var mouthCourvature: CGFloat = 10 { didSet { setNeedsDisplay() } }
  
  @IBInspectable
  var eyesClosed: Bool = false { didSet { setNeedsDisplay() } }
  
  @IBInspectable
  var eyebrowsTilt: Float = -1 { didSet { setNeedsDisplay() } }
  
  @IBInspectable
  var lineWidth: CGFloat = 5.0 { didSet { setNeedsDisplay() } }
  
  @IBInspectable
  var color: UIColor = UIColor.blueColor() { didSet { setNeedsDisplay() } }
  
  private var skullRadius: CGFloat{
    return min(bounds.size.width, bounds.size.height) / 2 * scale
  }
  
  private var skullCenter: CGPoint{
    return CGPoint(x: bounds.midX, y: bounds.midY)
  }
  
  func changeScale(recognizer: UIPinchGestureRecognizer){
    switch recognizer.state{
    case .Changed, .Ended:
      scale *= recognizer.scale
      recognizer.scale = 1
    default: break
    }
  }
  
  private struct Ratios{
    static let SkullCenterToEyeOffset: CGFloat = 3.0
    static let SkullRadiusToEyeRadius: CGFloat = 10
    static let SkullRadiusToMouthWidth: CGFloat = 1
    static let SkullRadiusToMouthHeight: CGFloat = 3
    static let SkullRadiusToMouthOffset: CGFloat = 3
    static let SkullCenterToEyeBrowsOffset: CGFloat = 3
  }
  
  enum Eye{
    case Left
    case Right
  }
  
  private func pathForCircleAt(center: CGPoint, radius: CGFloat) -> UIBezierPath{
    let path = UIBezierPath(arcCenter: center, radius: radius, startAngle: 0.0, endAngle: CGFloat(2 * M_PI), clockwise: true)
    path.lineWidth = lineWidth
    return path
  }
  
  private func centerForEye(eye: Eye) -> CGPoint{
    let eyeOffset = skullRadius / Ratios.SkullCenterToEyeOffset
    switch eye{
    case .Left:
      return CGPoint(x: skullCenter.x - eyeOffset, y: skullCenter.y - eyeOffset)
    case .Right:
      return CGPoint(x: skullCenter.x + eyeOffset, y: skullCenter.y - eyeOffset)
    }
  }
  
  private func pathForEye(eye: Eye) -> UIBezierPath{
    
    let centerOfEye = centerForEye(eye)
    let radius = skullRadius / Ratios.SkullRadiusToEyeRadius
    
    if !eyesClosed{
      return pathForCircleAt(centerOfEye, radius: radius)
    }
    
    let pathForEyesClosed = UIBezierPath()
  
    pathForEyesClosed.moveToPoint(CGPoint(x: centerOfEye.x - radius, y: centerOfEye.y))
    pathForEyesClosed.addLineToPoint(CGPoint(x: centerOfEye.x + radius, y: centerOfEye.y))
    pathForEyesClosed.lineWidth = lineWidth
    
    return pathForEyesClosed
  }
  
  private func pathForEyebrows(eye: Eye) -> UIBezierPath{
    //rectangle dimensions
    let eyebrowsWidth = skullRadius / Ratios.SkullRadiusToEyeRadius * 2
    let eyebrowsHeight = eyebrowsWidth / 2
    let eyebrowsOffsetX = skullRadius / Ratios.SkullCenterToEyeBrowsOffset * 3 / 2
    let eyebrowsTiltOffset = CGFloat(min(1, max(-1, eyebrowsTilt))) * eyebrowsHeight
    
    var firstPoint = CGPoint(x: 0.0, y: 0.0), secondPoint = CGPoint(x: 0.0, y: 0.0)
    switch eye{
    case .Left:
      firstPoint = CGPoint(x: center.x - eyebrowsOffsetX, y: center.y - eyebrowsOffsetX - eyebrowsHeight)
      secondPoint = CGPoint(x: firstPoint.x + eyebrowsWidth, y: firstPoint.y - eyebrowsTiltOffset)
    case .Right:
      firstPoint = CGPoint(x: center.x + eyebrowsOffsetX, y: center.y - eyebrowsOffsetX - eyebrowsHeight)
      secondPoint = CGPoint(x: firstPoint.x - eyebrowsWidth, y: firstPoint.y - eyebrowsTiltOffset)
    }
    
    let eyebrowPath = UIBezierPath()
    eyebrowPath.moveToPoint(firstPoint)
    eyebrowPath.addLineToPoint(secondPoint)
    eyebrowPath.lineWidth = lineWidth
    
    return eyebrowPath
  }
  
  private func pathForMouth() -> UIBezierPath{
    let mouthOffset = skullRadius / Ratios.SkullRadiusToMouthOffset
    let mouthWidth = skullRadius / Ratios.SkullRadiusToMouthWidth
    let mouthHeight = skullRadius / Ratios.SkullRadiusToMouthHeight
    
    let smileOffset: CGFloat = CGFloat(max(-1, min(mouthCourvature, 1))) * mouthHeight
    
    let mouthStart = CGPoint(x: skullCenter.x - mouthWidth / 2, y: skullCenter.y + mouthOffset)
    let mouthCP1 = CGPoint(x: mouthStart.x + mouthWidth / 3, y: mouthStart.y + smileOffset)
    let mouthCP2 = CGPoint(x: mouthStart.x + 2 * mouthWidth / 3, y: mouthStart.y + smileOffset)
    let mouthEnd = CGPoint(x: mouthStart.x + mouthWidth, y: mouthStart.y)
    
    let mouthPath = UIBezierPath()
    mouthPath.moveToPoint(mouthStart)
    mouthPath.addCurveToPoint(mouthEnd, controlPoint1: mouthCP1, controlPoint2: mouthCP2)
    
    mouthPath.lineWidth = lineWidth
    return mouthPath
  }
  
  override func drawRect(rect: CGRect) {
    color.set()
    pathForCircleAt(skullCenter, radius: skullRadius).stroke()
    pathForEye(.Left).stroke()
    pathForEye(.Right).stroke()
    pathForMouth().stroke()
    pathForEyebrows(.Left).stroke()
    pathForEyebrows(.Right).stroke()
  }
}
