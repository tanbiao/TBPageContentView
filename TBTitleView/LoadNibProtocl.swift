//
//  LoadNibProtorl.swift
//  Swift面向协议开发
//
//  Created by 西乡流水 on 17/4/18.
//  Copyright © 2017年 西乡流水. All rights reserved.
//

import UIKit


protocol LoadNibProtocl
{
    
}

/*在协议和结构体里面实现类方法有static ,self 用Self*/
/*表示遵守这个协议的必须是UIVIew*/
extension LoadNibProtocl where Self:UIView
{
    static func loadFromNib(_ nibname :String? = nil) -> Self
    {
      let nib = nibname ?? "\(self)"
      return Bundle.main.loadNibNamed(nib, owner: nil, options: nil)?.last as! Self
    }
    
}
