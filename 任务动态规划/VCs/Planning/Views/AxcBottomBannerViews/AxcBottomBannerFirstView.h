//
//  AxcBottomBannerFirstView.h
//  任务动态规划
//
//  Created by Axc on 2017/9/28.
//  Copyright © 2017年 Axc. All rights reserved.
//

#import "AxcNavBaseView.h"

@protocol AxcBottomBannerFirstViewDelegate <NSObject >

- (void)eventTextFiledTextEding;

@end

@interface AxcBottomBannerFirstView : AxcNavBaseView

// 标题Label（弃用）
@property(nonatomic, strong)AxcBaseLabel *eventTitleLabel;
// 事件名输入
@property(nonatomic, strong)AxcBaseTextFiled *eventTitleTextFiled;
// 四要素按钮
@property(nonatomic, strong)AxcBaseButton *eventFourElementsBtn;
// 事件描述文字
@property(nonatomic, strong)AxcBaseLabel *eventDescriptionLabel;
// 添加事件按钮
@property(nonatomic, strong)AxcBaseButton *addEventBtn;

// 回调代理
@property(nonatomic, weak) id <AxcBottomBannerFirstViewDelegate> delegate;

@end
