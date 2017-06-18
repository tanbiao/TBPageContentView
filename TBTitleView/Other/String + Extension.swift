//
//  String + Extension.swift
//  TBTitleView
//
//  Created by 西乡流水 on 17/4/14.
//  Copyright © 2017年 西乡流水. All rights reserved.
//

import UIKit
import CoreText

extension String
{
   static func getSizeWithText(text : String, textFont : UIFont) -> CGSize
    {
        let atts = [NSFontAttributeName: textFont]
        
        return (text as NSString).size(attributes: atts)
    }
}
