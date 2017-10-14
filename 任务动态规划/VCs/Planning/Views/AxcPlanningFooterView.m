//
//  AxcPlanningFooterView.m
//  任务动态规划
//
//  Created by Axc on 2017/9/25.
//  Copyright © 2017年 Axc. All rights reserved.
//

#import "AxcPlanningFooterView.h"

@implementation AxcPlanningFooterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI{
    
    self.titleLabel = [[UILabel alloc] init];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.axcUI_Size = CGSizeMake(kScreenWidth - 50, 44);
    self.titleLabel.center = self.center;
    self.titleLabel.layer.masksToBounds = YES;
    self.titleLabel.layer.cornerRadius = 5;
    
    [self addSubview:self.titleLabel];
    
    // 左右间距按比例增减
    [self.titleLabel AxcUI_autoresizingMaskLeftAndRight];
}


@end
