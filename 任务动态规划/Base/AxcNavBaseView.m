//
//  AxcNavBaseView.m
//  任务动态规划
//
//  Created by Axc on 2017/9/29.
//  Copyright © 2017年 Axc. All rights reserved.
//

#import "AxcNavBaseView.h"

@implementation AxcNavBaseView




- (AxcUI_Label *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[AxcUI_Label alloc] init];
        _titleLabel.backgroundColor = [UIColor whiteColor];
        _titleLabel.textColor = [UIColor AxcUI_ConcreteColor];
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.textAlignment =NSTextAlignmentCenter;
        
        _titleLabel.layer.shadowColor = [UIColor blackColor].CGColor;
        _titleLabel.layer.shadowOffset = CGSizeMake(1,0);
        _titleLabel.layer.shadowOpacity = 0.7;
        _titleLabel.layer.shadowRadius = 2;
        
        [self addSubview:_titleLabel];
        
        [_titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.height.mas_equalTo(30);
        }];
        
    }
    return _titleLabel;
}

@end
