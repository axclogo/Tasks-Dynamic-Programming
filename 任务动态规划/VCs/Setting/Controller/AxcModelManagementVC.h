//
//  AxcModelManagementVC.h
//  任务动态规划
//
//  Created by Axc on 2017/9/20.
//  Copyright © 2017年 Axc. All rights reserved.
//

#import "AxcBaseVC.h"

// 展示模型列表的类型
typedef NS_ENUM(NSInteger, AxcModelListStyle) {
    AxcModelListStyleObjectModel,   // 行动者      0
    AxcModelListStyleLocationModel  // 地点        1
} ;

@interface AxcModelManagementVC : AxcBaseVC

@property(nonatomic, assign)AxcModelListStyle modelListStyle;

@end
