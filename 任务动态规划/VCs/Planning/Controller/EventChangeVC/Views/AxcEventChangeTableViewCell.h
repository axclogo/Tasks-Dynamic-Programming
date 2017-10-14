//
//  AxcEventChangeTableViewCell.h
//  任务动态规划
//
//  Created by Axc on 2017/10/13.
//  Copyright © 2017年 Axc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AxcEventModel.h"

typedef NS_ENUM(NSInteger, AxcEventType) {
    AxcEventTypeFourElements,           // 事件四要素
    AxcEventTypeSimulationDescribe,     // 事件模拟描述
    AxcEventTypePriority,               // 事件优先级
    AxcEventTypeCreateDate              // 事件创建时间
} ;

#define kElementsTitle   @"elementsTitle"
#define kElementsContent @"elementsContent"

@protocol AxcEventChangeTableViewCellDelegate <NSObject >

- (void)changePriority:(CGFloat )priority;

@end

@interface AxcEventChangeTableViewCell : UITableViewCell

@property(nonatomic, strong)NSDictionary *modelMsgDic;
@property(nonatomic, assign)AxcEventType type;

@property(nonatomic, weak)id <AxcEventChangeTableViewCellDelegate> delegate;

// 输入SET类
@property(nonatomic, strong)NSString *subtitleString;

@property(nonatomic, strong)NSString *titleString;

// 副标题
@property (strong, nonatomic) UILabel *subtitleLabel;
// 模拟描述Label
@property(nonatomic, strong)UILabel *simulationDescribeLabel;
// 优先级
@property(nonatomic, strong)AxcUI_StarRatingView *priorityStartRatingView;

@end
