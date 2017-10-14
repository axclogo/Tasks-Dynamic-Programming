//
//  AxcDMP_Algorithm.h
//  任务动态规划
//
//  Created by Axc on 2017/9/18.
//  Copyright © 2017年 Axc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "AxcEventModel.h"

// 所有条件的函数定义
extern const struct AxcConditionsFunctionOption {
    /** 事件是否两个地点相同，并且两个行动者不同 */
    __unsafe_unretained NSString *Axc_PlaceSame_And_PeopleDifferent;
    /** 事件是否两个地点不同，并且两个行动者不同 */
    __unsafe_unretained NSString *Axc_PlaceDifferent_And_PeopleDifferent;
    /** 事件是否两个地点相同，并且两个行动者相同 */
    __unsafe_unretained NSString *Axc_Place_PeopleSame;
    /** 事件是否两个地点不同，并且两个行动者相同 */
    __unsafe_unretained NSString *Axc_PlaceDifferent_And_PeopleSame;
    
    /** 事件是否携带有优先级 */
    __unsafe_unretained NSString *Axc_EventWithPriority;
    
    
} AxcCFOK;


// 运算属性
typedef NS_ENUM(NSInteger, AxcOperationProperties) {
    AxcOperationPropertiesTriggerObject,  // 触发者
    AxcOperationPropertiesTriggerLocation,       // 触发地点
    AxcOperationPropertiesPerformObject,  // 执行者
    AxcOperationPropertiesPerformLocation,       // 执行地点
} ;

// 基类参数属性
typedef NS_ENUM(NSInteger, AxcParameterProperties) {
    AxcParameterPropertiesName,     // 名称      0
    AxcParameterPropertiesPriority  // 优先级    1
} ;




/** 全称 Dynamic Mission Planning 动态任务规划算法 */
@interface AxcDMP_Algorithm : NSObject


// 分组，以执行者的优先级进行分线程并行处理
- (NSArray <NSArray *>*)Axc_DMP_ParallelWithArray:(NSArray <AxcEventModel *>*)eventArray
                              OperationProperties:(AxcOperationProperties )operationProperties;

// 根据事件属性对象的优先级进行排列
- (NSArray <AxcBaseModel *>*)Axc_DMP_ObjectPriorityWithArray:(NSArray <AxcBaseModel *>*)objectArray
                                                   Ascending:(BOOL )ascending;

// 对事件的小分组进行遍历按照事件优先级排列（二维数组）
- (NSArray <NSArray *>*)Axc_DMP_ParallelDimensionalWithArray:(NSArray <NSArray <AxcEventModel *>*>*)eventListArray
                                         OperationProperties:(AxcOperationProperties )operationProperties
                                                   Ascending:(BOOL )ascending;

// 取出Obj的一个属性
- (id )Axc_DMP_SwitchAttributeWithObj:(AxcConditionsBaseModel *)conditionsBaseModel
                            Parameter:(AxcParameterProperties )parameterProperties;

// 动态选择Model的属性进行比较
- (AxcConditionsBaseModel *)Axc_DMP_SwitchConditionsModelWithObj:(AxcEventModel *)eventModel
                                             OperationProperties:(AxcOperationProperties )operationProperties;

#pragma mark - 条件分析函数
// 所有条件的大背景为：这个列表里所有触发点是相同的
// 如果地点相同，且执行者、触发者不同，说明事件可以在 最快速度 移交给“线程”去执行
- (NSNumber *)Axc_PlaceSame_And_PeopleDifferent:(AxcEventModel *)model;

// 如果地点不同，行动者不同，说明事件需要在地方触发，然后交给执行者 在大背景下比较： 速度略快
- (NSNumber *)Axc_PlaceDifferent_And_PeopleDifferent:(AxcEventModel *)model;

// 如果地点和行动者都相同，说明事件需要亲自去一个地方可以全部搞定，为主线 速度略慢
- (NSNumber *)Axc_Place_PeopleSame:(AxcEventModel *)model;

// 如果地点不同，行动者相同，说明事件需要亲自移动到执行地去执行 速度最慢
- (NSNumber *)Axc_PlaceDifferent_And_PeopleSame:(AxcEventModel *)model;


@end
