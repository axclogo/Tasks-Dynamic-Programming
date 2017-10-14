//
//  AxcEventModel.h
//  任务动态规划
//
//  Created by Axc on 2017/9/18.
//  Copyright © 2017年 Axc. All rights reserved.
//

#import "AxcBaseModel.h"

#import "AxcConditionsBaseModel.h"

#define EventModelTriggerObject @"triggerObject"
#define EventModelTriggerLocation @"triggerLocation"
#define EventModelPerformObject @"performObject"
#define EventModelPerformLocation @"performLocation"


// 事件状态
typedef NS_ENUM(NSInteger, AxcEventState) {
    AxcEventStateWaiting, // 等待      0
    AxcEventStateOngoing, // 进行中     1
    AxcEventStateComplete // 已完成     2
} ;

@interface AxcEventModel : AxcBaseModel

// 执行时间
@property(nonatomic, assign)NSInteger executionTime;

// 触发者
@property(nonatomic, strong)AxcObjectModel *triggerObject;

// 执行者
@property(nonatomic, strong)AxcObjectModel *performObject;

// 触发地点
@property(nonatomic, strong)AxcLocationModel *triggerLocation;

// 执行地点
@property(nonatomic, strong)AxcLocationModel *performLocation;

// 事件状态
@property(nonatomic, assign)AxcEventState eventState;

// 完成日期
@property(nonatomic, strong)NSString *completeDate;

// AxcEventModel转换字典
- (NSDictionary *)eventModelWithDic;

// copy
- (id )Axc_copy;


@end
