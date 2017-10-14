//
//  AxcBannerView.h
//  任务动态规划
//
//  Created by Axc on 2017/9/28.
//  Copyright © 2017年 Axc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AMUC_Obj.h"


@protocol AxcBottomBannerViewDelegate <NSObject >

// 左拉到头
- (void)AxcUI_bottomBannerViewFooterDidTrigger;
// 点击事件四要素按钮
- (void)AxcUI_click_eventFourElementsBtn:(NSString *)eventTitle;
// 点击添加事件
- (void)AxcUI_click_addEventModel:(NSString *)eventTitle;

@end



@interface AxcBottomBannerView : UIView

@property(nonatomic, strong)AxcEventModel *eventModel;

@property(nonatomic, strong)id <AxcBottomBannerViewDelegate >delegate;

- (void)clickPickOKBtn;

@end
