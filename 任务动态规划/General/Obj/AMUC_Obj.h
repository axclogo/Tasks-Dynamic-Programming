//
//  AMUC_Obj.h
//  任务动态规划
//
//  Created by Axc on 2017/10/11.
//  Copyright © 2017年 Axc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AxcDMP_Algorithm.h"

typedef NSMutableAttributedString AxcAS;


// Axc Model UI Control
@interface AMUC_Obj : NSObject

/** 生成模拟事件描述 */
+ (AxcAS *)simulateEventDescriptionWithModel:(AxcEventModel *)model;

/** 生成模拟事件描述，可以设置谓词颜色 */
+ (AxcAS *)simulateEventDescriptionWithModel:(AxcEventModel *)model PredicateColor:(UIColor *)color;

// 生成事件转换
+ (NSString *)getTimeInvervalFromDateString:(NSString *)dateString andFormateString:(NSString *)formate;

// 获取当前时间
+ (NSString *)getNowTime;

/** 根据优先级获取颜色 */
+ (UIColor *)getPriorityColorWithPriority:(CGFloat )priority;

@end
