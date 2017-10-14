//
//  AxcBaseButton.m
//  任务动态规划
//
//  Created by Axc on 2017/9/18.
//  Copyright © 2017年 Axc. All rights reserved.
//

#import "AxcBaseButton.h"

@implementation AxcBaseButton

- (instancetype)init{
    if (self == [super init]) {
        [self createUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self == [super initWithCoder:aDecoder]) {
        [self createUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}


- (void)createUI{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5;
    
    self.backgroundColor = [UIColor AxcUI_CloudColor];
    [self setTitleColor:[UIColor AxcUI_WetAsphaltColor] forState:UIControlStateNormal];

}

@end
