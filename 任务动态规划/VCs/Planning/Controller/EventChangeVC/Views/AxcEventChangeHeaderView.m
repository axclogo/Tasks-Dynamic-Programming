//
//  AxcEventChangeHeaderView.m
//  任务动态规划
//
//  Created by Axc on 2017/10/13.
//  Copyright © 2017年 Axc. All rights reserved.
//

#import "AxcEventChangeHeaderView.h"

@implementation AxcEventChangeHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {

    }
    return self;
}

- (void)setTitle:(NSString *)title{
    _title = title;
    
    self.titleLabel.text = _title;
    self.titleLabel.axcUI_Width = [_title AxcUI_widthWithStringFont:self.titleLabel.font];

}


- (AxcUI_Label *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[AxcUI_Label alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont fontWithName:@"Arial-BoldItalicMT"size:20];
        _titleLabel.axcUI_textEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        
        [self addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            AxcWholeFrameLayout;
        }];
    }
    return _titleLabel;
}

@end
