//
//  TBTitleView.swift
//  TBTitleView
//
//  Created by 西乡流水 on 17/4/14.
//  Copyright © 2017年 西乡流水. All rights reserved.
//

import UIKit

protocol TBTitleDelegate :class
{
    /*titleView滚动的时候,调用*/
    func titleView(titleView :TBTitleView ,targetIndex index:Int)
    
}

class TBTitleView: UIView {
    
    fileprivate var titles = [String]()
    fileprivate var style = TBStyle()
    fileprivate var sourceIndex :Int  = 0
    fileprivate var currentIndex : Int = 0
    fileprivate var titleLabels : [UILabel] = [UILabel]()
    fileprivate var scrollOffsetX : CGFloat = 0
    
    weak var delegate :TBTitleDelegate?
    
    fileprivate lazy var normalColorRGB :(CGFloat,CGFloat,CGFloat) = {
      return  UIColor.getColorRGB(color: self.style.titleNormalColor)
    }()
    
    fileprivate lazy var selectColorRGB :(CGFloat,CGFloat,CGFloat) = {
       
       return UIColor.getColorRGB(color: self.style.titleSelectColor)
    }()
    
    fileprivate lazy var deltaColorRGB :(CGFloat,CGFloat,CGFloat) = {
       return  UIColor.getColorRGBDistance(firstColor: self.style.titleNormalColor, secondColor: self.style.titleSelectColor)
    }()
    
    fileprivate lazy var titleContentView : UIScrollView = {
        let contentView = UIScrollView.init(frame: self.bounds)
        contentView.delegate = self
        contentView.showsHorizontalScrollIndicator = false
        contentView.bounces = false
        self.addSubview(contentView)
        return contentView
    }()
    
    fileprivate lazy var underLine : UIView = {
        let underLine = UIView()
        underLine.backgroundColor = self.style.titleUnderLineColor
        return underLine
    }()
    
    fileprivate lazy var coverView : UIView = {
        let coverView = UIView()
        coverView.backgroundColor = self.style.coverViewBackgroundColor
        coverView.alpha = self.style.coverViewAlpha
        return coverView
    }()

    init(frame : CGRect,titles:[String], style:TBStyle) {
        self.titles = titles;
        self.style = style;
        super.init(frame: frame)
        setupUI()
        
        titleContentView.backgroundColor = UIColor.gray
    }
      
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension TBTitleView
{
    fileprivate func setupUI()
    {
        setupTitleLabels()
        
        //添加underLine
        if style.isAddUnderline
        {
            setupUnderLine()
        }
        
        if style.isAddCoverView
        {
            setupCoverView()
        }
        
        if style.isNeedScale
        {
            titleLabels.first?.transform = CGAffineTransform(scaleX: style.maxScale, y: style.maxScale)
        }
        
    }
   
    fileprivate func setupTitleLabels()
    {
        for (i,title) in titles.enumerated()
        {
            let titleLabel = UILabel()
            titleLabel.tag = i
            titleLabel.textColor = i == 0 ? style.titleSelectColor : style.titleNormalColor
            titleLabel.textAlignment = .center
            titleLabel.font = style.titleFont
            titleLabel.text = title
            titleLabel.isUserInteractionEnabled = true
            titleLabel.backgroundColor = UIColor.yellow
            addGesture(laebel: titleLabel)
            
            titleContentView.addSubview(titleLabel)
            titleLabels.append(titleLabel)
            
        }
        
        var x : CGFloat = 0
        let y : CGFloat = 0
        var w : CGFloat = bounds.width / CGFloat(titleLabels.count)
        let h : CGFloat = self.bounds.height
        
        for (i , titleLabel) in titleLabels.enumerated()
        {
            if style.titleViewIsScroll == false
            {
                x = CGFloat(i) * w
                
            }
            else
            {
                w = String.getSizeWithText(text: titleLabel.text!,textFont: style.titleFont).width + 3
                
                x = i == 0 ? style.titleMargin * 0.5 : (titleLabels[i - 1]).frame.maxX + style.titleMargin

            }
            
            titleLabel.frame = CGRect(x: x, y: y, width: w, height: h)
            
        }
        
        if style.titleViewIsScroll
        {
            titleContentView.contentSize = CGSize(width: titleLabels.last!.frame.maxX + style.titleMargin * 0.5, height: 0)
        }
        
    }
    
    fileprivate func setupUnderLine()
    {
        let width = String.getSizeWithText(text: titleLabels.first!.text!, textFont: style.titleFont).width
        underLine.frame.size.width = width
        underLine.frame.origin.y = titleLabels.first!.frame.height - style.underlineHeight
        underLine.frame.size.height = style.underlineHeight
        underLine.center.x = (titleLabels.first?.center.x)!
        titleContentView.addSubview(underLine)
    }
    
    fileprivate func setupCoverView()
    {
        titleContentView.addSubview(coverView)

        let  w : CGFloat = String.getSizeWithText(text: titleLabels.first!.text!,textFont: style.titleFont).width
        let  h : CGFloat = style.coverViewHeight
        let  x : CGFloat = (titleLabels.first!.frame.width - w) * 0.5 + titleLabels.first!.frame.minX
        let  y : CGFloat = (titleLabels.first!.frame.height - style.coverViewHeight) * 0.5
        coverView.frame = CGRect(x: x, y: y, width: w, height: h)
        coverView.layer.cornerRadius = style.coverViewRadius
        coverView.alpha = style.coverViewAlpha
        
    }
    
   fileprivate func addGesture(laebel:UILabel)
    {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapGestrueClick(tap:)))
        laebel.addGestureRecognizer(tap)
    }
    
   @objc fileprivate func tapGestrueClick(tap:UITapGestureRecognizer)
    {
        guard let targetLabel = tap.view as? UILabel else {
          
            return
        }
      
        setupTitleViewTargetLabel(targetLabel: targetLabel)
        
        delegate?.titleView(titleView: self, targetIndex: targetLabel.tag)
    }
    
    fileprivate func setupTitleViewTargetLabel(targetLabel : UILabel)
    {
        let sourceLabel = titleLabels[currentIndex]
        sourceLabel.textColor = style.titleNormalColor
        targetLabel.textColor = style.titleSelectColor
        currentIndex = targetLabel.tag

        if style.titleViewIsScroll
        {
          adjustTitleLabelPosition(index: targetLabel.tag)
        }

        //调整underline的x值和宽度
        if style.isAddUnderline
        {
           adjustUnderLineFrame()
        }

        if style.isAddCoverView
        {
          adjustCoverViewPosition(targetIndex: targetLabel.tag)
        }

        if style.isNeedScale
        {
          sourceLabel.transform = CGAffineTransform.identity
          targetLabel.transform = CGAffineTransform(scaleX: style.maxScale, y: style.maxScale)
        }
    
    }
    
    fileprivate func adjustTitleLabelPosition(index : Int)
    {
        let targetLabel = titleLabels[currentIndex]
        
        var offsetX = targetLabel.center.x - bounds.width * 0.5
        
        if offsetX < 0
        {
            offsetX = 0
        }
        
        let maxOffsetX = titleContentView.contentSize.width - bounds.width
        
        if offsetX > maxOffsetX
        {
            offsetX = maxOffsetX
        }
        
        scrollOffsetX = offsetX
        
        let point = CGPoint(x: offsetX, y: 0)
        
        titleContentView.setContentOffset(point, animated: true);
        
    }
    
    fileprivate func adjustUnderLineFrame()
    {
        UIView.animate(withDuration: style.animationDuration) {
            
            let currentLabel = self.titleLabels[self.currentIndex]
            self.underLine.frame.size.width = String.getSizeWithText(text: currentLabel.text!, textFont: self.style.titleFont).width
            self.underLine.center.x = currentLabel.center.x
            
        }
        
    }
    
    fileprivate func adjustCoverViewPosition(targetIndex : Int)
    {
       let targetLabel = titleLabels[targetIndex]
       
       UIView.animate(withDuration: style.animationDuration) {
        
            let targetW = String.getSizeWithText(text: targetLabel.text!, textFont: self.style.titleFont).width
            self.coverView.frame.size.width = self.style.isNeedScale ? targetW * self.style.maxScale : targetW
            self.coverView.center.x = targetLabel.center.x
    
        }
    
    }
    
}

//MARK:对外提供的接口
extension TBTitleView
{
    func setTitleViewCurrentIndex(index : Int)
    {
        let targetLabel = titleLabels[index]
        
        setupTitleViewTargetLabel(targetLabel: targetLabel)
    }

}

//MARK:UIScrollViewDelegate
extension TBTitleView : UIScrollViewDelegate
{
    func scrollViewDidScroll(_ scrollView: UIScrollView)
    {

    }

}

//MARK:TBContentViewDelegate
extension TBTitleView : TBContentViewDelegate
{
    func contentView(_ contentView: TBContentView, didEndScroll index: Int)
    {
        setupTitleViewTargetLabel(targetLabel : titleLabels[index])
        
        currentIndex = index
        
    }
    
   internal func contentView(_ contentView : TBContentView , sourceIndex : Int ,targetIndex : Int ,progress : CGFloat)
    {        
        let sourceLabel = titleLabels[sourceIndex]
        let targetLabel = titleLabels[targetIndex]
        
        //这个功能有bug
        if style.isTitleTextColorGradient
        {
           setupTitleTextColorGradient(sourceLabel: sourceLabel, targetLabel: targetLabel, progress: progress)
        }
        
        if style.isNeedScale
        {
            setupTextScale(sourceLabel: sourceLabel, targetLabel: targetLabel, progress: progress)
            
            if style.isAddCoverView
            {
                setupCoverViewScaleAndPostion(sourceLabel: sourceLabel, targetLabel: targetLabel, progress: progress)
            }
            
        }
        
        if style.isAddUnderline
        {
            setupUnderLinePosition(sourceLabel: sourceLabel, targetLabel: targetLabel, progress: progress)
        }
    
    }
       
    private func setupUnderLinePosition(sourceLabel: UILabel, targetLabel: UILabel,progress: CGFloat)
    {
        let sourceLabelW = String.getSizeWithText(text: sourceLabel.text!, textFont: self.style.titleFont).width
        let targetLabelW = String.getSizeWithText(text: targetLabel.text!, textFont: self.style.titleFont).width
        let deltaW = sourceLabelW - targetLabelW
        let deltaX = sourceLabel.frame.origin.x - targetLabel.frame.origin.x
        underLine.frame.size.width = sourceLabelW - deltaW * progress
        underLine.frame.origin.x = sourceLabel.frame.origin.x - deltaX * progress
    }
    
    private func setupTextScale(sourceLabel: UILabel, targetLabel: UILabel,progress: CGFloat)
    {
        let deltaScale = style.maxScale - 1.0
        
        sourceLabel.transform = CGAffineTransform(scaleX: style.maxScale - deltaScale * progress, y: style.maxScale - deltaScale * progress)
        targetLabel.transform = CGAffineTransform(scaleX: 1.0 + deltaScale * progress, y: 1.0 + deltaScale * progress)
    }
    
    private func setupTitleTextColorGradient(sourceLabel :UILabel,targetLabel: UILabel,progress : CGFloat)
    {
        let sourceColorR =  selectColorRGB.0 + deltaColorRGB.0 * progress
        let sourceColorG =  selectColorRGB.1 + deltaColorRGB.1 * progress
        let sourceColorB =  selectColorRGB.2 + deltaColorRGB.2 * progress
        
        sourceLabel.textColor =  UIColor(red: sourceColorR, green: sourceColorG, blue: sourceColorB ,alpha : 1)
        
        let targetColorR = normalColorRGB.0 - deltaColorRGB.0 * progress
        let targetColorG = normalColorRGB.1 - deltaColorRGB.1 * progress
        let targetColorB = normalColorRGB.2 - deltaColorRGB.2 * progress
        
        targetLabel.textColor = UIColor(red: targetColorR, green: targetColorG, blue: targetColorB, alpha: 1)
        
    }
    
    private func setupCoverViewScaleAndPostion(sourceLabel: UILabel, targetLabel: UILabel,progress: CGFloat)
    {
        let deltaScale = style.maxScale - 1.0
        let deltaX = sourceLabel.center.x - targetLabel.center.x
        let sourceW = String.getSizeWithText(text: sourceLabel.text!, textFont: style.titleFont).width
        let targetW = String.getSizeWithText(text: targetLabel.text!, textFont: style.titleFont).width
        let deltaW = sourceW - targetW
        coverView.bounds.size.width = sourceW  + deltaW * progress * deltaScale
      
        coverView.center.x = sourceLabel.center.x - deltaX * progress
        coverView.center.y = sourceLabel.center.y
    }
   
}




