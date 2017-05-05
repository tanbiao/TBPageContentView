//
//  TBContentViewController.swift
//  TBTitleView
//
//  Created by 西乡流水 on 17/4/27.
//  Copyright © 2017年 西乡流水. All rights reserved.
//

import UIKit

class TBContentViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        addPageView()
    }

    
    func  addPageView ()
    {
        let frame = CGRect(x: 0, y: 64, width: screenW, height: screenH - 64)
        
        let titles = ["张三","李四","王麻子","娱乐快报","娱娱乐快报","娱娱乐快","ios奇葩说","哈哈哈啊哈和","荆州哈哈哈哈","heheheh","骡子","麻子"]
        
        var childVc : [UIViewController] = [UIViewController]()
        
        for _ in titles {
            
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor.randomColor()
            childVc.append(vc)
        }
        
        var style  = TBStyle()
        style.isNeedScale = true
        
        let  pageView = TBPageView(frame: frame, childVCs: childVc, parentVC: self, style: style, titles: titles)
        view.addSubview(pageView)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
  
}
