//
//  AxcBaseTextView.m
//  任务动态规划
//
//  Created by Axc on 2017/10/19.
//  Copyright © 2017年 Axc. All rights reserved.
//

#import "AxcBaseTextView.h"

@implementation AxcBaseTextView

- (instancetype)init{
    if (self == [super init]) {
        self.dataDetectorTypes = UIDataDetectorTypeAll;
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 5;
        self.layer.borderWidth = 1;
        self.layer.borderColor = [Axc_ThemeColorTwoCollocation CGColor];
    }
    return self;
}

@end
