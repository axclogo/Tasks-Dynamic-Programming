//
//  AMUC_Obj.m
//  任务动态规划
//
//  Created by Axc on 2017/10/11.
//  Copyright © 2017年 Axc. All rights reserved.
//

#import "AMUC_Obj.h"


// Axc Model UI Control
@implementation AMUC_Obj

+ (AxcAS *)simulateEventDescriptionWithModel:(AxcEventModel *)model{
    return [self simulateEventDescriptionWithModel:model PredicateColor:nil];
}

+ (AxcAS *)simulateEventDescriptionWithModel:(AxcEventModel *)model PredicateColor:(UIColor *)color{
    // 进行模组名称染色
    AxcAS *triggerObjectName    = [self dyeingColorWithContent:model.triggerObject.name     Color:[UIColor AxcUI_AlizarinColor]];
    AxcAS *triggerLocationName  = [self dyeingColorWithContent:model.triggerLocation.name   Color:[UIColor AxcUI_PumpkinColor]];
    AxcAS *performObjectName    = [self dyeingColorWithContent:model.performObject.name     Color:[UIColor AxcUI_CarrotColor]];
    AxcAS *performLocationName  = [self dyeingColorWithContent:model.performLocation.name   Color:[UIColor AxcUI_OrangeColor]];
    AxcAS *modelName            = [self dyeingColorWithContent:model.name                   Color:[UIColor redColor]];

    AxcDMP_Algorithm *DMP = [[AxcDMP_Algorithm alloc] init];
    AxcAS *mainAttStr = [[AxcAS alloc] init];

    // 生成事件描述
    if ([[DMP Axc_PlaceSame_And_PeopleDifferent:model] integerValue]) {// 如果地点相同，且执行者、触发者不同
        
        [mainAttStr appendAttributedString:triggerObjectName];
        [mainAttStr appendAttributedString:[self AS_WithContent:@"将在" Color:color]];
        [mainAttStr appendAttributedString:triggerLocationName];
        [mainAttStr appendAttributedString:[self AS_WithContent:@"和" Color:color]];
        [mainAttStr appendAttributedString:performObjectName];
        [mainAttStr appendAttributedString:[self AS_WithContent:@"共同完成" Color:color]];
        [mainAttStr appendAttributedString:modelName];

    }else if ([[DMP Axc_PlaceDifferent_And_PeopleDifferent:model] integerValue]){// 如果地点不同，行动者不同
        
        [mainAttStr appendAttributedString:triggerObjectName];
        [mainAttStr appendAttributedString:[self AS_WithContent:@"将在" Color:color]];
        [mainAttStr appendAttributedString:triggerLocationName];
        [mainAttStr appendAttributedString:[self AS_WithContent:@"将" Color:color]];
        [mainAttStr appendAttributedString:modelName];
        [mainAttStr appendAttributedString:[self AS_WithContent:@"交给" Color:color]];
        [mainAttStr appendAttributedString:performObjectName];
        [mainAttStr appendAttributedString:[self AS_WithContent:@"去" Color:color]];
        [mainAttStr appendAttributedString:performLocationName];
        [mainAttStr appendAttributedString:[self AS_WithContent:@"完成" Color:color]];
        
    }else if ([[DMP Axc_Place_PeopleSame:model] integerValue]){// 如果地点和行动者都相同
        
        [mainAttStr appendAttributedString:triggerObjectName];
        [mainAttStr appendAttributedString:[self AS_WithContent:@"将在" Color:color]];
        [mainAttStr appendAttributedString:triggerLocationName];
        [mainAttStr appendAttributedString:[self AS_WithContent:@"完成" Color:color]];
        [mainAttStr appendAttributedString:modelName];
        
    }else if ([[DMP Axc_PlaceDifferent_And_PeopleSame:model] integerValue]){// 如果地点不同，行动者相同
        
        [mainAttStr appendAttributedString:triggerObjectName];
        [mainAttStr appendAttributedString:[self AS_WithContent:@"将在" Color:color]];
        [mainAttStr appendAttributedString:triggerLocationName];
        [mainAttStr appendAttributedString:[self AS_WithContent:@"出发去" Color:color]];
        [mainAttStr appendAttributedString:performLocationName];
        [mainAttStr appendAttributedString:[self AS_WithContent:@"完成" Color:color]];
        [mainAttStr appendAttributedString:modelName];
    }
    return mainAttStr;
}



// 进行染色
+ (AxcAS *)dyeingColorWithContent:(NSString *)content Color:(UIColor *)color{
    AxcAS *attrStr = [[AxcAS alloc] initWithString:content];
    [attrStr addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, content.length)];
    return attrStr;
}

// 生成谓词富文本
+ (AxcAS *)AS_WithContent:(NSString *)content Color:(UIColor *)color{
    AxcAS *attrStr = [[AxcAS alloc] initWithString:[NSString stringWithFormat:@" %@ ",content]];
    if (color) [attrStr addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, attrStr.length)];
    return attrStr;
}


#pragma mark - 时间转换
+ (NSString *)getNowTime{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:BaseDateFormat];
    return [formatter stringFromDate:date];
}

+ (NSString *)getTimeInvervalFromDateString:(NSString *)dateString andFormateString:(NSString *)formate{
    if (!dateString.length) {
        return @"未知";
    }
    NSDate *date = [self dateFromString:dateString andFormate:formate];
    NSDateComponents *inverval = [self timeCal:date dateAfter:[NSDate date]];
    
    if (inverval.year > 0) {
        return dateString;
    } else if (inverval.month > 0) {
        return dateString;
    } else if (inverval.day > 2) {
        return dateString;
    } else if (inverval.day > 1) {
        return @"前天";
    } else if (inverval.day > 0) {
        return @"昨天";
    } else if (inverval.hour > 0) {
        return [NSString stringWithFormat:@"%@小时前",@(inverval.hour)];
    } else if (inverval.minute > 0) {
        return [NSString stringWithFormat:@"%@分钟前",@(inverval.minute)];
    } else {
        return @"刚刚";
    }
}

#pragma mark - 私有方法
+ (NSDate*)dateFromString:(NSString*)dateString andFormate:(NSString*)formateString
{
    if (dateString.length < 1) {
        return [NSDate date];
    }
    
    NSDateFormatter * formate = [[NSDateFormatter alloc]init];
    [formate setDateFormat:formateString];
    
    NSDate * date = [formate dateFromString:dateString];
    
    return date;
}

+ (NSString*)dateTransform:(NSString*)dateString{
    if (dateString.length<1) {
        return @"";
    }
    
    NSDateFormatter *formate = [[NSDateFormatter alloc]init];
    [formate setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    
    NSDate *date = [formate dateFromString:dateString];
    
    NSDateFormatter *resultFormate = [[NSDateFormatter alloc]init];
    [resultFormate setDateFormat:@"yyyy-MM-dd HH:mm"];
    
    return [resultFormate stringFromDate:date];
}

/**
 *  计算时间差
 *
 *  @param dateBefore 时间1
 *  @param dateAfter  时间2
 *
 *  @return 时差 小时
 */
+(NSDateComponents*)timeCal:(NSDate*)dateBefore dateAfter:(NSDate*)dateAfter;
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    NSDateComponents *d = [cal components:unitFlags fromDate:dateBefore toDate:dateAfter options:0];
    
    return d;
}

@end

