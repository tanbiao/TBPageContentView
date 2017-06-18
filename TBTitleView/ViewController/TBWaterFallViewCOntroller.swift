//
//  TBWaterFallViewCOntroller.swift
//  TBTitleView
//
//  Created by 西乡流水 on 17/4/27.
//  Copyright © 2017年 西乡流水. All rights reserved.
//

import UIKit

class TBWaterFallViewCOntroller: UIViewController {
    
    let ID = "WaterFallCellID"
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let layout = TBWaterFallLayout()
        layout.cols = 3
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.delegate = self
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.frame = self.view.bounds
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: ID)
        view.addSubview(collectionView)
        
        title = "瀑布流"
        
    }

}


extension TBWaterFallViewCOntroller : TBWaterFallLayoutDelegate
{
    func waterFallLayout(layout: TBWaterFallLayout, heightForItemAt index: Int) -> CGFloat
    {
        return  CGFloat(arc4random_uniform(100) + 100)
    }

}
extension TBWaterFallViewCOntroller : UICollectionViewDataSource
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 300
    }
    
   func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
       let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: ID, for: indexPath)
    
       cell.backgroundColor = UIColor.randomColor()
        
       return cell
   }
    
}
