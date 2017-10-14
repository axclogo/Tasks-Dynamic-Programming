//
//  AxcBaseModel.m
//  任务动态规划
//
//  Created by Axc on 2017/9/18.
//  Copyright © 2017年 Axc. All rights reserved.
//

#import "AxcBaseModel.h"
#import <objc/runtime.h>


@implementation AxcBaseModel

- (instancetype)initWithDictionary:(NSDictionary *)dict{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)provinceWithDictionary:(NSDictionary *)dict{
    return [[self alloc] initWithDictionary:dict];
}

// AxcBaseModel转换字典
- (NSDictionary *)BaseModelWithDic{
    NSMutableDictionary *saveDic = [NSMutableDictionary dictionary];
    for (NSString *key in baseKeyArray) [saveDic setObject:[self valueForKey:key] forKey:key];
    return saveDic;
}

#pragma mark - 重写比较规则
- (NSUInteger)hash{
    return self.name.length + self.name.hash + self.priority;
}

- (BOOL)isEqual:(AxcBaseModel *)object
{
    return [self isEqualToAxcModel:object];
}

- (BOOL)isEqualToAxcModel:(AxcBaseModel *)model
{
    // 如果是完全相同的对象，就省去后面的判断
    if (self == model) return YES;
    
    // 如果object的类型不对，就不需要比较
    if (![model isKindOfClass:self.class]) return NO;
    
    // 基本数据类型
    BOOL result = ([self.name isEqualToString:model.name] &&
                   self.priority == model.priority);
    if (result == NO) return result;
    
    // 对象类型,两个对象为nil时isEqual:的结果为0(NO),所以需要专门处理
    if (self.name || model.name) {
        if (![self.name isEqual:model.name]) return NO;
    }
    
    if (self.priority || model.priority) {
        if (self.priority == model.priority) return NO;
    }
    
    return YES;
}




- (NSMutableDictionary *)returnToDictionaryWithModel:(id )model Recursive:(Class )recursive{
    
    NSMutableDictionary *userDic = [NSMutableDictionary dictionary];
    unsigned int count = 0;
    objc_property_t *properties;
    if (recursive) {
        properties = class_copyPropertyList(recursive, &count);
    }else{
        properties = class_copyPropertyList([model class], &count);
        [userDic setObject:self.name forKey:@"name"];
        [userDic setObject:@(self.priority) forKey:@"priority"];
    }
    for (int i = 0; i < count; i++) {
        const char *name = property_getName(properties[i]);
        
        NSString *propertyName = [NSString stringWithUTF8String:name];
        id propertyValue = [model valueForKey:propertyName];
        if ([propertyValue isKindOfClass:[AxcBaseModel class]]) {
            [userDic setObject:[self returnToDictionaryWithModel:propertyValue Recursive:[AxcBaseModel class]] forKey:propertyName];
        }else{
            if (propertyValue) {
                [userDic setObject:propertyValue forKey:propertyName];
            }

        }
    }
    free(properties);
    
    return userDic;
}

- (NSString *)logDataUsingEncodingDic:(NSString *)LogStr {
    NSString *tempStr1 =
    [LogStr stringByReplacingOccurrencesOfString:@"\\u"
                                                 withString:@"\\U"];
    NSString *tempStr2 =
    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 =
    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *str = [NSPropertyListSerialization propertyListWithData:tempData
                                                             options:NSPropertyListMutableContainers
                                                              format:NULL
                                                               error:NULL];
    return str;
}


- (NSString *)description{
    NSString *desStr = [self returnToDictionaryWithModel:self Recursive:nil].description;
    
    NSString *str = [self logDataUsingEncodingDic:desStr];
    
    return str;
}

// 设置默认时间
- (NSString *)addDate{
    if (!_addDate) {
        _addDate = @"未被记录的时间戳";
    }
    return _addDate;
}



@end
