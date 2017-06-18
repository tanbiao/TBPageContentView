//
//  TBPageView.swift
//  TBTitleView
//
//  Created by 西乡流水 on 17/4/20.
//  Copyright © 2017年 西乡流水. All rights reserved.
//

import UIKit

 let screenW  = UIScreen.main.bounds.size.width
 let screenH  = UIScreen.main.bounds.size.height

protocol TBPageViewDataSource : class
{
    func numberOfSectionsInPageView(in pageView: TBPageView) -> Int
    
    func pageView(_ pageView: TBPageView, numberOfItemsInSection section: Int) -> Int
    
    func pageView(_ pageView: TBPageView, collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    
}

@objc protocol TBPageViewDelegate :class
{
  @objc optional func  pageView(_ pageView: TBPageView, collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    
}

class TBPageView: UIView {
    
    weak var dataSource : TBPageViewDataSource?
    weak var delegate : TBPageViewDelegate?
    
    let contenViewCellID = "KcontenViewCellID"
    fileprivate var childViewControllers = [UIViewController]()
    fileprivate var parentViewController = UIViewController()
    fileprivate var titles = [String]()
    
    //MARK: 设置样式的类
    fileprivate var style = TBStyle()

    init(frame: CGRect,childVCs:[UIViewController], parentVC : UIViewController,style : TBStyle ,titles:[String]) {
        self.childViewControllers = childVCs
        self.parentViewController = parentVC
        self.style = style
        self.titles = titles
        super.init(frame: frame)
        self.parentViewController.automaticallyAdjustsScrollViewInsets = false
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension TBPageView
{
    fileprivate func setupUI()
    {
        let titleViewframe = CGRect(x: 0, y: 0, width: bounds.width, height: style.titleViewHeight)
        let titlView = TBTitleView(frame: titleViewframe, titles: titles, style: style)
        addSubview(titlView)
        
        let contentFrame = CGRect(x: 0, y: titlView.frame.maxY, width: bounds.width, height: screenH - titlView.frame.maxY)
        let contentView = TBContentView(frame: contentFrame, childViewControllers: childViewControllers, parentViewController: parentViewController, style: style)
        addSubview(contentView)
        
        titlView.delegate = contentView
        contentView.delegate = titlView
        contentView.dataSource = self
    
        contentView.registerCell(UICollectionViewCell.self, forCellWithReuseIdentifier:contenViewCellID)

    }
    
}

extension TBPageView :TBContentViewDataSource
{
    internal func numberOfSectionsInContentView(in contentView: TBContentView) -> Int {
        
        return 1
    }

    internal func contentView(_ contentView: TBContentView, numberOfItemsInSection section: Int) -> Int {
        
        return childViewControllers.count
    }
    
   internal func contentView(_ contentView: TBContentView, collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = contentView.dequeueReusableCell(withReuseIdentifier: contenViewCellID, for: indexPath)
        
        return cell
    }
    
}

