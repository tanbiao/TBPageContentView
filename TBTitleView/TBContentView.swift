//
//  TBContentView.swift
//  TBTitleView
//
//  Created by 西乡流水 on 17/4/14.
//  Copyright © 2017年 西乡流水. All rights reserved.
//

import UIKit

//MARK:=====数据源,必须实现
protocol TBContentViewDataSource : class
{
    func contentView(_ contentView: TBContentView, numberOfItemsInSection section: Int) -> Int
    
    func numberOfSectionsInContentView(in contentView: TBContentView) -> Int
    
    func contentView(_ contentView: TBContentView, collectionView: UICollectionView,cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    
}

//MARK:这里的代理方法,可自行封装
@objc protocol TBContentViewDelegate : class
{
    @objc optional func contentView(_ contentView : TBContentView ,didEndScroll index :Int)
    
    @objc optional func contentView(_ contentView : TBContentView , sourceIndex : Int ,targetIndex : Int ,progress : CGFloat)
   
}

class TBContentView: UIView {
    
    weak var dataSource : TBContentViewDataSource?
    weak var delegate :TBContentViewDelegate?
    
    fileprivate var childViewControllers = [UIViewController]()
    fileprivate var style = TBStyle()
    fileprivate var startContentOffsetX : CGFloat = 0
    fileprivate var currentIndex : Int = 0
    fileprivate var isForbidDelegate : Bool = false
 
    fileprivate lazy var kcollectionView : UICollectionView = {
            let layout = UICollectionViewFlowLayout()
            layout.itemSize = CGSize(width: self.bounds.width, height: self.bounds.height)
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
            layout.scrollDirection = .horizontal
            let conllectionView = UICollectionView(frame: self.bounds, collectionViewLayout:layout)
            conllectionView.showsHorizontalScrollIndicator = false
            conllectionView.showsVerticalScrollIndicator = false
            conllectionView.bounces = false
            conllectionView.isPagingEnabled = true
            conllectionView.dataSource = self
            conllectionView.delegate = self
        
            return conllectionView
    }()
    
    init(frame: CGRect, childViewControllers:[UIViewController],parentViewController:UIViewController, style : TBStyle)
    {
        self.childViewControllers = childViewControllers
        self.style = style;
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

//MARK:对外提供的方法
extension TBContentView
{
    func registerCell(_ cellClass: Swift.AnyClass?, forCellWithReuseIdentifier identifier: String)
    {
       kcollectionView.register(cellClass, forCellWithReuseIdentifier: identifier)
    }
    
    func registerNib(_ nib: UINib?, forCellWithReuseIdentifier identifier: String)
    {
       kcollectionView.register(nib, forCellWithReuseIdentifier: identifier)
    }
    
    func dequeueReusableCell(withReuseIdentifier identifier: String, for indexPath: IndexPath) -> UICollectionViewCell
    {
       return kcollectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath)
    }
    
    func registerCell<T :UICollectionViewCell >(_ cell :T.Type) where T : Reusable
    {
        kcollectionView.registerCell(cell)
    }
      
    func dequeueReusableCell<T : Reusable>(_ indexPath :IndexPath) -> T {
        
       return kcollectionView.dequeuResuableCell(indexPath) as T
    }
    
    func reloadData()
    {
        kcollectionView.reloadData()
    }
}

extension TBContentView
{
    fileprivate func setupUI()
    {
      addSubview(kcollectionView)
    }

}

extension TBContentView : TBTitleDelegate
{
    func titleView(titleView: TBTitleView, targetIndex index: Int) {
        
        isForbidDelegate = true
        
        let point = CGPoint(x: self.bounds.width * CGFloat(index), y: 0)
        kcollectionView.setContentOffset(point, animated: false)
    }

}

extension TBContentView : UICollectionViewDataSource
{
    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return dataSource?.contentView(self, numberOfItemsInSection: section) ?? 0
    }
    
    internal func numberOfSections(in collectionView: UICollectionView) -> Int {
      
        return dataSource?.numberOfSectionsInContentView(in: self) ?? 1
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = dataSource?.contentView(self, collectionView: collectionView, cellForItemAt: indexPath)
        let vc = childViewControllers[indexPath.row]
        vc.view.frame = cell!.bounds
        cell!.contentView.addSubview(vc.view)
        
        return cell!
    }

}

//MARK:=UIScrollViewDelegate
extension TBContentView : UIScrollViewDelegate,UICollectionViewDelegate
{
    internal func scrollViewDidScroll(_ scrollView: UIScrollView)
    {
      let currentOffsetX = scrollView.contentOffset.x
      var currentIndex : Int = 0
      var sourceIndex :Int = 0
      var progress : CGFloat = 0
            
        //没有滑动
      guard currentOffsetX != startContentOffsetX && !isForbidDelegate else {
            return
        }
        //向左边滑动
      if currentOffsetX > startContentOffsetX
      {
          sourceIndex = Int(scrollView.contentOffset.x / kcollectionView.bounds.width)
        
          currentIndex = sourceIndex + 1
        
         if currentIndex >= childViewControllers.count
         {
            currentIndex = childViewControllers.count - 1
         }
        
         progress  = (currentOffsetX - startContentOffsetX) / kcollectionView.bounds.width
        
         if (currentOffsetX - startContentOffsetX) == kcollectionView.bounds.width
         {
            currentIndex = sourceIndex
         }
        
         if (currentOffsetX - startContentOffsetX) > kcollectionView.bounds.width
         {
            return
         }
      }
      else//向右边滑动
      {
         progress = (startContentOffsetX - currentOffsetX) / kcollectionView.bounds.width
        
         currentIndex = Int(scrollView.contentOffset.x / kcollectionView.bounds.width)
        
         sourceIndex = currentIndex + 1
        
         if sourceIndex <= 0
         {
           sourceIndex = 0
         }
    
         if (startContentOffsetX - currentOffsetX) > kcollectionView.bounds.width
         {
            return
         }
        
      }
        
       delegate?.contentView!(self, sourceIndex: sourceIndex, targetIndex: currentIndex, progress: progress)
        
    }
    
    internal func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        scrollViewDidEndScroll()
    }
    
    internal func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool)
    {
        if !decelerate
        {
            scrollViewDidEndScroll()
    
        }
        
    }
    
    internal func scrollViewWillBeginDragging(_ scrollView: UIScrollView)
    {
        isForbidDelegate = false
        startContentOffsetX = scrollView.contentOffset.x
    }
    
    private func scrollViewDidEndScroll()
    {
       kcollectionView.isScrollEnabled = true
        
       let index = Int(kcollectionView.contentOffset.x / bounds.width)
       delegate?.contentView!(self, didEndScroll: index)
    }
    
    internal  func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>)
    {
        //这个属性防止,连续不断拖拽出现的bug
        kcollectionView.isScrollEnabled = false
    }
        
}

