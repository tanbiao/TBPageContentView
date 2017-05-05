//
//  TBWaterFallLayout.swift
//  WaterFallLayout
//
//  Created by 西乡流水 on 17/4/25.
//  Copyright © 2017年 西乡流水. All rights reserved.
//

import UIKit

@objc protocol TBWaterFallLayoutDelegate : class
{
     func waterFallLayout(layout: TBWaterFallLayout, heightForItemAt index: Int) -> CGFloat
}

class TBWaterFallLayout: UICollectionViewFlowLayout
{
    fileprivate lazy var attributes = [UICollectionViewLayoutAttributes]()
    fileprivate var cellHeights = [CGFloat]()
    
    weak var delegate : TBWaterFallLayoutDelegate?
    /*设置多少列*/
    var cols : Int = 2
   
}

//MARK: 把要布局每个cell的attribut 准备好
extension TBWaterFallLayout
{
    override func prepare() {
        super.prepare()
        
        guard let waterFallCollectionView = collectionView else {
            return
        }
        
        //waterFall布局,一般情况下只有一组
        let itemCount = waterFallCollectionView.numberOfItems(inSection: 0)
    
        //一共有几列
        cellHeights = Array(repeating: sectionInset.top, count: cols)
        
        let itemW : CGFloat = (waterFallCollectionView.bounds.width - sectionInset.left - sectionInset.right - (CGFloat(cols) - 1) * minimumInteritemSpacing) / CGFloat(cols)
     
        var itemX : CGFloat = 0
        var itemY : CGFloat = 0
        
        for i in 0 ..< itemCount
        {
            let indexPath = IndexPath(item: i, section: 0)
            let itemH = delegate?.waterFallLayout(layout: self, heightForItemAt: i)
            
            let attribute = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            
            let minH = cellHeights.min()
            let minIndex = cellHeights.index(of: minH!)
            
            itemX = sectionInset.left + (minimumInteritemSpacing + itemW) * CGFloat(minIndex!)

            itemY = minH! + minimumLineSpacing
            
            attribute.frame = CGRect(x: itemX, y: itemY, width: itemW, height: itemH!)
            attributes.append(attribute)
            
            cellHeights[minIndex!] = attribute.frame.maxY
        }
        
    }

}

//MARK:告诉系统已经把每个cell的attribut已经准备好了,并传给系统
extension TBWaterFallLayout
{
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]?
    {
        return attributes
    }
 
}

//MARK:更新contentSize
extension TBWaterFallLayout
{
    override var collectionViewContentSize: CGSize
        {

        return CGSize(width: 0, height: cellHeights.max()! + sectionInset.bottom + minimumLineSpacing)
    }

}
