//
//  AxcBaseMenuController.m
//  任务动态规划
//
//  Created by Axc on 2017/10/20.
//  Copyright © 2017年 Axc. All rights reserved.
//

#import "AxcBaseMenuController.h"

// 单例设置
static AxcBaseMenuController    *_axcBaseMenuController;

@implementation AxcBaseMenuController

+ (AxcBaseMenuController *)sharedMenuController{
    if (_axcBaseMenuController == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{                    // 设置该线程仅进行一次初始化操作，该核心对象包括所含参数全为单例模式
            _axcBaseMenuController = [[AxcBaseMenuController alloc]init];
        });
    }
    return _axcBaseMenuController;
}

// 线程安全
+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t once;
    dispatch_once(&once, ^{                             // 为防止Alloc初始化 将alloc方法锁定
        _axcBaseMenuController = [super allocWithZone:zone];
    });
    return _axcBaseMenuController;
}

@end
