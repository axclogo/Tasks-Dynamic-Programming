//
//  AxcEventModel.m
//  任务动态规划
//
//  Created by Axc on 2017/9/18.
//  Copyright © 2017年 Axc. All rights reserved.
//

#import "AxcEventModel.h"

#import "AxcDatabaseManagement.h"

@implementation AxcEventModel

#pragma mark - 懒加载
- (AxcObjectModel *)triggerObject{
    if (!_triggerObject) {
        _triggerObject = [[AxcObjectModel alloc] init];
    }
    return _triggerObject;
}

- (AxcObjectModel *)performObject{
    if (!_performObject) {
        _performObject = [[AxcObjectModel alloc] init];
    }
    return _performObject;
}

- (AxcLocationModel *)triggerLocation{
    if (!_triggerLocation) {
        _triggerLocation = [[AxcLocationModel alloc] init];
    }
    return _triggerLocation;
}

- (AxcLocationModel *)performLocation{
    if (!_performLocation) {
        _performLocation = [[AxcLocationModel alloc] init];
    }
    return _performLocation;
}

- (NSString *)completeDate{
    if (!_completeDate) {
        _completeDate = @"-未知-";
    }
    return _completeDate;
}

// AxcEventModel转换字典
- (NSDictionary *)eventModelWithDic{
    NSMutableDictionary *saveDic = [NSMutableDictionary dictionary];
    
    [saveDic setObject:self.name.copy  forKey:ModelName];
    [saveDic setObject:@(self.priority) forKey:ModelPriority];
    [saveDic setObject:self.addDate.copy  forKey:ModelAddDate];
    
    [saveDic setObject:[self.triggerObject BaseModelWithDic] forKey:EventModelTriggerObject];
    [saveDic setObject:[self.triggerLocation BaseModelWithDic] forKey:EventModelTriggerLocation];
    [saveDic setObject:[self.performObject BaseModelWithDic] forKey:EventModelPerformObject];
    [saveDic setObject:[self.performLocation BaseModelWithDic] forKey:EventModelPerformLocation];
    
    [saveDic setObject:@(self.eventState) forKey:EventModelEventState];
    [saveDic setObject:self.completeDate.copy  forKey:EventModelCompleteDate];
    
    return saveDic;
}


- (instancetype)initWithDictionary:(NSDictionary *)dict{
    if (self == [super initWithDictionary:dict]) {
        for (NSString *key in @[EventModelTriggerObject,EventModelTriggerLocation,EventModelPerformObject,EventModelPerformLocation]) {
            AxcConditionsBaseModel *conditionsBaseModel = [[AxcConditionsBaseModel alloc] initWithDictionary:[dict valueForKey:key]];
            [self setValue:conditionsBaseModel forKey:key];
        }
    }
    return self;
}

- (id)Axc_copy{
    return [[AxcEventModel alloc] initWithDictionary:[self eventModelWithDic]];
}

- (NSString *)description{
    return [self logDataUsingEncodingDic:[self eventModelWithDic].description];
}


@end
