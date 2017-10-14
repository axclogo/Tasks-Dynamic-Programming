//
//  AxcDatabaseManagement.m
//  任务动态规划
//
//  Created by Axc on 2017/9/20.
//  Copyright © 2017年 Axc. All rights reserved.
//

#import "AxcDatabaseManagement.h"


// saveKey
#define AxcDatabaseManagementObjectModelList @"AxcDatabaseManagementObjectModelList"
#define AxcDatabaseManagementLocationModelList @"AxcDatabaseManagementLocationModelList"
// saveWaitingPlanningEventList
#define AxcSaveWaitingPlanningEventList @"AxcSaveWaitingPlanningEventList_K"
// saveAlreadyPlanningEventList
#define AxcSaveAlreadyPlanningEventList @"AxcSaveAlreadyPlanningEventList_K"


@interface AxcDatabaseManagement ()

@property(nonatomic ,strong)AxcDMP_Algorithm *axcDMP;

@end

@implementation AxcDatabaseManagement

// 添加已规划数据函数(二维数组)
- (void)addAlreadyPlanningEventListWithArray:(NSArray <NSArray <AxcEventModel *>*>*)eventList WithTitle:(NSString *)title{
    NSMutableArray <NSDictionary *>*originalDataArray = [NSMutableArray arrayWithArray:[self getAlreadyPlanningEventList]];// 获取源数据
    [originalDataArray insertObject:@{kAlreadyPlanningEventList:eventList,
                                      kAlreadyPlanningEventListTitle:title,
                                      kAlreadyPlanningEventListDate:[AMUC_Obj getNowTime]} atIndex:0]; // 插入到最前
    [self saveAlreadyPlanningEventListWithArray:originalDataArray];// 存储回去
}

// 存储已规划数据函数(三维数组)字典存储
- (void)saveAlreadyPlanningEventListWithArray:(NSArray <NSDictionary *>*)eventList{
    if (eventList) {
        NSArray *MArray_1 = [self saveAlreadyArray:eventList];
        [self saveData:MArray_1 WithKey:AxcSaveAlreadyPlanningEventList];
    }
}

// 获取已规划数据函数
- (NSArray <NSDictionary *>*)getAlreadyPlanningEventList{
    NSArray <NSDictionary *>*dataArray = [self getDataWithKey:AxcSaveAlreadyPlanningEventList];
    return dataArray?[self saveAlreadyArray:dataArray ]:nil; // 节省效率
}
// 复用函数
- (NSArray *)saveAlreadyArray:(NSArray *)MArray{
    NSMutableArray *MArray_1 = [NSMutableArray array];
    for (NSDictionary *dic_1 in MArray) {
        NSArray <NSArray <id >*>*arr1 = [dic_1 objectForKey:kAlreadyPlanningEventList];
        NSMutableArray *MArray_2 = [NSMutableArray array];
        for (NSArray <id >*arr2 in arr1) {
            NSMutableArray *MArray_3 = [NSMutableArray array];
            if ([[arr2 firstObject] isKindOfClass:[NSDictionary class]]) { // 如果是字典类型则转Model
                for (NSDictionary *dic in arr2)     [MArray_3 addObject:[[AxcEventModel alloc] initWithDictionary:dic]];
            }else{
                for (AxcEventModel *model in arr2)  [MArray_3 addObject:[model eventModelWithDic]];
            }
            [MArray_2 addObject:MArray_3];
        }
        [MArray_1 addObject:@{kAlreadyPlanningEventList:MArray_2,
                              kAlreadyPlanningEventListTitle:[dic_1 objectForKey:kAlreadyPlanningEventListTitle],
                              kAlreadyPlanningEventListDate:[dic_1 objectForKey:kAlreadyPlanningEventListDate]}];
    }
    return MArray_1;
}


// 存储待规划事件函数
- (void)saveWaitingPlanningEventListWithArray:(NSArray <AxcEventModel *>*)eventList{
    // 转换数据
    NSMutableArray *dataArr = [NSMutableArray array];
    [eventList enumerateObjectsUsingBlock:^(AxcEventModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [dataArr addObject:[obj eventModelWithDic]];
    }];
    [self saveData:dataArr WithKey:AxcSaveWaitingPlanningEventList];
}
// 获取待规划事件函数
- (NSArray <AxcEventModel *>*)getWaitingPlanningEventList{
    NSArray <NSDictionary *>*eventList = [self getDataWithKey:AxcSaveWaitingPlanningEventList];
    NSMutableArray *dataArr = [NSMutableArray array];
    [eventList enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        AxcEventModel *model = [[AxcEventModel alloc] initWithDictionary:obj];
        [dataArr addObject:model];
    }];
    return dataArr;
}


//  获取所有行动信息列表
- (NSArray <AxcConditionsBaseModel *>*)getObjectModelListWithType:(AxcActionDataType )type{
    NSString *typeKey = [self keyWithType:type];
    
    NSArray *getObjectModelListArray = [self getDataWithKey:typeKey];
    if (!getObjectModelListArray) {
        switch (type) { // 预设数据
            case AxcActionDataTypeObjectModelList:  // 设置行动者预设数据
                getObjectModelListArray = DefaultObject; break;
            case AxcActionDataTypeLocationModelList:  // 设置行动地点预设数据
                getObjectModelListArray = DefaultLocation; break;
            default: break;
        }
    }
    // 转换模型
    NSMutableArray *modelTransformationListArray = [NSMutableArray array];
    [getObjectModelListArray enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        AxcConditionsBaseModel *obj_Model = [AxcConditionsBaseModel provinceWithDictionary:obj];
        [modelTransformationListArray addObject:obj_Model];
    }];
    return modelTransformationListArray;
}

// 存储所有行动信息列表
- (void)saveObjectModelList:(NSArray <AxcConditionsBaseModel *>*)objectModelListArray
               SaveWithType:(AxcActionDataType )type{
    NSMutableArray *saveModelListArray = [NSMutableArray array];
    // 转换数组数据
    [objectModelListArray enumerateObjectsUsingBlock:^(AxcConditionsBaseModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [saveModelListArray addObject:[obj BaseModelWithDic]];
    }];
    NSString *typeKey = [self keyWithType:type];
    [self saveData:saveModelListArray WithKey:typeKey];
}

// 获取所有行动信息的标题集合
- (NSArray <NSDictionary *>*)getObjectModelTitleListWithType:(AxcActionDataType )type{
    NSArray <AxcConditionsBaseModel *>*eventModelArray = [self getObjectModelListWithType:type];
    NSMutableArray *eventTitleArray = [NSMutableArray array];
    [eventModelArray enumerateObjectsUsingBlock:^(AxcConditionsBaseModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [eventTitleArray addObject:[obj BaseModelWithDic]];
    }];
    return eventTitleArray;
}

// 获取这个Model四要素的文字标题数组
- (NSArray <NSString *>*)AxcBase_elementsContentNameArrayWithModel:(AxcEventModel *)model{
    NSMutableArray *fourElementsArray = [NSMutableArray array];
    for (int i = 0; i < 4; i ++) {
        AxcConditionsBaseModel *conditionsModel = [self.axcDMP Axc_DMP_SwitchConditionsModelWithObj:model
                                                                                OperationProperties:i];
        [fourElementsArray addObject:conditionsModel.name];
    }
    return fourElementsArray;
}

// 修改Model的某个属性
- (void)changeEventModel:(AxcEventModel *)model
         ConditionsModel:(AxcConditionsBaseModel *)conditionsModel
          WithProperties:(AxcOperationProperties)properties{
    switch (properties) { // 生成一个事件建模
        case AxcOperationPropertiesTriggerObject: // 触发者
            model.triggerObject = (AxcObjectModel *)conditionsModel; break;
        case AxcOperationPropertiesTriggerLocation: // 触发地点
            model.triggerLocation = (AxcLocationModel *)conditionsModel; break;
        case AxcOperationPropertiesPerformObject: // 执行者
            model.performObject = (AxcObjectModel *)conditionsModel; break;
        case AxcOperationPropertiesPerformLocation: // 执行地点
            model.performLocation = (AxcLocationModel *)conditionsModel; break;
        default:   break;
    }
}



// 根据类型获取存取Key值
- (NSString *)keyWithType:(AxcActionDataType )type{
    NSString *typeKey = nil;
    switch (type) {
        case AxcActionDataTypeObjectModelList: typeKey = AxcDatabaseManagementObjectModelList; break;
        case AxcActionDataTypeLocationModelList: typeKey = AxcDatabaseManagementLocationModelList; break;
        default: break;
    }
    return typeKey;
}

// 存放一个数据到标记Key值
- (void)saveData:(nullable id )data WithKey:(nonnull NSString *)aKey{
    if (data) {
        [self.userDefaults setObject:data forKey:aKey];
        [self.userDefaults synchronize];
    }else{
        NSLog(@"警告！检测到存储空值！\n数据组：%@\nKey值为：%@的存储数据",data,aKey);
    }
}
// 取出一个数据使用Key
- (nullable id )getDataWithKey:(nonnull NSString *)aKey{
    return [self.userDefaults objectForKey:aKey];
}

#pragma mark - 懒加载
// 动态任务规划对象
- (AxcDMP_Algorithm *)axcDMP{
    if (!_axcDMP) {
        _axcDMP = [[AxcDMP_Algorithm alloc] init];
    }
    return _axcDMP;
}

- (NSUserDefaults *)userDefaults{
    return [NSUserDefaults standardUserDefaults];
}

@end

