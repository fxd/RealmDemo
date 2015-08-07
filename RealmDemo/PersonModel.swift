//
//  PersonModel.swift
//  RealmDemo
//
//  Created by fengshaobo on 15/7/22.
//  Copyright (c) 2015年 fengshaobo. All rights reserved.
//

import UIKit
import Realm

class PersonModel: RLMObject {
    
    // 姓名
    dynamic var name = ""
    
    // 年龄
    dynamic var age: Int = 0
    
    // 部门
    dynamic var bu = BUModel()
    
}