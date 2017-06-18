//
//  UIColor + Extension.swift
//  TBTitleView
//
//  Created by 西乡流水 on 17/4/14.
//  Copyright © 2017年 西乡流水. All rights reserved.
//

import UIKit

extension UIColor
{
     class func randomColor() -> UIColor
    {
        let red = CGFloat(arc4random_uniform(255))/CGFloat(255.0)
        let green = CGFloat( arc4random_uniform(255))/CGFloat(255.0)
        let blue = CGFloat(arc4random_uniform(255))/CGFloat(255.0)
        return UIColor.init(red:red, green:green, blue:blue , alpha: 1)
    }
    
    static func getColorRGB(color:UIColor) -> (r:CGFloat,g:CGFloat,b:CGFloat)
    {
        var r : CGFloat = 0
        var g : CGFloat = 0
        var b : CGFloat = 0
        color.getRed(&r, green: &g, blue: &b, alpha: nil)
        
        return (r,g,b)
    }
    
    static func getColorRGBDistance(firstColor : UIColor ,secondColor : UIColor) -> (r : CGFloat,g:CGFloat,b:CGFloat)
    {
        let firstColorRGB = UIColor.getColorRGB(color: firstColor)
        let secondColorRGB = UIColor.getColorRGB(color: secondColor)
        
        let r = (firstColorRGB.r - secondColorRGB.r)
        let g = (firstColorRGB.g - secondColorRGB.g)
        let b = (firstColorRGB.b - secondColorRGB.b)
      
        return (r ,g ,b )
    }
    

}


