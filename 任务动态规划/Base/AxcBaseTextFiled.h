//
//  AxcBaseTextFiled.h
//  任务动态规划
//
//  Created by Axc on 2017/10/10.
//  Copyright © 2017年 Axc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AxcBaseTextFiled : UITextField

typedef void(^AxcBaseTextFiledShouldChange)(NSString *text);
@property (nonatomic,strong) AxcBaseTextFiledShouldChange AxcBase_textFiledShouldChange;

@property(nonatomic, assign)CGFloat leftAlignment;

@end
