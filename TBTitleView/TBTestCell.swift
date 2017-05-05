//
//  TBTestCell.swift
//  TBTitleView
//
//  Created by 西乡流水 on 17/5/3.
//  Copyright © 2017年 西乡流水. All rights reserved.
//

import UIKit

class TBTestCell: UICollectionViewCell,Reusable {
    
    //重写协议里面的属性
    static var nib : UINib?
    {
        return UINib.init(nibName: "\(self)", bundle: nil)
    }
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

