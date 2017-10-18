//
//  AxcBaseModel.h
//  任务动态规划
//
//  Created by Axc on 2017/9/18.
//  Copyright © 2017年 Axc. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ModelName       @"name"
#define ModelAddDate    @"addDate"
#define ModelPriority   @"priority"
#define ModelNoteString @"noteString"

#define baseKeyArray @[ModelName,ModelPriority,ModelAddDate,ModelNoteString]

#define BaseDateFormat @"yyyy年MM月dd日 HH:mm"

#define defaultPlaceholderText @"nothing"

#define MaxPriority 10

@interface AxcBaseModel : NSObject

// 名称
@property(nonatomic, strong)NSString *name;

// 优先级
@property(nonatomic, assign)NSInteger priority;

// 添加日期
@property(nonatomic, strong)NSString *addDate;

// 备注
@property(nonatomic, strong)NSString *noteString;

// 实例函数
- (instancetype)initWithDictionary:(NSDictionary *)dict;

// 数据函数
+ (instancetype)provinceWithDictionary:(NSDictionary *)dict;

// 编码转中文函数
- (NSString *)logDataUsingEncodingDic:(NSString *)LogStr ;

// 转换字典函数
- (NSDictionary *)BaseModelWithDic;

@end
