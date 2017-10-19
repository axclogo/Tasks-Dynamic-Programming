//
//  AxcBottomBannerSecondView.h
//  任务动态规划
//
//  Created by Axc on 2017/10/19.
//  Copyright © 2017年 Axc. All rights reserved.
//

#import "AxcNavBaseView.h"


@protocol AxcBottomBannerSecondViewDelegate <NSObject >

// 优先级被触发
- (void)starRatingViewDidChangePriority:(CGFloat )priority;

 // 备注改变
- (void)noteTextViewDidChange:(NSString *)noteText;


@end


@interface AxcBottomBannerSecondView : AxcNavBaseView <UITextViewDelegate>

// 优先级
@property(nonatomic, strong)AxcUI_StarRatingView *priorityStartRatingView;

// 备注
@property(nonatomic, strong)AxcBaseTextView *noteTextView;

// 说明Label
@property(nonatomic, strong)AxcUI_Label *contentTitleLabel;


@property(nonatomic, weak)id <AxcBottomBannerSecondViewDelegate> delegate;

@end
