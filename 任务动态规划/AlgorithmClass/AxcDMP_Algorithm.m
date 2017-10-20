//
//  AxcDMP_Algorithm.m
//  任务动态规划
//
//  Created by Axc on 2017/9/18.
//  Copyright © 2017年 Axc. All rights reserved.
//

#import "AxcDMP_Algorithm.h"

#define Tag 0

#if Tag
# define AxcLog printf("[%s<%p>行号:%d]\n",__FUNCTION__,self,__LINE__)
#else
# define AxcLog ;
#endif


// CFOK全称：Conditions Function Option Keys 条件函数签名
const struct AxcConditionsFunctionOption AxcCFOK = {
    .Axc_PlaceSame_And_PeopleDifferent      = @"Axc_PlaceSame_And_PeopleDifferent:",
    .Axc_PlaceDifferent_And_PeopleDifferent = @"Axc_PlaceDifferent_And_PeopleDifferent:",
    .Axc_Place_PeopleSame                   = @"Axc_Place_PeopleSame:",
    .Axc_PlaceDifferent_And_PeopleSame      = @"Axc_PlaceDifferent_And_PeopleSame:",
    
    .Axc_EventWithPriority                  = @"Axc_EventWithPriority:",
};


@implementation AxcDMP_Algorithm

#pragma mark - 开放函数
// 对事件的小分组进行遍历按照事件优先级排列（二维数组）
- (NSArray <NSArray *>*)Axc_DMP_ParallelDimensionalWithArray:(NSArray <NSArray <AxcEventModel *>*>*)eventListArray
                                         OperationProperties:(AxcOperationProperties )operationProperties
                                                   Ascending:(BOOL )ascending{
    NSMutableArray *array_M_1 = [NSMutableArray array];
    [eventListArray enumerateObjectsUsingBlock:^(NSArray <AxcEventModel *>* _Nonnull eventArray, NSUInteger k, BOOL * _Nonnull stop) {
        NSMutableArray *eventDataArray = [NSMutableArray array];
        // 所有事件的优先级特例，全部排列最高级
        // 所以先区分是否携带有优先级
        NSArray <NSArray *>*priorityArray = [self conditionsSetUpCollection:eventArray
                                                         ConditionsFunction:@[AxcCFOK.Axc_EventWithPriority]];
        NSArray <AxcEventModel *>*havePriorityArray = [priorityArray firstObject]; // 拥有优先级的组
        NSArray <AxcEventModel *>*noPriorityArray   = [priorityArray lastObject];  // 无优先级的组
        
        // 快速遍历优先级划分的两个组
        // 降序优先级，数值越高的放前头
        havePriorityArray = (NSArray *)[self Axc_DMP_ObjectPriorityWithArray:havePriorityArray Ascending:NO];
        
        // 根据条件来做自动优先级分割
        NSArray *placeArray = [self conditionsSetUpCollection:noPriorityArray
                                           ConditionsFunction:@[AxcCFOK.Axc_PlaceSame_And_PeopleDifferent,
                                                                AxcCFOK.Axc_PlaceDifferent_And_PeopleDifferent,
                                                                AxcCFOK.Axc_Place_PeopleSame,
                                                                AxcCFOK.Axc_PlaceDifferent_And_PeopleSame ]];
        // 对内部元素进行优先级升序排序
        NSArray *placeArrayCJ = [self groupingAscendingOrder:placeArray OperationProperties:operationProperties Ascending:ascending];
        // 再将两个组合并
        [eventDataArray addObjectsFromArray:havePriorityArray];
        [eventDataArray addObjectsFromArray:placeArrayCJ];
        
        [array_M_1 addObject: eventDataArray];
    }];
    return array_M_1;
}





#pragma mark - 条件函数
// 所有条件的大背景为：这个列表里所有触发点是相同的
// 如果地点相同，且执行者、触发者不同，说明事件可以在 最快速度 移交给“线程”去执行
- (NSNumber *)Axc_PlaceSame_And_PeopleDifferent:(AxcEventModel *)model{
    AxcLog;
    return @([model.triggerLocation.name isEqualToString:model.performLocation.name] &&
             ![model.triggerObject.name isEqualToString:model.performObject.name]);
}

// 如果地点不同，行动者不同，说明事件需要在地方触发，然后交给执行者 在大背景下比较： 速度略快
- (NSNumber *)Axc_PlaceDifferent_And_PeopleDifferent:(AxcEventModel *)model{
    AxcLog;
    return @(![model.triggerLocation.name isEqualToString:model.performLocation.name] &&
             ![model.triggerObject.name isEqualToString:model.performObject.name]);
}

// 如果地点和行动者都相同，说明事件需要亲自去一个地方可以全部搞定，为主线 速度略慢
- (NSNumber *)Axc_Place_PeopleSame:(AxcEventModel *)model{
    AxcLog;
    return @([model.triggerLocation.name isEqualToString:model.performLocation.name] &&
             [model.triggerObject.name isEqualToString:model.performObject.name]);
}

// 如果地点不同，行动者相同，说明事件需要亲自移动到执行地去执行 速度最慢
- (NSNumber *)Axc_PlaceDifferent_And_PeopleSame:(AxcEventModel *)model{
    AxcLog;
    return @(![model.triggerLocation.name isEqualToString:model.performLocation.name] &&
             [model.triggerObject.name isEqualToString:model.performObject.name]);
}

// 如果事件模型携带优先级属性
- (NSNumber *)Axc_EventWithPriority:(AxcEventModel *)model{
    AxcLog;
    return @(model.priority);
}



#pragma mark -





#pragma mark - 复用函数部分
// 条件集合进行小组- 分 -小组的条件 -升序-排序
- (NSArray <NSArray *>*)conditionsSetUpCollection:(NSArray <AxcEventModel *>*)setUpArr
                               ConditionsFunction:(NSArray <NSString *>*)conditionsFunction{
    // 根据条件数据开辟数组集合
    NSMutableArray *functionCollectionArray = [NSMutableArray array];
    [conditionsFunction enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [functionCollectionArray addObject:[NSMutableArray array]];
    }];
    // 最后一个“其他”事件的承接额外ELSE数组
    NSMutableArray *otherELSE_Array = [NSMutableArray array];
    // 过滤筛选数组
    NSMutableArray *filterArray = [NSMutableArray arrayWithArray:setUpArr];

    // 遍历条件
    NSInteger idx = 0;
    for (NSString * _Nonnull functionName in conditionsFunction) {
        NSMutableArray *conditions = [functionCollectionArray objectAtIndex:idx];

        if (otherELSE_Array.count) {
            filterArray = [NSMutableArray arrayWithArray:otherELSE_Array];
        }else{ if (idx) filterArray = nil; } // 如果不是第一次遍历，并且其他元素没有，那就置空禁止循环，节省性能
        
        [otherELSE_Array removeAllObjects]; // 清空所有
        [filterArray enumerateObjectsUsingBlock:^(AxcEventModel * _Nonnull eventModel, NSUInteger j, BOOL * _Nonnull stop) {
            // 获取条件函数中的判断值
            BOOL conditionsFunctionBool = [[self performFunctionName:functionName
                                                         withObjects:@[eventModel]] integerValue];
            if (conditionsFunctionBool) {
                // 条件达成，则添加这个事件模型
                [conditions addObject:eventModel];
            }else{ // 其他剩余事件任务的集合
                [otherELSE_Array addObject:eventModel];
            }
        }];
        // 相同分类组中的事件需要再以执行地点的优先级进行升序操作
        conditions = (NSMutableArray *)[self Axc_DMP_ObjectPriorityWithArrayForSortingWithArray:conditions
                                                                                      Ascending:YES
                                                                            OperationProperties:AxcOperationPropertiesPerformLocation];
        // 替换更新集合
        [functionCollectionArray replaceObjectAtIndex:idx withObject:conditions];
        idx ++;
    }
    // 添加其他事件
    [functionCollectionArray addObject:otherELSE_Array];
    return functionCollectionArray;
}


// 对特殊分组进行遍历，并且以所有小分组进行优先级升序排序
- (NSArray <AxcEventModel *>*)groupingAscendingOrder:(NSArray <NSArray <AxcEventModel *>*>*)orderArr
                                 OperationProperties:(AxcOperationProperties )operationProperties
                                           Ascending:(BOOL )ascending{
    // 承接数组
    NSMutableArray *placeArrayCJ = [NSMutableArray array];
    // 对所有小型分组进行优先级排序
    [orderArr enumerateObjectsUsingBlock:^(NSArray * _Nonnull locationArray, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableArray *locationSortingArray = [NSMutableArray arrayWithArray:locationArray];
        //
        [locationSortingArray enumerateObjectsUsingBlock:^(AxcEventModel * _Nonnull model_i, NSUInteger i, BOOL * _Nonnull stop) {
            AxcConditionsBaseModel *objectModel_i = [self Axc_DMP_SwitchConditionsModelWithObj:model_i
                                                                           OperationProperties:operationProperties];
            [locationSortingArray enumerateObjectsUsingBlock:^(AxcEventModel * _Nonnull model_j, NSUInteger j, BOOL * _Nonnull stop) {
                AxcConditionsBaseModel *objectModel_j = [self Axc_DMP_SwitchConditionsModelWithObj:model_j
                                                                               OperationProperties:operationProperties];
                // 根据是否升序进行三目 从小到大
                if ([self TernaryJudgmentAscending:ascending M1:objectModel_j M2:objectModel_i
                                         Parameter:AxcParameterPropertiesPriority]) { // 优先级数值小(高)（优先级数值越小，级别越低）
                    [locationSortingArray exchangeObjectAtIndex:i withObjectAtIndex:j];
                }
            }];
        }];// 将两个组的数据进行拼接
        
        [placeArrayCJ addObjectsFromArray:locationSortingArray];
    }];
    return placeArrayCJ;
}


// 以OperationProperties进行分线程分组处理，生成二维数组
- (NSArray <NSArray *>*)Axc_DMP_ParallelWithArray:(NSArray <AxcEventModel *>*)eventArray
                              OperationProperties:(AxcOperationProperties )operationProperties{
    // 以所有触发地点的个数的优先级进行排序
    NSArray <AxcConditionsBaseModel *>*parallelArray = [self Axc_DMP_ObjectThreadWithArray:eventArray
                                                                       OperationProperties:operationProperties];
    // 并行优先级进行排序，不升序，其他能进行的线程优先执行，推进事件效率
    parallelArray = (NSArray <AxcConditionsBaseModel *>*)[self Axc_DMP_ObjectPriorityWithArray:parallelArray
                                                                                     Ascending:YES];
    // 创建输出数组
    NSMutableArray *returnArray = [NSMutableArray array];
    [parallelArray enumerateObjectsUsingBlock:^(AxcConditionsBaseModel * _Nonnull conditionsBase, NSUInteger j, BOOL * _Nonnull stop) {
        // 创建一个线程组
        NSMutableArray *oneWayArr = [NSMutableArray array];
        [eventArray enumerateObjectsUsingBlock:^(AxcEventModel * _Nonnull obj, NSUInteger i, BOOL * _Nonnull stop) {

            AxcConditionsBaseModel *objectModel = [self Axc_DMP_SwitchConditionsModelWithObj:obj
                                                                         OperationProperties:operationProperties];
            // 取出name属性
            NSString *objectName = [self Axc_DMP_SwitchAttributeWithObj:objectModel Parameter:AxcParameterPropertiesName];
            if ([objectName isEqualToString:conditionsBase.name]) { // 如果执行者匹配
                [oneWayArr addObject:obj];  // 添加进单线程
            }
        }];
        [returnArray addObject:oneWayArr];
    }];
    return returnArray;
}

// 获取以执行者/触发地点分组的线程数组
- (NSArray <AxcConditionsBaseModel *>*)Axc_DMP_ObjectThreadWithArray:(NSArray <AxcEventModel *>*)objectArray
                                                 OperationProperties:(AxcOperationProperties )operationProperties{
    // 获取一共能并行几条线
    NSMutableArray <AxcConditionsBaseModel *>*threadArray = [NSMutableArray array];   // 线程数组
    [objectArray enumerateObjectsUsingBlock:^(AxcEventModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

        // 使用Model取出执行者对象
        AxcConditionsBaseModel *objectModel = [self Axc_DMP_SwitchConditionsModelWithObj:obj
                                                                     OperationProperties:operationProperties];
        BOOL addBol = YES;
        for (AxcConditionsBaseModel *threadObj in threadArray) {
            // 使用名称字符串进行比较递进处理  一旦有了一样的元素
            if ([objectModel.name isEqualToString:threadObj.name] )  addBol = NO;  // 拒绝添加
        } // 无元素或者可以添加的时候添加
        if (!threadArray.count || addBol) [threadArray addObject:objectModel];
    }];
    return threadArray;
}

// 对事件中，某个对象的优先级进行排序
- (NSArray *)Axc_DMP_ObjectPriorityWithArrayForSortingWithArray:(NSArray <AxcEventModel *>*)objectArray
                                                      Ascending:(BOOL )ascending
                                            OperationProperties:(AxcOperationProperties )operationProperties{
    NSMutableArray <AxcEventModel *>*eventArray_M = [NSMutableArray arrayWithArray:objectArray];
    [eventArray_M enumerateObjectsUsingBlock:^(AxcEventModel * _Nonnull i_obj, NSUInteger i_idx, BOOL * _Nonnull stop) {
        [eventArray_M enumerateObjectsUsingBlock:^(AxcEventModel * _Nonnull j_obj, NSUInteger j_idx, BOOL * _Nonnull stop) {
            AxcConditionsBaseModel *i_objP = [self Axc_DMP_SwitchConditionsModelWithObj:i_obj
                                                                    OperationProperties:operationProperties];
            AxcConditionsBaseModel *j_objP = [self Axc_DMP_SwitchConditionsModelWithObj:j_obj
                                                                    OperationProperties:operationProperties];
            // 根据是否升序进行三目
            if ([self TernaryJudgmentAscending:ascending M1:j_objP M2:i_objP
                                     Parameter:AxcParameterPropertiesPriority]) { // 优先级数值小(高)（优先级数值越小，级别越低）
                [eventArray_M exchangeObjectAtIndex:i_idx withObjectAtIndex:j_idx];
            }
        }];
    }];
    return eventArray_M;
}

// 根据事件属性对象的优先级进行排列
- (NSArray <AxcBaseModel *>*)Axc_DMP_ObjectPriorityWithArray:(NSArray <AxcBaseModel *>*)objectArray
                                                   Ascending:(BOOL )ascending{
    NSMutableArray <AxcBaseModel *>*eventArray_M = [NSMutableArray arrayWithArray:objectArray];
    [eventArray_M enumerateObjectsUsingBlock:^(AxcBaseModel * _Nonnull iobj, NSUInteger i, BOOL * _Nonnull istop) {
        [eventArray_M enumerateObjectsUsingBlock:^(AxcBaseModel * _Nonnull jobj, NSUInteger j, BOOL * _Nonnull jstop) {
            // 根据是否升序进行三目
            if ([self TernaryJudgmentAscending:ascending M1:jobj M2:iobj
                                     Parameter:AxcParameterPropertiesPriority]) { // 优先级数值小(高)（优先级数值越小，级别越低）
                [eventArray_M exchangeObjectAtIndex:i withObjectAtIndex:j];
            }
        }];
    }];
    return eventArray_M;
}


// 动态选择Model的属性进行比较
- (AxcConditionsBaseModel *)Axc_DMP_SwitchConditionsModelWithObj:(AxcEventModel *)eventModel
                                             OperationProperties:(AxcOperationProperties )operationProperties{
    AxcConditionsBaseModel *objectModel = [[AxcConditionsBaseModel alloc] init];
    switch (operationProperties) {
        case AxcOperationPropertiesPerformObject: objectModel   = eventModel.performObject  ; break;
        case AxcOperationPropertiesTriggerObject: objectModel   = eventModel.triggerObject  ; break;
        case AxcOperationPropertiesPerformLocation: objectModel = eventModel.performLocation; break;
        case AxcOperationPropertiesTriggerLocation: objectModel = eventModel.triggerLocation; break;
        default: break;
    }
    return objectModel;
}

// 动态选择属性名称
- (NSString *)parameterProperties:(AxcParameterProperties)parameterProperties{
    NSString *parameterStr = nil;
    switch (parameterProperties) {
        case AxcParameterPropertiesName:     parameterStr = ModelName;     break;
        case AxcParameterPropertiesPriority: parameterStr = ModelPriority; break;
        default: break;
    }
    return parameterStr;
}

// 取出Obj的一个属性
- (id )Axc_DMP_SwitchAttributeWithObj:(AxcConditionsBaseModel *)conditionsBaseModel
                            Parameter:(AxcParameterProperties )parameterProperties{
    NSString *parameterStr = [self parameterProperties:parameterProperties];
    return  [conditionsBaseModel valueForKey:parameterStr];
}

// 根据升降序进行比较优先级以及名称
- (BOOL )TernaryJudgmentAscending:(BOOL )ascending
                               M1:(AxcBaseModel *)m1
                               M2:(AxcBaseModel *)m2
                        Parameter:(AxcParameterProperties)parameterProperties{
    BOOL compareBool = NO;
    NSString *parameterStr = [self parameterProperties:parameterProperties];
    id m1_Value = [m1 valueForKey:parameterStr] ;
    id m2_Value = [m2 valueForKey:parameterStr] ;
    compareBool = ascending?
    [m1_Value floatValue] > [m2_Value floatValue]:
    [m1_Value floatValue] < [m2_Value floatValue];
    
    return compareBool;
}

// 根据函数名称执行函数
- (id)performFunctionName:(NSString *)functionName withObjects:(NSArray *)objects{
    SEL selector = NSSelectorFromString(functionName);
    // 方法签名(方法的描述)
    NSMethodSignature *signature = [[self class] instanceMethodSignatureForSelector:selector];
    if (signature == nil) {
        //可以抛出异常也可以不操作。
    }
    // NSInvocation : 利用一个NSInvocation对象包装一次方法调用（方法调用者、方法名、方法参数、方法返回值）
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    invocation.target = self;
    invocation.selector = selector;
    // 设置参数
    NSInteger paramsCount = signature.numberOfArguments - 2; // 除self、_cmd以外的参数个数
    paramsCount = MIN(paramsCount, objects.count);
    for (NSInteger i = 0; i < paramsCount; i++) {
        id object = objects[i];
        if ([object isKindOfClass:[NSNull class]]) continue;
        [invocation setArgument:&object atIndex:i + 2];
    }
    // 调用方法
    [invocation invoke];
    
    // 获取返回值
    id returnValue = nil;
    if (signature.methodReturnLength) { // 有返回值类型，才去获得返回值
        [invocation getReturnValue:&returnValue];
    }
    return returnValue;
}


@end
