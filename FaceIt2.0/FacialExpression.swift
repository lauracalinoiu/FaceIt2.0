//
//  FacialExpresion.swift
//  FaceIt2.0
//
//  Created by Laura Calinoiu on 31/07/16.
//  Copyright © 2016 3smurfs. All rights reserved.
//

import Foundation
struct FacialExpression{
  
  enum Eyes: Int{
    case Open
    case Close
    case Squinting
  }
  
  enum Eyebrows: Int{
    case Relaxed
    case Neutral
    case Furrowed
    
    func moreRelaxedBow() -> Eyebrows{
      return Eyebrows(rawValue: rawValue - 1) ?? .Relaxed
    }
    
    func moreFurrowedBow() -> Eyebrows{
      return Eyebrows(rawValue: rawValue + 1) ?? .Furrowed
    }
  }
  
  enum Mouth: Int{
    case Frown
    case Smirk
    case Neutral
    case Grin
    case Smile
    
    func moreSaddness() -> Mouth{
      return Mouth(rawValue: rawValue - 1) ?? .Frown
    }
    
    func moreHappiness() -> Mouth{
      return Mouth(rawValue: rawValue + 1) ?? .Smile
    }
  }
  
  var eyes: Eyes
  var eyebrows: Eyebrows
  var mouth: Mouth
}