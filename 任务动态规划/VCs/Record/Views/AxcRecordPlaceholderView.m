//
//  AxcRecordPlaceholderView.m
//  任务动态规划
//
//  Created by Axc on 2017/10/14.
//  Copyright © 2017年 Axc. All rights reserved.
//

#import "AxcRecordPlaceholderView.h"

@implementation AxcRecordPlaceholderView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor AxcUI_CloudColor];
        [self createUI];
    }
    return self;
}

- (void)createUI{
    WEAK_SELF;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"现在没有任何记录哦\n\n快去添加今天的任务规划吧";
    titleLabel.numberOfLines = 0;
    titleLabel.textColor = Axc_ThemeColor;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLabel];
    
    CGFloat height = titleLabel.font.pointSize * 3 + 10;
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(kScreenWidth/2 - height/2);
        make.width.mas_equalTo(kScreenWidth - 100);
        make.height.mas_equalTo(height);
    }];
    
    UIColor *iosSystemBlue = [UIColor AxcUI_colorWithHexColor:@"1296db"];

    UIButton *goToAddEventBtn = [[UIButton alloc] init];
    goToAddEventBtn.backgroundColor = [UIColor clearColor];
    goToAddEventBtn.layer.borderWidth = 1;
    goToAddEventBtn.layer.borderColor = [iosSystemBlue CGColor];
    goToAddEventBtn.layer.masksToBounds = YES;
    goToAddEventBtn.layer.cornerRadius = 5;
    goToAddEventBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [goToAddEventBtn setTitleColor:iosSystemBlue forState:UIControlStateNormal];
    [goToAddEventBtn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [goToAddEventBtn addTarget:self action:@selector(clickgoToAddEventBtn) forControlEvents:UIControlEventTouchUpInside];
    
    [goToAddEventBtn setTitle:@"去添加任务" forState:UIControlStateNormal];
    [self addSubview:goToAddEventBtn];
    
    [goToAddEventBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(titleLabel.mas_bottom).offset(30);
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(150);
        make.height.mas_equalTo(44);
    }];
}

- (void)clickgoToAddEventBtn{
    if (self.clickgoToAddEventBtnBlock) {
        self.clickgoToAddEventBtnBlock();
    }
}

@end
