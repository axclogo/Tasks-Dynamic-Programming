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
    AxcEventTypeNoteString,             // 事件备注
    AxcEventTypeCreateDate              // 事件创建时间
} ;

#define kElementsTitle   @"elementsTitle"
#define kElementsContent @"elementsContent"

#define TextViewCellDefaultHeight 100 // Cell默认高度
#define TextViewFrameMargin 5       // textView的边距
#define TextViewMarginValue  2*TextViewFrameMargin + 10 // 计算边距值

@protocol AxcEventChangeTableViewCellDelegate <UITableViewDelegate> // 代理的代理，代理链模式
// 优先级被触发
- (void)changePriority:(CGFloat )priority;
// 备注被触发
- (void)changeNoteString:(NSString *)noteString;
// 备注文字高度超过默认值(TextViewCellDefaultHeight)被触发
- (void)changeTextViewCellHeight:(CGFloat )height IndexPath:(NSIndexPath *)cellIndexPath;

@end

@interface AxcEventChangeTableViewCell : UITableViewCell <UITextViewDelegate>

@property(nonatomic, strong)NSDictionary *modelMsgDic;
@property(nonatomic, assign)AxcEventType type;
// 标记用的indexPath
@property(nonatomic, strong)NSIndexPath *cellIndexPath;


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
// 备注textView
@property(nonatomic, strong)UITextView *noteTextView;

// 计算文本高度// 计算文本高度（仅用于计算textView的实时动态高度）
- (CGFloat )computedTextHeightWithTextView:(UITextView *)textView;


@end
