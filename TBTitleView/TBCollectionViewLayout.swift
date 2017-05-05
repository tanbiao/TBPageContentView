//
//  TBCollectionViewLayout.swift
//  TBPageCollectionView
//
//  Created by 西厢流水 on 17/4/25.
//  Copyright © 2017年 TB. All rights reserved.
//

import UIKit

class TBCollectionViewLayout: UICollectionViewLayout
{
    /*每一组的内间距*/
    var sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 20, right: 10)
    
    /*item之间的水平间距*/
    var itemMargin : CGFloat = 5
    
    /*item之间的上下间距*/
    var lineMargin : CGFloat = 5
    
    //每行有几个
    var cols : Int = 4
    
    //有几行
    var rows : Int = 2
    
    //前面的页数
    fileprivate var prePagesNum = 0
    
    fileprivate lazy var attributes = [UICollectionViewLayoutAttributes]()

}

extension TBCollectionViewLayout
{
    override func prepare()
    {
        super.prepare()
        
        guard let collectionView = collectionView else {
            return
        }
        
        let sections = collectionView.numberOfSections
    
        let itemW = (collectionView.bounds.width - sectionInset.left - sectionInset.right - CGFloat(cols - 1) * itemMargin) / CGFloat(cols)
        
        let itemH = (collectionView.bounds.height - sectionInset.top - sectionInset.bottom -  CGFloat(rows - 1) * lineMargin) / CGFloat(rows)
        
        for section in 0..<sections
        {
            let itemCount = collectionView.numberOfItems(inSection: section)
            
            for item in 0..<itemCount
            {
                //item 在当前页面的位置
                let currentIndex = item % (cols * rows)
                //item 在当前组的多少页
                let currentPages = item / (rows * cols)
            
                let itemX : CGFloat = CGFloat(prePagesNum + currentPages) * collectionView.bounds.width + sectionInset.left + (itemW + itemMargin) * CGFloat(currentIndex % cols)
                //在那一行
                let lines = currentIndex / cols
        
                let itemY :CGFloat = sectionInset.top + (itemH + lineMargin) * CGFloat(lines)
                
                let indexPath = IndexPath(item: item, section: section)
                let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                
                attribute.frame = CGRect(x: itemX, y: itemY,width: itemW, height: itemH)
                attributes.append(attribute)
            }
            
            //前面有多少页
            prePagesNum += (itemCount - 1) / (cols * rows) + 1
        }
           
    }

}

extension TBCollectionViewLayout
{
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]?
    {
       return attributes
    }

}

extension TBCollectionViewLayout
{
    override var collectionViewContentSize: CGSize
        {
       return CGSize(width: CGFloat(prePagesNum) * collectionView!.bounds.width, height: 0)
    }

}
