//
//  AxcBottomBannerThirdView.h
//  任务动态规划
//
//  Created by Axc on 2017/10/19.
//  Copyright © 2017年 Axc. All rights reserved.
//

#import "AxcNavBaseView.h"

@interface AxcBottomBannerThirdView : AxcNavBaseView <AxcTagTextViewDelegate>

// 标签View
@property(nonatomic,strong)AxcUI_TagTextView *tagTextView;

// 常用事件列表
@property(nonatomic, strong)NSArray <AxcEventModel *>*commonlyUsedEventArray;

// 展示数组
@property(nonatomic, strong)NSMutableArray <NSString *>*eventTagsTextArray;

@end
