//
//  TBPageCollectionView.swift
//  TBTitleView
//
//  Created by 西乡流水 on 17/4/27.
//  Copyright © 2017年 西乡流水. All rights reserved.
//

import UIKit

@objc protocol TBPageCollectionViewDataSource : class
{
     func collectionView(_ pageCollectionView: TBPageCollectionView, numberOfItemsInSection section: Int) -> Int
  
     func collectionView(_ pageCollectionView: TBPageCollectionView,collectionView : UICollectionView ,cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    
     @objc optional func numberOfSections(in pageCollectionView: TBPageCollectionView) -> Int
}

@objc protocol TBPageCollectionViewDelegate : class
{
     @objc optional  func collectionView(_ pageCollectionView: TBPageCollectionView,collectionView :UICollectionView, didSelectItemAt indexPath: IndexPath)
    
}

class TBPageCollectionView: UIView
{
    fileprivate var titles : [String]
    fileprivate var isTitleInTop : Bool
    fileprivate var style : TBStyle
    fileprivate var currentIndexPath = IndexPath(item: 0, section: 0)
    fileprivate let cellID = "pageViewCollectionCell"
    weak var dataSource : TBPageCollectionViewDataSource?
    weak var delegate : TBPageCollectionViewDelegate?
    
    /*设置content的 中一页有多少列*/
    var  cols : Int = 4 {
        
        didSet{
            
            layout.cols = cols
        }
    }
    
    /*设置content 中一页展示多少行数*/
    var rows : Int = 2 {
    
        didSet{
        
            layout.rows = rows
        }
      
    }
    
    fileprivate lazy var titleView : TBTitleView = {
        let titleFrame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.style.titleViewHeight)
        let titleView = TBTitleView(frame: titleFrame, titles: self.titles, style: self.style)
        titleView.delegate = self
        titleView.backgroundColor = UIColor.randomColor()
        
        return titleView
    }()
    
    fileprivate lazy var layout : TBCollectionViewLayout = TBCollectionViewLayout()
    
    fileprivate lazy var collectionView : UICollectionView = {

        let frame = CGRect(x: 0, y: self.style.titleViewHeight, width: self.bounds.width, height: self.bounds.height - self.style.titleViewHeight - self.style.pageControlH)
        let collectionView = UICollectionView(frame: frame, collectionViewLayout: self.layout)
         collectionView.backgroundColor = UIColor.randomColor()
         collectionView.dataSource = self
         collectionView.delegate = self
         collectionView.isPagingEnabled = true
        
        return collectionView
    }()
      
    fileprivate lazy var pageControl : UIPageControl = {
    
      let frame = CGRect(x: 0, y: self.bounds.height - self.style.pageControlH, width: self.bounds.width, height: self.style.pageControlH)
      let pageContol = UIPageControl(frame: frame)
      pageContol.backgroundColor = UIColor.gray
    
      return pageContol
    
   }()
   
    init(frame: CGRect,titles : [String], isTitleInTop : Bool ,style :TBStyle, parentViewController : UIViewController)
    {
        self.titles = titles
        self.isTitleInTop = isTitleInTop
        self.style = style
        super.init(frame: frame)
        setupUI()
        parentViewController.automaticallyAdjustsScrollViewInsets = false
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension TBPageCollectionView
{
    fileprivate func setupUI()
    {
       addSubview(titleView)
        
       addSubview(pageControl)
      
       addSubview(collectionView)
    }

}

// 自定义cell 注册的方式
extension TBPageCollectionView
{
    func registerCell<T :UICollectionViewCell >(_ cell :T.Type) where T : Reusable
    {
        collectionView.registerCell(cell)
    }
    
    func dequeueReusableCell<T : Reusable>(_ indexPath :IndexPath) -> T {
        
        return collectionView.dequeuResuableCell(indexPath) as T
    }
    
    func reloadData()
    {
        collectionView.reloadData()
    }

}

extension TBPageCollectionView : UICollectionViewDataSource
{
   internal func numberOfSections(in collectionView: UICollectionView) -> Int {
    
        return dataSource?.numberOfSections!(in: self) ?? 1
    }
    
   internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
        let items = dataSource?.collectionView(self, numberOfItemsInSection: section) ?? 0

        if section == 0
        {
            pageControl.numberOfPages = (items - 1) / (layout.rows * layout.cols) + 1
            pageControl.currentPage = 0
        }
    
        return items
    }
    
   internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        return dataSource!.collectionView(self, collectionView: collectionView, cellForItemAt: indexPath)
    }

}

extension TBPageCollectionView : UICollectionViewDelegate
{
    
   internal func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
       scrollViewDidEndScroll()
    }
    
   internal func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)
    {
        if !decelerate {
            scrollViewDidEndScroll()
        }
    }
      private func scrollViewDidEndScroll()
    {
        let point = CGPoint(x: layout.sectionInset.left + 1 + collectionView.contentOffset.x, y: layout.sectionInset.top + 1)
        
        guard let indexPath = collectionView.indexPathForItem(at: point) else {
            return
        }
        
        if currentIndexPath.section != indexPath.section
        {
            let items = collectionView.numberOfItems(inSection: indexPath.section)
            pageControl.numberOfPages = (items - 1) / (layout.cols * layout.rows)  + 1
            titleView.setTitleViewCurrentIndex(index: indexPath.section)
        }
        
        pageControl.currentPage = indexPath.item / (layout.cols * layout.rows)
        currentIndexPath = indexPath
        
    }
    internal  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        delegate?.collectionView!(self, collectionView: collectionView, didSelectItemAt: indexPath)
    }

}

extension TBPageCollectionView :TBTitleDelegate
{
    func titleView(titleView: TBTitleView, targetIndex index: Int)
    {
        let indexPath = IndexPath(item: 0, section: index)
        collectionView.scrollToItem(at: indexPath, at: .left, animated: true)
        collectionView.contentOffset.x = collectionView.contentOffset.x - self.layout.sectionInset.left
        
        let items = collectionView.numberOfItems(inSection: index)
        pageControl.numberOfPages = (items - 1) / (layout.cols * layout.rows)  + 1
        pageControl.currentPage = 0
        currentIndexPath = indexPath
    }
}
