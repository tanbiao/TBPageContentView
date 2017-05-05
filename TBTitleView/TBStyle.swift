//
//  TBStyle.swift
//  TBTitleView
//
//  Created by 西乡流水 on 17/4/14.
//  Copyright © 2017年 西乡流水. All rights reserved.
//

import UIKit

struct TBStyle {
    
    /*UIView动画的时间*/
    var animationDuration : TimeInterval = 0.175
    
    //MARK:********标题的一些常规设置
    /*titleView是否滚动*/
    var titleViewIsScroll : Bool = true
    /*titleLabel的高度*/
    var titleViewHeight : CGFloat = 44
    /*titleLabel字体大小*/
    var titleFont = UIFont.systemFont(ofSize: 14)
    /*titleView的背景颜色*/
    var titleLabelBackGroundColor = UIColor.white
    
    /*titleLabel之间的间距*/
    var titleMargin : CGFloat = 10
    /*titleLabel普通状态的字体颜色*/
    var titleNormalColor = UIColor.darkGray
    /*titleLabel选中状态的字体颜色*/
    var titleSelectColor = UIColor.red
    
    //Mark: *********titlelabel下面滑动线的设置
    
    /*是否加线*/
    var isAddUnderline : Bool = true
    /*线的颜色*/
    var titleUnderLineColor = UIColor.red
    /*线的高度*/
    var underlineHeight : CGFloat = 2
    
    //MARK:*********标题文字的渐变色

    /*是否设置文字的渐变色*/
    var isTitleTextColorGradient : Bool = true
        
    //MARK:**********在titleLabel加阴影
    /*标题后面是否加遮盖*/
    var isAddCoverView = true
    /*遮盖背景颜色*/
    var coverViewBackgroundColor = UIColor.gray
    /*遮盖的通明度*/
    var coverViewAlpha : CGFloat = 0.3
    /*遮盖的高度*/
    var coverViewHeight : CGFloat = 30;
    /*遮盖的圆角半径*/
    var coverViewRadius : CGFloat = 5;
    
    //MARK:***********文字缩放
    
    /*是否文字需要缩放*/
    var isNeedScale : Bool = false
    /*文字的最大缩放比例*/
    var maxScale : CGFloat = 1.2
    
    //MARK:***********TBPageCollectionView
    var pageControlH : CGFloat = 30
      
    
}
