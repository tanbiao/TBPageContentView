

//
//  TBPageCollectionViewController.swift
//  TBTitleView
//
//  Created by 西乡流水 on 17/4/27.
//  Copyright © 2017年 西乡流水. All rights reserved.
//

import UIKit

class TBPageCollectionViewController: UIViewController {
    
     let titles = ["张三","赵云","张飞TM","刘备SB"]

    override func viewDidLoad() {
        super.viewDidLoad()

        addPageCollectionView()
    }
    
    func addPageCollectionView()
    {
        var style = TBStyle()
        style.titleViewIsScroll = false
        let frame = CGRect(x: 0, y: 200, width: view.bounds.width, height: 300)
        let collectionView = TBPageCollectionView(frame: frame, titles: titles, isTitleInTop: true, style: style, parentViewController: self)
        collectionView.rows = 3
        collectionView.cols = 4
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.registerCell(TBTestCell.self)
        view.addSubview(collectionView)
  
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension TBPageCollectionViewController : TBPageCollectionViewDataSource,TBPageCollectionViewDelegate
{
    func numberOfSections(in pageCollectionView: TBPageCollectionView) -> Int {
        
        return titles.count
    }
    
    func collectionView(_ pageCollectionView: TBPageCollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 0
        {
            return 16
        }
        
        if section == 3
        {
            return 24
        }
        
        return 17
    }
    
    
    func collectionView(_ pageCollectionView: TBPageCollectionView, collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = pageCollectionView.dequeueReusableCell(indexPath) as TBTestCell
        
        cell.backgroundColor = UIColor.randomColor()
        
        return cell
    }
    
   
    func collectionView(_ pageCollectionView: TBPageCollectionView, collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
         print("选择了\(indexPath.section)组" + "第\(indexPath.row)个")
    }
    
    
}
