//
//  AxcDatabaseManagement.h
//  任务动态规划
//
//  Created by Axc on 2017/9/20.
//  Copyright © 2017年 Axc. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DefaultObject @[@{ModelName:@"我",ModelPriority:@1},\
@{ModelName:@"电脑",ModelPriority:@2},\
@{ModelName:@"洗衣机",ModelPriority:@3},\
@{ModelName:@"朋友",ModelPriority:@4},\
@{ModelName:@"邻居",ModelPriority:@5},\
@{ModelName:@"同事",ModelPriority:@6},\
@{ModelName:@"客户",ModelPriority:@7}]

#define DefaultLocation @[@{ModelName:@"家",ModelPriority:@1},\
@{ModelName:@"楼下",ModelPriority:@2},\
@{ModelName:@"餐馆",ModelPriority:@3},\
@{ModelName:@"广场",ModelPriority:@4},\
@{ModelName:@"公司",ModelPriority:@5},\
@{ModelName:@"市中心",ModelPriority:@6},\
@{ModelName:@"省外",ModelPriority:@7}]





#define EventModelCompleteDate   @"completeDate"
#define EventModelEventState     @"eventState"

// 已保存事件的各项Key值
#define kAlreadyPlanningEventList       @"kAlreadyPlanningEventList_K"
#define kAlreadyPlanningEventListTitle  @"kAlreadyPlanningEventListTitle_K"
#define kAlreadyPlanningEventListDate   @"kAlreadyPlanningEventListDate_K"

// 事件模型
#import "AxcDMP_Algorithm.h"
// 模型数据控制器
#import "AMUC_Obj.h"

// 行动数据类型
typedef NS_ENUM(NSInteger, AxcActionDataType) {
    AxcActionDataTypeObjectModelList,   // 行动者      0
    AxcActionDataTypeLocationModelList  // 行动地点     1
} ;

// 存取数据类型
typedef NS_ENUM(NSInteger, AxcAccessDataType) {
    AxcAccessDataTypeDictionary,   // 字典类型      0
    AxcAccessDataTypeEventModel    // 事件模型      1
} ;

@interface AxcDatabaseManagement : NSObject

@property(nonatomic, strong)NSUserDefaults *userDefaults;

//  获取所有行动信息列表
- (NSArray <AxcConditionsBaseModel *>*)getObjectModelListWithType:(AxcActionDataType )type;
// 存储所有行动信息列表
- (void)saveObjectModelList:(NSArray <AxcConditionsBaseModel *>*)objectModelListArray
               SaveWithType:(AxcActionDataType )type;

// 获取所有行动信息的标题集合
- (NSArray <NSDictionary *>*)getObjectModelTitleListWithType:(AxcActionDataType )type;
// 获取这个Model四要素的文字标题数组
- (NSArray <NSString *>*)AxcBase_elementsContentNameArrayWithModel:(AxcEventModel *)model;
// 修改Model的某个要素属性
- (void)changeEventModel:(AxcEventModel *)model
         ConditionsModel:(AxcConditionsBaseModel *)conditionsModel
          WithProperties:(AxcOperationProperties)properties;

// 待规划事件存储函数
- (void)saveWaitingPlanningEventListWithArray:(NSArray <AxcEventModel *>*)eventList;
// 获取待规划事件函数
- (NSArray <AxcEventModel *>*)getWaitingPlanningEventList;


// 添加已规划数据函数(二维数组)
- (void)addAlreadyPlanningEventListWithArray:(NSArray <NSArray <AxcEventModel *>*>*)eventList WithTitle:(NSString *)title;

// 存储已规划数据函数(三维数组)
- (void)saveAlreadyPlanningEventListWithArray:(NSArray <NSDictionary *>*)eventList;
// 获取已规划数据函数
- (NSArray <NSDictionary *>*)getAlreadyPlanningEventList;


@end
