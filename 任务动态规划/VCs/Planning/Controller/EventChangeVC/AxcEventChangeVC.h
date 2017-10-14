//
//  AxcEventChangeVC.h
//  任务动态规划
//
//  Created by Axc on 2017/10/13.
//  Copyright © 2017年 Axc. All rights reserved.
//

#import "AxcBaseVC.h"
@class AxcEventChangeVC;

@protocol AxcEventChangeVCDelegate <NSObject >

/** 修改/查看完成后的Model */
- (void)eventChangeVC:(AxcEventChangeVC *)eventChangeVC didChangeEventModel:(AxcEventModel *)model;

@end


@interface AxcEventChangeVC : AxcBaseVC

// 准备设置的Model
@property(nonatomic, strong)AxcEventModel *changeEventModel;

// 目录标记
@property(nonatomic, strong)NSIndexPath *indexPath;

// 回调代理
@property(nonatomic, weak)id <AxcEventChangeVCDelegate> delegate;


@end
