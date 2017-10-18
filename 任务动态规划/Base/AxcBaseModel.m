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





- (NSMutableDictionary *)returnToDictionaryWithModel:(id )model Recursive:(Class )recursive{
    
    NSMutableDictionary *userDic = [NSMutableDictionary dictionary];
    unsigned int count = 0;
    objc_property_t *properties;
    if (recursive) {
        properties = class_copyPropertyList(recursive, &count);
    }else{
        properties = class_copyPropertyList([model class], &count);
        [userDic setObject:self.name forKey:ModelName];
        [userDic setObject:self.addDate forKey:ModelAddDate];
        [userDic setObject:@(self.priority) forKey:ModelPriority];
        [userDic setObject:self.noteString forKey:ModelNoteString];
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
        _addDate = defaultPlaceholderText;
    }
    return _addDate;
}

// 设置默认备注
- (NSString *)noteString{
    if (!_noteString) {
        _noteString = defaultPlaceholderText;
    }
    return _noteString;
}


@end
